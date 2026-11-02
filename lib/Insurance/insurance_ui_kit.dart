import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import '../utilities/heic_converter.dart';

/// Shared light-theme tokens + reusable widgets for the redesigned
/// Insurance Add/Update flow (2026-10-16 redesign, "step-by-step +
/// minimal required fields" request). Pulled into its own file so the
/// Add wizard, Update form, and (lightly) the Admin list screens can all
/// draw from one palette instead of three independently-hardcoded ones
/// (the old Add/Update forms each had their own dark "premium header"
/// gradient, and Admin's list screen had a third, different one again).
///
/// Contrast notes (WCAG AA, 4.5:1 minimum for normal text):
/// - `textPrimary` (#1A1D23) on `surface`/`bg` (white / #F6F7F9): ~16:1
/// - `textSecondary` (#5B6472) on `surface`/`bg`: ~7.1:1
/// - white text on `primary` (#2F6FED) button fill: ~4.6:1
/// - `error`/`success`/`warning` text on their own `*Bg` tint, or on
///   `surface`: all above 4.5:1 at the weights/sizes used below.
/// Forces typed text to uppercase as the user types -- used for the
/// Vehicle Number field across the Insurance Add/Update forms, since
/// vehicle registration numbers are conventionally written in capitals
/// (e.g. "DL01AB1234") and the backend/search matching assumes that
/// casing too.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Formats any date string the Insurance backend hands back into one
/// consistent "16 Oct 2026" style, regardless of which of the several
/// formats different endpoints happen to use (`current_dates` is stored
/// as "yyyy-MM-dd HH:mm:ss", `next_renew_date` as "dd-MM-yyyy", and a
/// few screens fall back to ISO 8601) -- used everywhere a date is shown
/// in the Insurance section so dates read the same way on every card and
/// detail screen instead of each file formatting dates differently.
/// Returns an empty string for a null/blank input (so callers like
/// InsInfoRow can hide the row), and falls back to the raw string for a
/// value that doesn't match any known format rather than silently
/// hiding real data.
String formatInsuranceDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '';
  final value = raw.trim();
  const formats = [
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-dd',
    'dd-MM-yyyy',
    'dd/MM/yyyy',
    'MM/dd/yyyy',
  ];
  for (final fmt in formats) {
    try {
      final parsed = DateFormat(fmt).parseStrict(value);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      // try the next format
    }
  }
  final iso = DateTime.tryParse(value);
  if (iso != null) return DateFormat('dd MMM yyyy').format(iso);
  return value;
}

/// Parses an Insurance-backend date string into a [DateTime]. Tries the
/// same format list as `formatInsuranceDate()` PLUS `dd-MMM-yyyy`
/// (confirmed 2026-10-23 as `INSURANCE_UPTO`'s real format, e.g.
/// "25-Jul-2027" -- `formatInsuranceDate()` itself doesn't need this
/// extra format added since its final ISO/raw-string fallback already
/// handles anything unmatched by just echoing it back; this parser
/// needs an exact match to produce a usable [DateTime]). Returns null
/// for a blank value or one matching no known format -- used to compute
/// days-remaining/expired status from `INSURANCE_UPTO`.
DateTime? parseInsuranceDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final value = raw.trim();
  const formats = [
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-dd',
    'dd-MM-yyyy',
    'dd-MMM-yyyy',
    'dd/MM/yyyy',
    'MM/dd/yyyy',
  ];
  for (final fmt in formats) {
    try {
      return DateFormat(fmt).parseStrict(value);
    } catch (_) {
      // try the next format
    }
  }
  return DateTime.tryParse(value);
}

/// Three-way insurance-expiry status derived from `INSURANCE_UPTO`, used
/// to colour-code list cards and the status filter tabs: red once the
/// policy has lapsed, yellow inside its last 3 months (<=90 days), green
/// beyond that, and `unknown` when the date is missing/unparseable.
enum InsuranceExpiryStatus { expired, nearToExpire, active, unknown }

/// Resolves `INSURANCE_UPTO` to the next occurrence of its day+month,
/// ignoring the year actually stored. 2026-10-31 revision: the stored
/// year is unreliable/not what matters here, so this rebuilds the
/// expiry as a recurring annual date -- day+month combined with the
/// CURRENT year, rolled forward to next year if that candidate date has
/// already passed. Today itself (candidate == today) counts as "not
/// yet passed", so it stays in the current year with 0 days remaining,
/// per the explicit same-day rule. Null when the date is
/// missing/unparseable.
DateTime? insuranceResolvedExpiryDate(String? insuranceUptoRaw) {
  final parsed = parseInsuranceDate(insuranceUptoRaw);
  if (parsed == null) return null;
  final now = DateTime.now();
  final todayDateOnly = DateTime(now.year, now.month, now.day);
  var candidate = DateTime(now.year, parsed.month, parsed.day);
  if (candidate.isBefore(todayDateOnly)) {
    candidate = DateTime(now.year + 1, parsed.month, parsed.day);
  }
  return candidate;
}

/// "dd MMM yyyy" text for [insuranceResolvedExpiryDate] -- the day+month
/// from `INSURANCE_UPTO` paired with the resolved (current- or
/// next-year) year, NOT the year actually stored in the backend value.
String insuranceExpiryDisplayDate(String? insuranceUptoRaw) {
  final date = insuranceResolvedExpiryDate(insuranceUptoRaw);
  if (date == null) return '';
  return DateFormat('dd MMM yyyy').format(date);
}

/// Whole days remaining until [insuranceResolvedExpiryDate] (negative
/// once lapsed -- in practice this should rarely go negative now, since
/// the resolved date always rolls forward to next year once the
/// day+month has passed this year; 0 on the same-day case). Null when
/// the date is missing/unparseable. Compares calendar dates only
/// (ignores time-of-day) so "today" never reads as -0/+0 ambiguity.
int? insuranceRemainingDays(String? insuranceUptoRaw) {
  final expiry = insuranceResolvedExpiryDate(insuranceUptoRaw);
  if (expiry == null) return null;
  final today = DateTime.now();
  final todayDateOnly = DateTime(today.year, today.month, today.day);
  return expiry.difference(todayDateOnly).inDays;
}

/// Buckets [insuranceRemainingDays] into the three-colour status.
InsuranceExpiryStatus insuranceExpiryStatusFor(String? insuranceUptoRaw) {
  final days = insuranceRemainingDays(insuranceUptoRaw);
  if (days == null) return InsuranceExpiryStatus.unknown;
  if (days < 0) return InsuranceExpiryStatus.expired;
  if (days <= 90) return InsuranceExpiryStatus.nearToExpire;
  return InsuranceExpiryStatus.active;
}

/// Badge tone matching [insuranceExpiryStatusFor]'s colour-coding
/// (error=red, warning=yellow, success=green, neutral=unknown).
InsBadgeTone insuranceExpiryTone(InsuranceExpiryStatus status) {
  switch (status) {
    case InsuranceExpiryStatus.expired:
      return InsBadgeTone.error;
    case InsuranceExpiryStatus.nearToExpire:
      return InsBadgeTone.warning;
    case InsuranceExpiryStatus.active:
      return InsBadgeTone.success;
    case InsuranceExpiryStatus.unknown:
      return InsBadgeTone.neutral;
  }
}

/// Icon matching [insuranceExpiryStatusFor], used on the card badge.
IconData insuranceExpiryIcon(InsuranceExpiryStatus status) {
  switch (status) {
    case InsuranceExpiryStatus.expired:
      return Icons.error_outline_rounded;
    case InsuranceExpiryStatus.nearToExpire:
      return Icons.warning_amber_rounded;
    case InsuranceExpiryStatus.active:
      return Icons.verified_outlined;
    case InsuranceExpiryStatus.unknown:
      return Icons.help_outline_rounded;
  }
}

/// Short label for [insuranceExpiryStatusFor] -- also used as the
/// filter-tab labels ("All" is handled by the caller, not this).
String insuranceExpiryStatusLabel(InsuranceExpiryStatus status) {
  switch (status) {
    case InsuranceExpiryStatus.expired:
      return 'Expired';
    case InsuranceExpiryStatus.nearToExpire:
      return 'Near to Expire';
    case InsuranceExpiryStatus.active:
      return 'Active';
    case InsuranceExpiryStatus.unknown:
      return 'No Expiry Date';
  }
}

/// Full status + remaining-days text for a list card, e.g.
/// "Active \u00b7 128 days left", "Near to Expire \u00b7 42 days left", or
/// "Expired 10 days ago". Falls back to just the label when the date is
/// unknown.
String insuranceExpiryCardText(String? insuranceUptoRaw) {
  final status = insuranceExpiryStatusFor(insuranceUptoRaw);
  final days = insuranceRemainingDays(insuranceUptoRaw);
  if (status == InsuranceExpiryStatus.unknown || days == null) {
    return insuranceExpiryStatusLabel(status);
  }
  if (status == InsuranceExpiryStatus.expired) {
    final agoLabel = days.abs() == 1 ? 'day' : 'days';
    return 'Expired ${days.abs()} $agoLabel ago';
  }
  final leftLabel = days == 1 ? 'day' : 'days';
  return '${insuranceExpiryStatusLabel(status)} \u00b7 $days $leftLabel left';
}

/// Same as [insuranceExpiryCardText] but WITHOUT the leading status word
/// ("Active"/"Near to Expire") -- just the day count, e.g. "128 days
/// left" instead of "Active \u00b7 128 days left". Added 2026-10-23 for
/// the admin "Insurance Records" mini-card, which the user asked to show
/// only the remaining days, not the status label (the colour of the
/// badge itself already conveys the status). "Expired <n> days ago" and
/// "No Expiry Date" are kept as-is rather than stripped further -- for
/// an expired policy the word "Expired" is what tells the days count is
/// in the past rather than the future, so dropping it would make the
/// number ambiguous; "No Expiry Date" has no day count to show at all.
String insuranceRemainingDaysLabel(String? insuranceUptoRaw) {
  final status = insuranceExpiryStatusFor(insuranceUptoRaw);
  final days = insuranceRemainingDays(insuranceUptoRaw);
  if (status == InsuranceExpiryStatus.unknown || days == null) {
    return insuranceExpiryStatusLabel(status);
  }
  if (status == InsuranceExpiryStatus.expired) {
    final agoLabel = days.abs() == 1 ? 'day' : 'days';
    return 'Expired ${days.abs()} $agoLabel ago';
  }
  final leftLabel = days == 1 ? 'day' : 'days';
  return '$days $leftLabel left';
}

/// Colour-coded status filter chips shown below the search bar on the
/// Insurance list screens (field-worker + admin) -- narrows the list to
/// Active / Near to Expire / Expired on top of the text search, reusing
/// the same tone mapping as the card badges so colours stay consistent.
class InsuranceStatusFilterBar extends StatelessWidget {
  const InsuranceStatusFilterBar({super.key, required this.selected, required this.onChanged});

  /// null means "All".
  final InsuranceExpiryStatus? selected;
  final ValueChanged<InsuranceExpiryStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = <InsuranceExpiryStatus?>[
      null,
      InsuranceExpiryStatus.active,
      InsuranceExpiryStatus.nearToExpire,
      InsuranceExpiryStatus.expired,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((status) {
          final isSelected = selected == status;
          Color fg;
          Color bg;
          if (status == null) {
            fg = InsColors.primary;
            bg = InsColors.primary.withOpacity(0.1);
          } else {
            switch (insuranceExpiryTone(status)) {
              case InsBadgeTone.success:
                fg = InsColors.success;
                bg = InsColors.successBg;
                break;
              case InsBadgeTone.warning:
                fg = InsColors.warning;
                bg = InsColors.warningBg;
                break;
              case InsBadgeTone.error:
                fg = InsColors.error;
                bg = InsColors.errorBg;
                break;
              default:
                fg = InsColors.textSecondary;
                bg = InsColors.bg;
            }
          }
          final label = status == null ? 'All' : insuranceExpiryStatusLabel(status);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? fg : bg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: fg.withOpacity(isSelected ? 1 : 0.35)),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ===================== Vehicle Info API (RTO Sarthi) support =====================
// Added for the fetch-first Insurance redesign: on "Fetch Details", check
// our own DB first via `check_vehicle.php`, and only call the paid RTO
// Sarthi vehicle-info API -- through our own `rto_fetch_service.php`
// server-side proxy, which is the only place the provider's API token is
// ever used -- when the plate isn't already on file. See the project doc
// "Vehicle_Info_API_Insurance_Redesign_Spec.md" for the full design this
// implements; this file only has the Flutter side, since no backend
// source exists in this repo to also build/deploy the PHP endpoints.
//
// **2026-10-22 TEMP bypass**: per the user's explicit request, the DB
// check is currently skipped entirely and the paid API is called
// directly from this app on every "Fetch Details" tap -- see the note
// above [fetchVehicleDetails] for the full reasoning and the security
// tradeoff this was told to and accepted by the user.

enum VehicleFetchStatus {
  idle,
  checkingInternal,
  foundInternal,
  checkingExternal,
  foundExternal,
  quotaExhausted,
  notFoundExternal,
  error,
}

/// The paid RTO Sarthi API's own per-call quota counters, straight off
/// its response's `usage` object (`{"limit": 1, "used": 1, "remaining": 0}`)
/// -- shown to the field worker via a small popup (2026-10-22, "show the
/// usage data of RTO API if data came from paid API") so they can see at
/// a glance how much of the daily/monthly allowance that one lookup just
/// spent, without needing an admin screen for it.
class RtoApiUsage {
  final int? limit;
  final int? used;
  final int? remaining;
  const RtoApiUsage({this.limit, this.used, this.remaining});

  factory RtoApiUsage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RtoApiUsage();
    int? asInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '');
    return RtoApiUsage(limit: asInt(json['limit']), used: asInt(json['used']), remaining: asInt(json['remaining']));
  }

  bool get hasAny => limit != null || used != null || remaining != null;
}

class VehicleLookupResult {
  final VehicleFetchStatus status;
  final Map<String, dynamic>? record; // DB row (foundInternal) or API `data` object (foundExternal)
  final bool fromApi;
  final String? message;
  final RtoApiUsage? usage; // only ever set when this result came from the paid API
  const VehicleLookupResult({required this.status, this.record, this.fromApi = false, this.message, this.usage});
}

/// **2026-10-22 bypass reverted, DB-first check reinstated** against the
/// now-confirmed real internal endpoint: `show_api_base_on_vehicleNumber.php`
/// (same base as `insert_insurance.php`), query param `vehicleNumber`,
/// response `{status, message, count, data: [ {...} ]}` -- note `data` is
/// a LIST (possibly empty), not a single object, and most RTO_* fields on
/// an existing row can legitimately be `null` right now ("the table don't
/// have real row so this is null data but it comes correct later" -- the
/// user's own words) -- that's still a real "found" row, not a miss, so a
/// present-but-mostly-null `data[0]` is still `foundInternal`, never
/// treated as not-found. `check_vehicle_TEMP_PLACEHOLDER.php` below is
/// now fully superseded and unused -- kept only as a historical marker of
/// the placeholder it replaced.
const String vehicleLookupEndpointPath = 'check_vehicle_TEMP_PLACEHOLDER.php';

/// Real, confirmed internal lookup endpoint (2026-10-22) -- always called
/// FIRST, for free, before ever spending a paid RTO Sarthi call.
const String internalCheckEndpointPath = 'show_api_base_on_vehicleNumber.php';

/// **SECURITY NOTE, explicitly accepted by the user (2026-10-22):** this
/// paid API key ships inside the app binary and is extractable by anyone
/// who decompiles it -- the tradeoff of calling the third-party API
/// directly from Flutter instead of through a server-side proxy that
/// never exposes the key to the client. The user was told this plainly
/// and chose to proceed anyway. It's now only reached as a FALLBACK, when
/// our own free internal check above comes back empty -- still worth
/// moving server-side eventually, but less exposure than when it was the
/// only lookup path.
const String rtoSarthiApiKey = 'rts_79d8af3ca8a6d69ae71164b62a1378f2de22e872e4961252';
const String rtoSarthiVehicleInfoUrl = 'https://api.rtosarthi.com/api/v1/vehicle-info';

Future<VehicleLookupResult> fetchVehicleDetails({
  required String baseUrl,
  required String vehicleNumber,
  required String fieldWorkerNumber,
}) async {
  final vno = vehicleNumber.trim().toUpperCase().replaceAll(RegExp(r'[\s-]'), '');

  // Step 1 -- check our own DB first, for free, always.
  try {
    final dbResponse = await http.get(
      Uri.parse('$baseUrl' '$internalCheckEndpointPath?vehicleNumber=$vno'),
    );
    final dbJson = jsonDecode(dbResponse.body) as Map<String, dynamic>;
    final dbData = dbJson['data'];
    if (dbJson['status'] == true && dbData is List && dbData.isNotEmpty) {
      return VehicleLookupResult(
        status: VehicleFetchStatus.foundInternal,
        record: dbData.first as Map<String, dynamic>,
      );
    }
    // status:false or an empty data list both mean "not on file" -- fall
    // through to the paid API below, same as a found:false would have.
  } catch (e) {
    // A transient failure on our own free check should not block the
    // field worker from still getting results via the paid search --
    // fall through rather than surfacing this as a hard error.
  }

  // Step 2 -- not on file internally (or the check itself failed) -- the
  // paid RTO Sarthi API is the fallback, never the first call.
  try {
    final response = await http.get(
      Uri.parse('$rtoSarthiVehicleInfoUrl?vno=$vno'),
      headers: {'x-api-key': rtoSarthiApiKey},
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['success'] == true) {
      return VehicleLookupResult(
        status: VehicleFetchStatus.foundExternal,
        record: json['data'] as Map<String, dynamic>?,
        fromApi: true,
        usage: json['usage'] is Map<String, dynamic> ? RtoApiUsage.fromJson(json['usage'] as Map<String, dynamic>) : null,
      );
    }
    // Confirmed failure envelope: {"success": false, "message": "..."}
    // (e.g. "Invalid API key"). The provider gives no separate
    // machine-readable reason code for quota-exhausted vs. not-found vs.
    // a hard error, so this infers the reason from the message text --
    // a heuristic, not a confirmed contract (same caveat as the rest of
    // this file's quota/not-found handling).
    final message = json['message'] as String? ?? 'Could not reach the vehicle registry.';
    final lower = message.toLowerCase();
    if (lower.contains('quota') || lower.contains('limit')) {
      return VehicleLookupResult(status: VehicleFetchStatus.quotaExhausted, message: message);
    }
    if (lower.contains('not found') || lower.contains('no record') || lower.contains('invalid vehicle')) {
      return VehicleLookupResult(status: VehicleFetchStatus.notFoundExternal, message: message);
    }
    return VehicleLookupResult(status: VehicleFetchStatus.error, message: message);
  } catch (e) {
    return VehicleLookupResult(status: VehicleFetchStatus.error, message: 'Could not reach the vehicle registry.');
  }
}

enum InsFieldFormat { text, date, monthYear, number }

/// How one field renders inside its section card (2026-10-22 restyle,
/// matching a reference RTO-lookup app's UI): [row] is the plain
/// label-above/value-below line every field used before; [chip] is a
/// full-width light-grey rounded box (used for long identifier values
/// like Chassis/Engine/Policy Number, which read better in their own
/// box than squeezed into a label/value line); [compact] fields are
/// paired up two-at-a-time into a row of two smaller chips (used for
/// short values like Cubic Capacity/Fuel Norms or Mfg Month-Year/
/// Seating Capacity, so they don't each burn a full-width row).
enum InsFieldDisplay { row, chip, compact }

/// One field inside a dynamic Vehicle Info section -- see [vehicleInfoSections].
class InsFieldConfig {
  final String label;
  final String apiKey; // key as returned by the RTO Sarthi `data` object
  final String? dbKey; // key as stored in our own DB row, if different from apiKey
  final InsFieldFormat format;
  final IconData? icon; // per-field icon (2026-10-22); falls back to the section icon when unset
  final bool copyable; // shows a small copy-to-clipboard button next to the value
  final InsFieldDisplay display;
  const InsFieldConfig({
    required this.label,
    required this.apiKey,
    this.dbKey,
    this.format = InsFieldFormat.text,
    this.icon,
    this.copyable = false,
    this.display = InsFieldDisplay.row,
  });
}

class InsSectionConfig {
  final String title;
  final IconData icon;
  final List<InsFieldConfig> fields;
  final String? badge; // short pill label shown top-right of the card, e.g. "Identity"
  final InsBadgeTone badgeTone;
  const InsSectionConfig({
    required this.title,
    required this.icon,
    required this.fields,
    this.badge,
    this.badgeTone = InsBadgeTone.primary,
  });
}

/// **2026-10-22 correction**: these field keys now match the REAL backend
/// exactly, confirmed by the user from the live `insert_insurance.php`
/// endpoint's accepted field list -- not the invented snake_case column
/// names (`chasi_no`, `rto_owner_name`, etc.) this file originally used.
/// The real backend stores every RTO field under its own raw name (e.g.
/// `CHASI_NO`, `OWNER_NAME`), so `apiKey` and `dbKey` are now identical
/// for virtually every field -- `dbKey` is left unset throughout (meaning
/// "same as apiKey") rather than removed from [InsFieldConfig], in case a
/// future field genuinely needs the two to differ again.
///
/// Grouped exactly as both the Add form's post-fetch preview and the
/// Detail page render them (both call [buildDynamicVehicleInfoSections]
/// below), so the two can never drift apart on which fields show up
/// where.
const List<InsSectionConfig> vehicleInfoSections = [
  InsSectionConfig(
    title: 'Owner & Contact Info',
    icon: Icons.person_outline_rounded,
    badge: 'Identity',
    badgeTone: InsBadgeTone.primary,
    fields: [
      InsFieldConfig(label: 'Owner Name', apiKey: 'OWNER_NAME', icon: Icons.badge_outlined, copyable: true),
      InsFieldConfig(label: "Father's Name", apiKey: 'F_NAME', icon: Icons.person_outline_rounded),
      InsFieldConfig(label: 'Mobile Number', apiKey: 'MOBILE_NO', icon: Icons.phone_outlined, copyable: true),
      InsFieldConfig(label: 'Owner Email', apiKey: 'owner_email', icon: Icons.alternate_email_rounded, copyable: true),
      InsFieldConfig(label: 'Present Address', apiKey: 'PRESENT_ADDRESS', icon: Icons.home_outlined, copyable: true),
      InsFieldConfig(label: 'Permanent Address', apiKey: 'PERMANENT_ADDRESS', icon: Icons.home_work_outlined),
      InsFieldConfig(label: 'Owner Serial No.', apiKey: 'OWNER_SERIAL_NO', icon: Icons.tag_rounded),
      InsFieldConfig(label: 'State', apiKey: 'CURRENTADD_STATENAME', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'District Code', apiKey: 'CURRENTADD_DISTRICTCODE', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Pincode', apiKey: 'CURRENTADD_PINCODE', display: InsFieldDisplay.compact),
    ],
  ),
  InsSectionConfig(
    title: 'Engine & Vehicle Specs',
    icon: Icons.directions_car_filled_rounded,
    badge: 'Specs',
    badgeTone: InsBadgeTone.primary,
    fields: [
      InsFieldConfig(label: 'Chassis Number', apiKey: 'CHASI_NO', icon: Icons.confirmation_number_outlined, copyable: true, display: InsFieldDisplay.chip),
      InsFieldConfig(label: 'Engine Number', apiKey: 'ENG_NO', icon: Icons.settings_outlined, copyable: true, display: InsFieldDisplay.chip),
      InsFieldConfig(label: 'Maker', apiKey: 'MAKER_DESC', icon: Icons.factory_outlined),
      InsFieldConfig(label: 'Model', apiKey: 'MAKER_MODEL', icon: Icons.directions_car_outlined),
      InsFieldConfig(label: 'Body Type', apiKey: 'BODY_TYPE_DESC', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Vehicle Class', apiKey: 'VEHICLE_CLASS', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Vehicle Category', apiKey: 'VEHICLE_CATEGORY', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Commercial?', apiKey: 'IS_COMMERCIAL', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Fuel', apiKey: 'FUEL_DESC', icon: Icons.local_gas_station_outlined, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Color', apiKey: 'COLOR', icon: Icons.palette_outlined, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Mfg Month/Year', apiKey: 'MANU_MONTH_YR', format: InsFieldFormat.monthYear, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Surrendered to Dealer?', apiKey: 'VEHICLE_SURRENDERED_TO_DEALER', display: InsFieldDisplay.compact),
    ],
  ),
  InsSectionConfig(
    title: 'Registration & Authority',
    icon: Icons.assignment_outlined,
    badge: 'RTO Record',
    badgeTone: InsBadgeTone.success,
    fields: [
      InsFieldConfig(label: 'Registration No.', apiKey: 'REGN_NO', icon: Icons.pin_outlined, copyable: true),
      InsFieldConfig(label: 'Registered At', apiKey: 'REGISTERED_AT', icon: Icons.location_on_outlined),
      InsFieldConfig(label: 'Reg. Date', apiKey: 'REGN_DT', format: InsFieldFormat.date, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Reg. Valid Upto', apiKey: 'REGN_UPTO', format: InsFieldFormat.date, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'State Code', apiKey: 'STATE_CD', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'RTO Code', apiKey: 'RTO_CD', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Fitness Valid Upto', apiKey: 'FIT_UPTO', format: InsFieldFormat.date, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Tax Valid Upto', apiKey: 'TAX_UPTO', format: InsFieldFormat.date, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'RC NP Number', apiKey: 'RC_NP_NO'),
      InsFieldConfig(label: 'Status', apiKey: 'STATUS', icon: Icons.verified_outlined, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Status As On', apiKey: 'STATUS_AS_ON', format: InsFieldFormat.date, display: InsFieldDisplay.compact),
    ],
  ),
  InsSectionConfig(
    title: 'Insurance Policy Details',
    icon: Icons.shield_rounded,
    badge: 'Active',
    badgeTone: InsBadgeTone.primary,
    fields: [
      InsFieldConfig(label: 'Insurance Company', apiKey: 'INSURANCE_COMP', icon: Icons.business_outlined),
      InsFieldConfig(label: 'Policy Number', apiKey: 'POLICY_NO', icon: Icons.numbers_rounded, copyable: true, display: InsFieldDisplay.chip),
      InsFieldConfig(label: 'Insurance Policy No.', apiKey: 'INS_POLICY_NO', copyable: true, display: InsFieldDisplay.chip),
      InsFieldConfig(label: 'Insurance Valid Upto', apiKey: 'INSURANCE_UPTO', format: InsFieldFormat.date, icon: Icons.event_available_outlined),
    ],
  ),
  InsSectionConfig(
    title: 'Fitness, Tax & PUC',
    icon: Icons.eco_outlined,
    badge: 'Compliance',
    badgeTone: InsBadgeTone.success,
    fields: [
      InsFieldConfig(label: 'PUC Valid Upto', apiKey: 'PUC_UPTO', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'PUCC Valid Upto', apiKey: 'PUCC_UPTO', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'PUCC Number', apiKey: 'PUCC_NO', copyable: true),
    ],
  ),
  InsSectionConfig(
    title: 'Financer, Permit & Legal',
    icon: Icons.account_balance_outlined,
    badge: 'Hypothecation',
    badgeTone: InsBadgeTone.warning,
    fields: [
      InsFieldConfig(label: 'Financer / Bank', apiKey: 'FINANCER_DETAILS', icon: Icons.account_balance_outlined),
      InsFieldConfig(label: 'Permit Number', apiKey: 'PERMIT_NO', display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Permit Issue Date', apiKey: 'PERMIT_ISSUE_DATE', format: InsFieldFormat.date, display: InsFieldDisplay.compact),
    ],
  ),
  InsSectionConfig(
    title: 'Capacity & Dimensions',
    icon: Icons.precision_manufacturing_rounded,
    badge: 'Specs',
    badgeTone: InsBadgeTone.primary,
    fields: [
      InsFieldConfig(label: 'Seating', apiKey: 'SEATING_CAPACITY', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Sleeper', apiKey: 'SLEEPER_CAPACITY', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Standing', apiKey: 'STANDING_CAPACITY', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Unladen Wt.', apiKey: 'UNLADEN_WEIGHT', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Laden Wt.', apiKey: 'LADEN_WEIGHT', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Wheelbase', apiKey: 'WHEELBASE', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Cylinders', apiKey: 'NO_OF_CYLINDERS', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Cubic Capacity', apiKey: 'CUBIC_CAPACITY', format: InsFieldFormat.number, display: InsFieldDisplay.compact),
      InsFieldConfig(label: 'Fuel Norms', apiKey: 'FUEL_NORMS', display: InsFieldDisplay.compact),
    ],
  ),
  InsSectionConfig(
    title: 'Status & Compliance',
    icon: Icons.fact_check_outlined,
    badge: 'Flags',
    badgeTone: InsBadgeTone.neutral,
    fields: [
      InsFieldConfig(label: 'Blacklist Status', apiKey: 'BLACKLIST_STATUS', icon: Icons.block_outlined),
      InsFieldConfig(label: 'NOC Details', apiKey: 'NOC_DETAILS', icon: Icons.description_outlined),
    ],
  ),
];

/// Normalizes one raw Vehicle Info API/DB value for display: treats
/// "NA"/"N/A"/"-"/blank as blank (composing with `InsInfoRow`'s existing
/// blank-hides-the-row behavior), and formats dates/month-years/numbers.
/// The Vehicle Info API does not use one consistent date format across all
/// its fields (e.g. "16-Aug-2021" vs "15-08-2036"), so every known format
/// is tried before falling back to the raw string -- nothing is ever
/// silently dropped, even if it can't be parsed.
/// Decodes the handful of HTML entities the RTO registry's own text
/// fields sometimes contain (e.g. `MAHINDRA &amp; MAHINDRA LIMITED`) --
/// the provider returns raw HTML-escaped text for maker/model names, not
/// a Flutter/Dart concern otherwise, so this is a small manual table
/// rather than pulling in a full HTML-entity package for five entities.
String decodeHtmlEntities(String text) {
  if (!text.contains('&')) return text;
  return text
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'");
}

String normalizeRtoValue(dynamic raw, InsFieldFormat format) {
  if (raw == null) return '';
  final text = decodeHtmlEntities(raw.toString().trim());
  if (text.isEmpty) return '';
  final upper = text.toUpperCase();
  if (upper == 'NA' || upper == 'N/A' || text == '-') return '';

  switch (format) {
    case InsFieldFormat.date:
      for (final fmt in ['dd-MMM-yyyy', 'dd-MM-yyyy', 'yyyy-MM-dd']) {
        try {
          final parsed = DateFormat(fmt, 'en_US').parseStrict(text);
          return DateFormat('dd MMM yyyy').format(parsed);
        } catch (_) {
          // try the next format
        }
      }
      return text;
    case InsFieldFormat.monthYear:
      try {
        final parsed = DateFormat('M/yyyy').parseStrict(text);
        return DateFormat('MMM yyyy').format(parsed);
      } catch (_) {
        return text;
      }
    case InsFieldFormat.number:
      final numericPart = RegExp(r'[-+]?[0-9]*\.?[0-9]+').firstMatch(text)?.group(0);
      return numericPart ?? text;
    case InsFieldFormat.text:
      return text;
  }
}

/// Builds the Vehicle Info section cards from a flat key/value map --
/// either the RTO Sarthi API's `data` object directly (`isFromApiPayload:
/// true`, reads each field's `apiKey`) or our own DB row (`false`, reads
/// each field's `dbKey`, falling back to `apiKey` if no `dbKey` is set).
/// Used identically by the Add form's post-fetch preview and by the
/// Detail page, so the two can never show different fields for the same
/// data. A whole section hides itself (returns nothing) if every one of
/// its fields normalizes to blank, so a vehicle with e.g. no financer
/// never shows a hollow "Financer" header with nothing under it.
class _ResolvedInsField {
  final String label;
  final String value;
  final IconData? icon;
  final bool copyable;
  const _ResolvedInsField({required this.label, required this.value, this.icon, this.copyable = false});
}

/// Lays out one section's fields, honoring each field's [InsFieldDisplay]:
/// `row`/`chip` fields render immediately (in order); consecutive
/// `compact` fields are buffered and flushed two-at-a-time into a single
/// row of two small chips (a lone trailing compact field gets a row to
/// itself rather than being dropped). A field whose value normalizes to
/// blank is skipped entirely -- same "blank hides itself" rule the old
/// per-row version had, just applied before layout instead of after.
List<Widget> _buildSectionFieldWidgets(
  List<InsFieldConfig> fields,
  Map<String, dynamic> record, {
  required bool isFromApiPayload,
  required IconData sectionIcon,
  Set<String> excludeApiKeys = const {},
}) {
  final widgets = <Widget>[];
  final compactBuffer = <_ResolvedInsField>[];

  void flushCompact() {
    if (compactBuffer.isEmpty) return;
    for (var i = 0; i < compactBuffer.length; i += 2) {
      final a = compactBuffer[i];
      final b = i + 1 < compactBuffer.length ? compactBuffer[i + 1] : null;
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _InsCompactChip(field: a)),
            if (b != null) ...[const SizedBox(width: 8), Expanded(child: _InsCompactChip(field: b))],
          ],
        ),
      ));
    }
    compactBuffer.clear();
  }

  for (final f in fields) {
    if (excludeApiKeys.contains(f.apiKey)) continue;
    final rawKey = isFromApiPayload ? f.apiKey : (f.dbKey ?? f.apiKey);
    final value = normalizeRtoValue(record[rawKey], f.format);
    if (value.isEmpty) continue;
    final resolved = _ResolvedInsField(label: f.label, value: value, icon: f.icon ?? sectionIcon, copyable: f.copyable);
    if (f.display == InsFieldDisplay.compact) {
      compactBuffer.add(resolved);
      continue;
    }
    flushCompact();
    if (f.display == InsFieldDisplay.chip) {
      widgets.add(_InsChipField(field: resolved));
    } else {
      widgets.add(InsInfoRow(label: resolved.label, value: resolved.value, icon: resolved.icon, copyable: resolved.copyable));
    }
  }
  flushCompact();
  return widgets;
}

List<Widget> buildDynamicVehicleInfoSections(
  Map<String, dynamic> record, {
  required bool isFromApiPayload,
  // **2026-10-22**: lets a caller drop specific RTO-keyed fields that it
  // already renders elsewhere on the same screen (e.g. the Detail page's
  // own Policy Holder / vehicle header cards show OWNER_NAME/MOBILE_NO/
  // owner_email/OWNER_SERIAL_NO already) -- the Add form's lookup-result
  // usage (`buildVehicleInfoSectionsRow`) doesn't pass this, so its
  // display is unaffected.
  Set<String> excludeApiKeys = const {},
}) {
  final widgets = <Widget>[];
  for (final section in vehicleInfoSections) {
    final rows = _buildSectionFieldWidgets(
      section.fields,
      record,
      isFromApiPayload: isFromApiPayload,
      sectionIcon: section.icon,
      excludeApiKeys: excludeApiKeys,
    );
    if (rows.isEmpty) continue;
    widgets.add(InsSectionCard(
      title: section.title,
      icon: section.icon,
      badge: section.badge,
      badgeTone: section.badgeTone,
      children: rows,
    ));
  }
  return widgets;
}

/// Same sections as [buildDynamicVehicleInfoSections] above, laid out as
/// a single horizontally-scrolling row of fixed-width cards instead of a
/// vertical stack -- used on the Add form's Fetch Details preview
/// (2026-10-22, requested so a vehicle with many populated sections
/// doesn't make the whole Add Insurance form scroll on forever
/// vertically). The Detail page keeps the vertical version unchanged --
/// this was asked specifically for "the fetch details cards", not every
/// place these sections render. `IntrinsicHeight` sizes the row to its
/// tallest card (section field counts vary), and each card gets a fixed
/// [cardWidth] so the strip reads as a consistent horizontal "deck"
/// rather than cards of mismatched widths.
Widget buildVehicleInfoSectionsRow(
  Map<String, dynamic> record, {
  required bool isFromApiPayload,
  double cardWidth = 280,
}) {
  final cards = buildDynamicVehicleInfoSections(record, isFromApiPayload: isFromApiPayload);
  if (cards.isEmpty) return const SizedBox.shrink();
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(bottom: 4),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final card in cards)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(width: cardWidth, child: card),
            ),
        ],
      ),
    ),
  );
}


/// Dark gradient summary card shown at the top of the Insurance Detail
/// page (2026-10-22 restyle, matching a reference RTO-lookup app's UI):
/// plate number, maker/model title, owner name + serial badge, a
/// status pill and a vehicle-category pill, then a fuel/color/category
/// line. Reads straight off the same RTO-keyed map the section cards
/// below it use ([InsuranceModel.toVehicleInfoMap] on the Detail page,
/// or the API `data` object on the Add form), so it never drifts out of
/// sync with whichever fields are actually populated.
class InsVehicleHeaderCard extends StatelessWidget {
  const InsVehicleHeaderCard({super.key, required this.record});

  final Map<String, dynamic> record;

  String _v(String key, [InsFieldFormat format = InsFieldFormat.text]) =>
      normalizeRtoValue(record[key], format);

  @override
  Widget build(BuildContext context) {
    final plate = _v('REGN_NO');
    final maker = _v('MAKER_DESC');
    final model = _v('MAKER_MODEL');
    final title = [maker, model].where((e) => e.isNotEmpty).join(' ');
    final owner = _v('OWNER_NAME');
    final ownerSerial = _v('OWNER_SERIAL_NO');
    final status = _v('STATUS');
    final vehicleClass = _v('VEHICLE_CLASS');
    final fuel = _v('FUEL_DESC');
    final color = _v('COLOR');
    final isCommercial = _v('IS_COMMERCIAL');

    Widget darkPill(String label, {Color? fg, Color? bg, IconData? icon}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: bg ?? Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 13, color: fg ?? Colors.white), const SizedBox(width: 4)],
            Text(label, style: TextStyle(color: fg ?? Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ],
        ),
      );
    }

    if (plate.isEmpty && title.isEmpty && owner.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF151A33), Color(0xFF2B2F6E)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plate.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      plate,
                      style: const TextStyle(color: InsColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CopyIconButton(value: plate),
                ],
              ),
            ),
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18.5, fontWeight: FontWeight.w800, height: 1.25),
              ),
            ),
          if (owner.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Flexible(
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'Owner: ', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        TextSpan(text: owner, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                      ]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (ownerSerial.isNotEmpty) ...[const SizedBox(width: 8), darkPill('Owner #$ownerSerial')],
                ],
              ),
            ),
          if (status.isNotEmpty || vehicleClass.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (status.isNotEmpty)
                    darkPill(
                      'STATUS: ${status.toUpperCase()}',
                      fg: const Color(0xFF34D399),
                      bg: const Color(0xFF34D399).withOpacity(0.16),
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  if (vehicleClass.isNotEmpty) darkPill(vehicleClass),
                ],
              ),
            ),
          if (fuel.isNotEmpty || color.isNotEmpty || isCommercial.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  if (fuel.isNotEmpty) const Icon(Icons.local_gas_station_rounded, size: 14, color: Colors.white70),
                  if (fuel.isNotEmpty) const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      [fuel, color, if (isCommercial.isNotEmpty) (isCommercial == '0' ? 'Private' : 'Commercial')]
                          .where((e) => e.isNotEmpty)
                          .join('  ·  '),
                      style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


/// Small info-icon button shown next to the "Fetched from Vehicle
/// Registry" badge whenever a lookup actually spent a paid API call --
/// tapping it opens a compact popup with that call's own quota counters
/// (`RtoApiUsage`), so the field worker can see the daily/monthly
/// allowance usage without an admin screen.
class RtoUsageIconButton extends StatelessWidget {
  const RtoUsageIconButton({super.key, required this.usage});
  final RtoApiUsage usage;

  void _show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: InsColors.surface,
        surfaceTintColor: InsColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: const [
            Icon(Icons.data_usage_rounded, color: InsColors.primary, size: 20),
            SizedBox(width: 8),
            Text('API Usage', style: TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InsInfoRow(label: 'Limit', value: usage.limit?.toString() ?? '-'),
            InsInfoRow(label: 'Used', value: usage.used?.toString() ?? '-'),
            InsInfoRow(label: 'Remaining', value: usage.remaining?.toString() ?? '-'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: InsColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!usage.hasAny) return const SizedBox.shrink();
    return InkWell(
      onTap: () => _show(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: InsColors.primary.withOpacity(0.1), shape: BoxShape.circle),
        child: const Icon(Icons.data_usage_rounded, size: 14, color: InsColors.primary),
      ),
    );
  }
}

class InsColors {
  InsColors._();

  static const Color bg = Color(0xFFF6F7F9); // page background
  static const Color surface = Colors.white; // cards / inputs
  static const Color border = Color(0xFFE1E4EA);
  static const Color borderFocus = Color(0xFF2F6FED);

  static const Color textPrimary = Color(0xFF1A1D23);
  static const Color textSecondary = Color(0xFF5B6472);
  static const Color textMuted = Color(0xFF8A919E);

  // Same blue the app already uses for its "Owner Calls" action
  // elsewhere (`admin_target_and_tasks_home.dart`) -- reused here rather
  // than inventing a new brand color.
  static const Color primary = Color(0xFF2F6FED);
  static const Color primaryDark = Color(0xFF1E54C9);

  static const Color success = Color(0xFF15803D);
  static const Color successBg = Color(0xFFEAF7EF);
  static const Color warning = Color(0xFFB45309);
  static const Color warningBg = Color(0xFFFEF3E2);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFDECEC);
}

String? insRequired(String? v) =>
    (v == null || v.trim().isEmpty) ? 'This field is required' : null;

String? insPhoneValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Phone number is required';
  final digits = v.trim();
  if (digits.length != 10 || int.tryParse(digits) == null) {
    return 'Enter a valid 10-digit phone number';
  }
  return null;
}

// Owner email is entered manually (2026-10-22) -- optional, but validated
// for a plausible shape when the field worker does fill it in.
String? insEmailValidator(String? v) {
  if (v == null || v.trim().isEmpty) return null;
  final text = v.trim();
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
    return 'Enter a valid email address';
  }
  return null;
}

/// "Step X of Y" label + a segmented progress bar (one filled segment per
/// completed/current step). Deliberately plain, not the dot-row style
/// `add_flat_form.dart` uses -- the written "Step X of Y" text was asked
/// for explicitly, and a segmented bar reads clearer than dots once a
/// step title is shown alongside it.
class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.stepTitles,
  });

  final int currentStep;
  final List<String> stepTitles;

  @override
  Widget build(BuildContext context) {
    final total = stepTitles.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${currentStep + 1} of $total',
              style: const TextStyle(
                color: InsColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
            Text(
              stepTitles[currentStep],
              style: const TextStyle(
                color: InsColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(total, (i) {
            final done = i <= currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
                height: 6,
                decoration: BoxDecoration(
                  color: done ? InsColors.primary : InsColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class InsTextField extends StatelessWidget {
  const InsTextField({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final bool required;
  final TextInputType keyboardType;
  final int? maxLength;
  final String? hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label, required: required),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            style: const TextStyle(color: InsColors.textPrimary, fontSize: 14.5),
            decoration: _fieldDecoration(hint: hint, suffixIcon: suffixIcon),
            validator: validator,
          ),
        ],
      ),
    );
  }
}

class InsDropdownField extends StatelessWidget {
  const InsDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.required = false,
    this.hint,
    this.validator,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool required;
  final String? hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label, required: required),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            // Force a light dropdown + black item text regardless of the
            // device/app theme, so the menu always matches this section's
            // light theme instead of inheriting a dark popup background.
            dropdownColor: InsColors.surface,
            style: const TextStyle(color: InsColors.textPrimary, fontSize: 14),
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(color: InsColors.textPrimary, fontSize: 14)),
                    ))
                .toList(),
            onChanged: onChanged,
            validator: validator,
            decoration: _fieldDecoration(hint: hint),
          ),
        ],
      ),
    );
  }
}

class InsYesNoRow extends StatelessWidget {
  const InsYesNoRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value; // "Yes" | "No"
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(String v) {
      final selected = value == v;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(v),
          child: Container(
            margin: EdgeInsets.only(right: v == 'Yes' ? 8 : 0),
            padding: const EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? InsColors.primary.withOpacity(0.08) : InsColors.surface,
              border: Border.all(
                color: selected ? InsColors.primary : InsColors.border,
                width: selected ? 1.4 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              v,
              style: TextStyle(
                color: selected ? InsColors.primary : InsColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label, required: false),
          const SizedBox(height: 6),
          Row(children: [chip('Yes'), chip('No')]),
        ],
      ),
    );
  }
}

class InsSectionCard extends StatelessWidget {
  const InsSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.subtitle,
    this.badge,
    this.badgeTone = InsBadgeTone.primary,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final String? badge;
  final InsBadgeTone badgeTone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: InsColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: InsColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: InsColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: InsColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14.5)),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(subtitle!, style: const TextStyle(color: InsColors.textSecondary, fontSize: 11.5)),
                      ),
                  ],
                ),
              ),
              if (badge != null) ...[const SizedBox(width: 8), InsBadge(label: badge!, tone: badgeTone)],
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// One optional-document upload cell. Empty state is a large tappable
/// "drop zone" card (the closest mobile equivalent of a web drag-and-drop
/// zone -- there's no OS-level drag-and-drop between apps on a phone, so
/// this gives the same "obviously droppable" visual language via a big
/// tap target + icon + guidance text instead). Filled state switches to a
/// compact row with a thumbnail, filename/status, and a Remove (X)
/// button -- or, for an already-uploaded file on the Update form
/// (`existingUrl`), the same compact row loading that URL instead of a
/// local `File`.
/// Shows a bottom sheet letting the field worker choose how to supply a
/// document for ANY Insurance upload tile -- a live Camera photo, an
/// existing Gallery image, or a PDF file via Browse Files. Added
/// 2026-11-02 per the user's request that every document upload (both
/// the Add form and the Update form, including the new Yearly Documents
/// feature) offer all three sources, rather than always opening the
/// Gallery picker directly as every `_pickSingle` used to.
///
/// Camera/Gallery picks go through [HeicConverter.pickImage] so an
/// iPhone's HEIC capture is converted to JPG first, exactly like every
/// other image pick already in this app. Browse Files is restricted to
/// `.pdf` -- the one non-image format these document fields ever need
/// (policy/RC/Aadhar/etc. scans, and the new Yearly Documents PDFs).
/// Returns null if the sheet is dismissed or the chosen picker itself
/// returns nothing.
Future<File?> pickInsuranceDocument(BuildContext context) async {
  final source = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: InsColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
    builder: (ctx) {
      Widget sourceTile(IconData icon, String label, String value) {
        return ListTile(
          leading: Icon(icon, color: InsColors.primary),
          title: Text(label, style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          onTap: () => Navigator.of(ctx).pop(value),
        );
      }
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: InsColors.border, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 6),
            sourceTile(Icons.photo_camera_outlined, 'Camera', 'camera'),
            sourceTile(Icons.photo_library_outlined, 'Gallery', 'gallery'),
            sourceTile(Icons.description_outlined, 'Browse Files (PDF)', 'file'),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );

  if (source == null) return null;

  if (source == 'file') {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    final path = result?.files.single.path;
    return path == null ? null : File(path);
  }

  final picked = await HeicConverter.pickImage(
    ImagePicker(),
    source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 75,
  );
  return picked == null ? null : File(picked.path);
}

class DocumentUploadTile extends StatelessWidget {
  const DocumentUploadTile({
    super.key,
    required this.label,
    required this.onPick,
    required this.onRemove,
    this.file,
    this.existingUrl,
    this.subtitle = 'JPG or PNG, up to 5 MB',
  });

  final String label;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final File? file;
  final String? existingUrl;
  final String subtitle;

  bool get _hasAny => file != null || (existingUrl != null && existingUrl!.trim().isNotEmpty);

  /// 2026-11-02: Browse Files now lets a field worker attach a PDF to
  /// any document tile (see `pickInsuranceDocument()`), so the preview
  /// can no longer assume every `_hasAny` file/URL is an image --
  /// `Image.file`/`Image.network` would simply fail to render a PDF's
  /// bytes. Checked by file extension, same convention `HeicConverter`
  /// already uses for `.heic`/`.heif`.
  bool get _isPdf {
    final path = file?.path ?? existingUrl ?? '';
    return path.toLowerCase().endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAny) {
      return InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: InsColors.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: InsColors.border, width: 1.3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_upload_outlined, color: InsColors.primary, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12.5),
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap to upload · optional',
                style: TextStyle(color: InsColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: InsColors.textMuted, fontSize: 9.5)),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: InsColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InsColors.primary.withOpacity(0.45)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _isPdf
                ? Container(
                    width: double.infinity,
                    height: 110,
                    color: InsColors.bg,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: InsColors.error, size: 30),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            file != null ? p.basename(file!.path) : 'PDF document',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: InsColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                : (file != null
                    ? Image.file(file!, width: double.infinity, height: 110, fit: BoxFit.cover)
                    : Image.network(
                        existingUrl!,
                        width: double.infinity,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 110,
                          color: InsColors.bg,
                          alignment: Alignment.center,
                          child: const Icon(Icons.insert_drive_file_outlined, color: InsColors.textMuted),
                        ),
                      )),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 11.5),
                ),
              ),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.close_rounded, color: InsColors.error, size: 17),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration _fieldDecoration({String? hint, Widget? suffixIcon}) {
  OutlineInputBorder side(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: InsColors.textMuted, fontSize: 13.5),
    filled: true,
    fillColor: InsColors.surface,
    counterText: '',
    suffixIcon: suffixIcon,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: side(InsColors.border),
    enabledBorder: side(InsColors.border),
    focusedBorder: side(InsColors.borderFocus, 1.6),
    errorBorder: side(InsColors.error),
    focusedErrorBorder: side(InsColors.error, 1.6),
    errorStyle: const TextStyle(color: InsColors.error, fontSize: 11.5),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.required});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13.5),
        children: required
            ? const [TextSpan(text: '  *', style: TextStyle(color: InsColors.error, fontWeight: FontWeight.w700))]
            : null,
      ),
    );
  }
}

/// Label/value row used on detail screens -- a blank value hides the
/// row entirely (returns nothing) rather than showing a "Not provided"
/// placeholder, so a record missing optional data just shows fewer
/// rows instead of a row of empty-state text.
/// Copies [value] to the clipboard and shows a short confirming toast --
/// shared by every copyable value across the Vehicle Info cards so the
/// feedback (and the toast wording) is identical everywhere.
void copyInsValue(String value) {
  Clipboard.setData(ClipboardData(text: value));
  Fluttertoast.showToast(msg: 'Copied', toastLength: Toast.LENGTH_SHORT);
}

class _CopyIconButton extends StatelessWidget {
  const _CopyIconButton({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => copyInsValue(value),
      borderRadius: BorderRadius.circular(20),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(Icons.copy_rounded, size: 15, color: InsColors.textMuted),
      ),
    );
  }
}

class InsInfoRow extends StatelessWidget {
  const InsInfoRow({super.key, required this.label, required this.value, this.icon, this.copyable = false});

  final String label;
  final String value;
  final IconData? icon;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: InsColors.textSecondary),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: InsColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: InsColors.textPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (copyable) _CopyIconButton(value: value),
        ],
      ),
    );
  }
}

/// Full-width light-grey "chip" box for a long identifier value
/// (Chassis Number, Engine Number, Policy Number) -- label on top in
/// small grey caps-ish text, the value below in bold, with a copy
/// button on the trailing edge when [_ResolvedInsField.copyable] is set.
/// Matches the reference app's treatment of these specific fields rather
/// than squeezing a 17-character VIN into a label/value line.
class _InsChipField extends StatelessWidget {
  const _InsChipField({required this.field});
  final _ResolvedInsField field;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label, style: const TextStyle(color: InsColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  field.value,
                  style: const TextStyle(color: InsColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          if (field.copyable) _CopyIconButton(value: field.value),
        ],
      ),
    );
  }
}

/// Smaller sibling of [_InsChipField] for short values laid out two to a
/// row (Cubic Capacity/Fuel Norms, Mfg Month-Year/Seating-Weight, etc.)
/// -- see [_buildSectionFieldWidgets], which pairs these up.
class _InsCompactChip extends StatelessWidget {
  const _InsCompactChip({required this.field});
  final _ResolvedInsField field;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.label, style: const TextStyle(color: InsColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            field.value,
            style: const TextStyle(color: InsColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Shared list-card design for the Insurance module's list screens
/// (2026-10-23 request: "I want same list card for both admin &
/// fieldworker"). Both `InsuranceShowListPage.dart` (field worker) and
/// `Admin_insurance_list.dart` (admin) keep their own, independently
/// drifted `InsuranceModel` classes pointed at different backends, so
/// this widget takes plain values instead of either model class --
/// that keeps it usable by both without forcing either model to change
/// shape. Same request also asked to show the vehicle's model name
/// instead of the old "Via Registry" badge, and to show the actual
/// `INSURANCE_UPTO` expiry date on the opposite side of the row from
/// the remaining-days badge (previously that side showed a "Created"
/// date sourced from a different field).
class InsuranceListCard extends StatelessWidget {
  const InsuranceListCard({
    super.key,
    required this.id,
    required this.name,
    required this.vehicleNumber,
    required this.carPhotoUrl,
    required this.missingCount,
    required this.vehicleModelLabel,
    required this.insuranceUpto,
    required this.onTap,
    this.compactExpiryLabel = false,
    this.showExpiresPrefix = true,
    this.modelNameFullWidth = false,
    this.onGoToBuilding,
    this.onGoToFlat,
  });

  final int id;
  final String? name;
  final String? vehicleNumber;
  final String? carPhotoUrl;
  final int missingCount;
  final String? vehicleModelLabel;
  final String? insuranceUpto;
  final VoidCallback onTap;

  // 2026-10-29, Building/Flat insurance-linking feature: optional
  // navigation callbacks. Null means "no link for this record" and the
  // corresponding chip is simply not shown -- every existing caller that
  // doesn't pass these is completely unaffected.
  final VoidCallback? onGoToBuilding;
  final VoidCallback? onGoToFlat;

  // 2026-10-23, admin "Insurance Records" mini-card request: three opt-in
  // flags, all defaulting to the original behaviour so the field-worker
  // list and the first admin list (both still wanting the fuller card)
  // are completely unaffected.
  /// true -> the remaining-days badge shows just the day count (e.g.
  /// "77 days left"), not the status word in front of it.
  final bool compactExpiryLabel;
  /// false -> the date line shows just the date itself, no "Expires: "
  /// prefix.
  final bool showExpiresPrefix;
  /// true -> the vehicle model name gets its own full-width row below
  /// the photo/name row (room for the whole name, not sharing a `Wrap`
  /// with the "N missing" badge), and the missing-field count moves to a
  /// compact inline indicator instead of a full badge.
  final bool modelNameFullWidth;

  @override
  Widget build(BuildContext context) {
    final expiryStatus = insuranceExpiryStatusFor(insuranceUpto);
    final expiresText = insuranceExpiryDisplayDate(insuranceUpto);
    final expiryBadgeLabel = compactExpiryLabel
        ? insuranceRemainingDaysLabel(insuranceUpto)
        : insuranceExpiryCardText(insuranceUpto);
    final dateLineText = expiresText;
    final trimmedModelLabel = vehicleModelLabel?.trim();
    final hasModelLabel = trimmedModelLabel != null && trimmedModelLabel.isNotEmpty;

    // Computed ahead of time (rather than nested conditional elements
    // inside the widget tree below) to keep the two display modes
    // ("modelNameFullWidth" vs. the original shared layout) unambiguous
    // and easy to follow.
    final Widget missingOrModelRow;
    if (modelNameFullWidth) {
      missingOrModelRow = missingCount > 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 14, color: InsColors.warning),
                const SizedBox(width: 4),
                Text(
                  '$missingCount missing',
                  style: const TextStyle(color: InsColors.warning, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            )
          : const SizedBox.shrink();
    } else {
      missingOrModelRow = Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          if (missingCount > 0)
            InsBadge(label: '$missingCount missing', tone: InsBadgeTone.warning, icon: Icons.error_outline_rounded),
          if (hasModelLabel)
            InsBadge(label: trimmedModelLabel!, tone: InsBadgeTone.success, icon: Icons.directions_car_filled_outlined),
        ],
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: InsColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: InsColors.border),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: carPhotoUrl != null
                      ? Image.network(
                          carPhotoUrl!,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2026-10-23 fix: a `Row` here let a long name push the
                      // "ID <n>" badge straight off the right edge on a
                      // narrow card (the admin screen's horizontal mini-card
                      // is only ~239px wide on a small phone) -- `Wrap` lets
                      // the badge drop to its own line below the name
                      // instead of overflowing, and the name itself is no
                      // longer truncated with an ellipsis, it just wraps.
                      // 2026-10-23: swapped which of the two is the
                      // primary (bigger, top) line -- the vehicle number
                      // is now the big/bold headline with the "ID <n>"
                      // badge beside it, and the owner name is the
                      // smaller secondary line below, per the user's
                      // explicit "vehicle number is more important than
                      // owner name" request. Still a `Wrap` (not a `Row`)
                      // for the same overflow-safety reason noted above --
                      // a long plate number can still wrap/drop the ID
                      // badge to its own line on a narrow card instead of
                      // overflowing.
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 2,
                        children: [
                          Text(
                            vehicleNumber?.trim().isNotEmpty == true ? vehicleNumber! : 'No vehicle number',
                            style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.6),
                          ),
                          InsBadge(label: 'ID $id', tone: InsBadgeTone.neutral),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name?.trim().isNotEmpty == true ? name! : 'Unnamed',
                        style: const TextStyle(color: InsColors.textSecondary, fontSize: 12.5),
                      ),
                      const SizedBox(height: 6),
                      // `modelNameFullWidth` moves the model name out of
                      // this Wrap entirely (see below, its own full-width
                      // row) and shows the missing-field count as a
                      // compact inline indicator here instead of a full
                      // badge -- 2026-10-23, "show missing field number
                      // efficiently" request: a small icon+number reads
                      // just as clearly as a pill badge but claims far
                      // less of this already-tight column's width.
                      missingOrModelRow,
                    ],
                  ),
                ),
              ],
            ),
            // 2026-10-23, "show the model name in full row" request: when
            // `modelNameFullWidth` is set, the model name gets its own row
            // spanning the whole card (not squeezed into the text column
            // next to the photo, and not sharing a `Wrap` with the missing-
            // field count) -- enough room for the full name on one line on
            // the wider admin mini-card, truncating only as an absolute
            // last resort via the `Flexible`+ellipsis below.
            if (modelNameFullWidth && hasModelLabel) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.directions_car_filled_outlined, size: 16, color: InsColors.success),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      trimmedModelLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: InsColors.success, fontSize: 13.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 20, color: InsColors.border),
            // 2026-10-23 fix: this Row overflowed on a narrow card (the
            // admin screen's horizontal mini-card, ~239px wide on a small
            // phone) -- a long date line plus the remaining-days badge
            // didn't fit and neither side ever shrank. The date side is
            // now `Expanded` (so it only ever claims the space the badge
            // doesn't need) with its own text allowed to ellipsize as a
            // last resort, instead of both sides keeping their natural,
            // unbounded width.
            Row(
              children: [
                if (expiresText.isNotEmpty)
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.event_outlined, size: 15, color: InsColors.textSecondary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            dateLineText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: InsColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 8),
                InsBadge(
                  label: expiryBadgeLabel,
                  tone: insuranceExpiryTone(expiryStatus),
                  icon: insuranceExpiryIcon(expiryStatus),
                ),
              ],
            ),
            if (onGoToBuilding != null || onGoToFlat != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onGoToBuilding != null)
                    InkWell(
                      onTap: onGoToBuilding,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: InsColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.apartment_outlined, size: 14, color: InsColors.primary),
                            SizedBox(width: 5),
                            Text('Go to Building', style: TextStyle(color: InsColors.primary, fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  if (onGoToFlat != null)
                    InkWell(
                      onTap: onGoToFlat,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: InsColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.door_front_door_outlined, size: 14, color: InsColors.primary),
                            SizedBox(width: 5),
                            Text('Go to Flat', style: TextStyle(color: InsColors.primary, fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.directions_car_outlined, color: InsColors.textMuted, size: 32),
      );
}

enum InsBadgeTone { primary, success, warning, error, neutral }

/// Small rounded pill used for status/category labels on list cards and
/// detail screens (vehicle category, policy type, "N missing fields",
/// etc.) -- one consistent shape/weight instead of each screen inventing
/// its own badge styling.
class InsBadge extends StatelessWidget {
  const InsBadge({super.key, required this.label, this.tone = InsBadgeTone.neutral, this.icon});

  final String label;
  final InsBadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (tone) {
      case InsBadgeTone.primary:
        bg = InsColors.primary.withOpacity(0.1);
        fg = InsColors.primary;
        break;
      case InsBadgeTone.success:
        bg = InsColors.successBg;
        fg = InsColors.success;
        break;
      case InsBadgeTone.warning:
        bg = InsColors.warningBg;
        fg = InsColors.warning;
        break;
      case InsBadgeTone.error:
        bg = InsColors.errorBg;
        fg = InsColors.error;
        break;
      case InsBadgeTone.neutral:
        bg = InsColors.bg;
        fg = InsColors.textSecondary;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          // 2026-10-23 fix: a bare `Text` here had no bounded width of its
          // own, so when this badge sat inside a `Wrap` that was narrower
          // than the label's natural width (e.g. a long vehicle model name
          // on the admin screen's compact mini-card), the Row's own maxWidth
          // (set by the Wrap) was smaller than its children's combined
          // width and nothing could shrink -- a real RenderFlex overflow,
          // not just a visual truncation. Wrapping the Text in `Flexible`
          // lets it shrink and ellipsize in that situation while staying
          // exactly the same size as before whenever there's enough room,
          // so this changes nothing about how any existing badge looks.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Light-theme search field used at the top of the Insurance list
/// screens (field-worker + both admin variants).
class InsSearchField extends StatelessWidget {
  const InsSearchField({
    super.key,
    required this.controller,
    required this.onClear,
    this.hint = 'Search by name, vehicle number or ID',
  });

  final TextEditingController controller;
  final VoidCallback onClear;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: InsColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: InsColors.textMuted, fontSize: 13.5),
        prefixIcon: const Icon(Icons.search_rounded, color: InsColors.textSecondary, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, color: InsColors.textSecondary, size: 18),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: InsColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: InsColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: InsColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: InsColors.borderFocus, width: 1.6)),
      ),
    );
  }
}

/// One entry in an [InsDocumentViewer] gallery -- a labeled document with
/// its (possibly null/empty) image URL. Built by the caller from whatever
/// documents it actually has, already filtered to the ones with a real
/// image -- this widget doesn't filter for itself.
class InsDocItem {
  final String title;
  final String url;
  const InsDocItem({required this.title, required this.url});
}

/// Full-screen document/photo viewer for the Insurance section's document
/// grid (RC front/back, Aadhar, PAN, pollution certificate, etc.) and car
/// photo galleries. Unlike the app-wide `PropertyPreview` widget (used by
/// ~25 other unrelated screens, so left untouched), this one is scoped to
/// Insurance and improves on a single isolated image view by letting the
/// person swipe between every document on the record, see which one
/// they're looking at ("RC Front -- 2 of 7"), pinch-zoom, and save it.
class InsDocumentViewer extends StatefulWidget {
  final List<InsDocItem> items;
  final int initialIndex;

  const InsDocumentViewer({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  @override
  State<InsDocumentViewer> createState() => _InsDocumentViewerState();
}

class _InsDocumentViewerState extends State<InsDocumentViewer> {
  late final PageController _controller;
  late int _currentIndex;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _download(String url) async {
    setState(() => _downloading = true);
    try {
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(response.data);
      await Gal.putImageBytes(
        bytes,
        name: "insurance_document_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );
      Fluttertoast.showToast(msg: "Saved to gallery");
    } catch (e) {
      Fluttertoast.showToast(msg: "Couldn't save image");
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.items[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current.title,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
            ),
            if (widget.items.length > 1)
              Text(
                '${_currentIndex + 1} of ${widget.items.length}',
                style: const TextStyle(color: Colors.white60, fontSize: 11.5),
              ),
          ],
        ),
        actions: [
          _downloading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                )
              : IconButton(
                  onPressed: () => _download(current.url),
                  icon: const Icon(Icons.download_rounded, color: Colors.white),
                ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (context, index) {
          final doc = widget.items[index];
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                doc.url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (_, __, ___) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image_rounded, color: Colors.white38, size: 48),
                    const SizedBox(height: 10),
                    Text(
                      "Couldn't load ${doc.title}",
                      style: const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: widget.items.length > 1
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.items.length,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentIndex == i ? 9 : 6,
                      height: _currentIndex == i ? 9 : 6,
                      decoration: BoxDecoration(
                        color: _currentIndex == i ? Colors.white : Colors.white38,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
