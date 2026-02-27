import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



/// Convert numbers to words (Indian system: crore, lakh, thousand, hundred)
String numberToWords(int number) {
  if (number == 0) return 'ZERO';

  final units = [
    '',
    'ONE',
    'TWO',
    'THREE',
    'FOUR',
    'FIVE',
    'SIX',
    'SEVEN',
    'EIGHT',
    'NINE',
    'TEN',
    'ELEVEN',
    'TWELVE',
    'THIRTEEN',
    'FOURTEEN',
    'FIFTEEN',
    'SIXTEEN',
    'SEVENTEEN',
    'EIGHTEEN',
    'NINETEEN'
  ];
  final tens = [
    '',
    '',
    'TWENTY',
    'THIRTY',
    'FORTY',
    'FIFTY',
    'SIXTY',
    'SEVENTY',
    'EIGHTY',
    'NINETY'
  ];

  String twoDigit(int n) {
    if (n < 20) return units[n];
    final t = tens[n ~/ 10];
    final u = n % 10;
    return t + (u != 0 ? ' ' + units[u] : '');
  }

  String threeDigit(int n) {
    if (n == 0) return '';
    if (n < 100) return twoDigit(n);
    final h = n ~/ 100;
    final rem = n % 100;
    return units[h] + ' HUNDRED' + (rem != 0 ? ' ' + twoDigit(rem) : '');
  }

  // Use a local copy so we don't mutate the parameter
  int n = number;
  final parts = <String>[];

  // Crores (1 crore = 1,00,00,000 = 10,000,000)
  if (n >= 10000000) {
    final cr = n ~/ 10000000;
    parts.add(threeDigit(cr) + ' CRORE');
    n = n % 10000000;
  }

  // Lakhs (1 lakh = 1,00,000)
  if (n >= 100000) {
    final lk = n ~/ 100000;
    parts.add(threeDigit(lk) + ' LAKH');
    n = n % 100000;
  }

  // Thousands
  if (n >= 1000) {
    final th = n ~/ 1000;
    parts.add(threeDigit(th) + ' THOUSAND');
    n = n % 1000;
  }

  // Remaining hundreds and tens
  if (n > 0) {
    parts.add(threeDigit(n));
  }

  return parts.where((s) => s.trim().isNotEmpty).join(' ').trim();
}

const double kSmallSpace = 6;
const double kNormalSpace = 10;
const double kLargeSpace = 16;
const double kSectionSpace = 22;

/// Format amount as in your template: "Rs. 8000 /- (EIGHT THOUSAND RUPEES)"
int parseIndianAmount(String input) {
  String value = input.toUpperCase().replaceAll(',', '').trim();

  if (value.contains('LAC') || value.contains('LAKH')) {
    final numberPart = value.split(RegExp(r'LAC|LAKH'))[0].trim();
    final numVal = double.tryParse(numberPart) ?? 0;
    return (numVal * 100000).toInt();
  }

  if (value.contains('CR') || value.contains('CRORE')) {
    final numberPart = value.split(RegExp(r'CR|CRORE'))[0].trim();
    final numVal = double.tryParse(numberPart) ?? 0;
    return (numVal * 10000000).toInt();
  }

  return int.tryParse(value) ?? 0;
}

String formatAmount(String? amount) {
  if (amount == null || amount.toString().trim().isEmpty) {
    return 'Rs. 0 /- ( ZERO RUPEES )';
  }

  final intVal = parseIndianAmount(amount);
  final words = numberToWords(intVal);

  return 'Rs. $intVal /- ( $words RUPEES )';
}

String maskIdNumber(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');

  if (digits.length < 4) return value;

  // Mask all except last 3 digits
  final maskedLength = digits.length - 3;
  return 'X' * maskedLength + digits.substring(digits.length - 3);
}

/// Safe extraction: returns data[key] if present and not empty; otherwise returns fallback + ' (static)'
String safeString(Map<String, dynamic> data, String key, String fallback) {
  final v = data[key];
  if (v == null) return '$fallback (static)';
  final s = v.toString().trim();
  if (s.isEmpty) return '$fallback (static)';
  return s;
}

/// Parse date robustly; returns string in dd/MM/yyyy or fallback if parsing fails
String formatDateStr(dynamic dateVal, String fallback) {
  if (dateVal == null) return '$fallback (static)';
  try {
    String raw;
    if (dateVal is Map && dateVal.containsKey('date')) {
      raw = dateVal['date'].toString();
    } else {
      raw = dateVal.toString();
    }
    final dt = DateTime.parse(raw);
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yy = dt.year.toString();
    return '$dd/$mm/$yy';
  } catch (e) {
    final s = dateVal.toString();
    if (RegExp(r'\d{1,2}\/\d{1,2}\/\d{4}').hasMatch(s)) return s;
    return '$fallback (static)';
  }
}

DateTime addMonthsSafely(DateTime from, int monthsToAdd) {
  final targetMonth = from.month + monthsToAdd;
  final yearOffset = (targetMonth - 1) ~/ 12;
  final newYear = from.year + yearOffset;
  final newMonth = ((targetMonth - 1) % 12) + 1;

  // clamp day to the last day of the new month
  final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  final newDay = from.day <= lastDayOfNewMonth ? from.day : lastDayOfNewMonth;
  return DateTime(newYear, newMonth, newDay);
}

Future<File> generateAgreementPdf(Map<String, dynamic> data) async {
  final bool hideAgreement =
      data['is_agreement_hide']?.toString() == '1';

  // 🔥 FETCH ADDITIONAL TENANTS
  List<Map<String, dynamic>> additionalTenants = [];

  try {
    final agreementId = data['id']?.toString();
    if (agreementId != null && agreementId.isNotEmpty) {
      final response = await http.get(Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/show_api_for_addtional_tenant.php?agreement_id=$agreementId",
      ));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true && decoded["data"] != null) {
          additionalTenants =
          List<Map<String, dynamic>>.from(decoded["data"]);
        }
      }
    }
  } catch (_) {}


  final pdf = pw.Document();

  // dynamic-safe reads (use fallback with (static) if missing)
  final ownerName = safeString(data, 'owner_name', 'DEMO OWNER');
  final ownerRelation = safeString(data, 'owner_relation', 'S/O');
  final ownerRelationPerson = safeString(data, 'relation_person_name_owner', 'QWERTY');
  final ownerAddress = safeString(data, 'parmanent_addresss_owner', 'DEMO ADDRESS');

  final tenantName = safeString(data, 'tenant_name', 'DEMO TENANT');
  final tenantRelation = safeString(data, 'tenant_relation', 'S/O');
  final tenantRelationPerson = safeString(data, 'relation_person_name_tenant', 'PAWAN');
  final tenantPermAddress = safeString(data, 'permanent_address_tenant', 'DEMO TENANT ADDRESS');
  final tenantMobile = safeString(data, 'tenant_mobile_no', '0000000000');

  final bhk = data['Bhk'] ?? '';
  final floor = data['floor'] ?? '';
  final address = data['rented_address'] ?? '';
  final agreement_type = data['agreement_type'] ?? '';

  final fullAddress = [
    bhk,
    floor,
    address
  ].where((e) => e != null && e.toString().trim().isNotEmpty)
      .join(', ');


  final monthlyRentRaw = data['monthly_rent']?.toString() ?? '';
  final customMaintenanceRaw = data['custom_maintenance_charge']?.toString() ?? '';
  final securityRaw = data['securitys']?.toString() ?? '';

  final String maintenanceType =
  (data['maintaince']?.toString() ?? '').trim().toLowerCase();

  final String maintenanceAmount =
  maintenanceType == 'excluding'
      ? (customMaintenanceRaw.isNotEmpty ? customMaintenanceRaw : '0')
      : '0';

  final int maintenanceInt =
      int.tryParse(maintenanceAmount.replaceAll(',', '')) ?? 0;

  final String maintenanceLabel =
  maintenanceType == 'excluding'
      ? 'excluding'
      : 'including';


  final rawOwnerAadhaar =
  safeString(data, 'owner_addhar_no', '297374997337');
  final rawTenantAadhaar =
  safeString(data, 'tenant_addhar_no', '100288377394');

  final ownerAadhaar =
  hideAgreement ? maskIdNumber(rawOwnerAadhaar) : rawOwnerAadhaar;

  final tenantAadhaar =
  hideAgreement ? maskIdNumber(rawTenantAadhaar) : rawTenantAadhaar;


  pw.TextSpan getMeterClause(Map<String, dynamic>? data) {
    final customMeterUnit = data?["custom_meter_unit"];
    final meterRate = data?["meter"];
    final meterValue = (customMeterUnit != null && customMeterUnit.toString().isNotEmpty)
        ? customMeterUnit.toString()
        : (meterRate != null && meterRate.toString().isNotEmpty)
        ? meterRate.toString()
        : null;

    if (meterValue != null) {
      return pw.TextSpan(
        children: [
          pw.TextSpan(
            text: "The rate per unit is INR ",
            style: pw.TextStyle(fontSize: 11),
          ),
          pw.TextSpan(
            text: meterValue,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(
            text:
            " per unit and water charges as per actual usage. These payments are separate from the monthly rent.",
            style: pw.TextStyle(fontSize: 11),
          ),
        ],
      );
    } else {
      return pw.TextSpan(
        text:
        "The rate per unit will be billed separately from the monthly rent as per applicable rates.",
        style: pw.TextStyle(fontSize: 11),
      );
    }
  }


  // compute shiftingDate robustly
  DateTime shiftingDate;
  try {
    if (data['shifting_date'] is Map && data['shifting_date']['date'] != null) {
      shiftingDate = DateTime.parse(data['shifting_date']['date'].toString());
    } else {
      shiftingDate = DateTime.parse(data['shifting_date'].toString());
    }
  } catch (_) {
    shiftingDate = DateTime(2025, 9, 23); // fallback static
  }

  String getIdLabel(String number) {
    final digitsOnly = number.replaceAll(
        RegExp(r'\D'), ''); // remove non-digits
    if (digitsOnly.length == 16) {
      return 'VID No:'; // Virtual ID (16 digits)
    } else {
      return 'Aadhaar No:'; // Aadhaar (12 digits)
    }
  }


    String getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  final endDate = addMonthsSafely(shiftingDate, 11);
  final shiftingDateFormatted = '${shiftingDate.day.toString().padLeft(2, '0')}/${shiftingDate.month.toString().padLeft(2, '0')}/${shiftingDate.year}';
  final endDateFormatted = '${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';

  final baseStyle = pw.TextStyle(fontSize: 11, height: 1.4);
  final boldStyle = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, height: 1.4);
  final titleStyle = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);
  final rentDueDay = getDayWithSuffix(shiftingDate.day);
  final bool isRenewal =
      agreement_type.trim().toLowerCase() == "renewal agreement";


  final currentDate = DateTime.now();
  final currentDateFormatted =
      '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}';

  // Build the PDF with the same page layout as original (kept unchanged)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        );
      },
      build: (context) => [
        // PAGE 1 (title + intro + clauses 1-5)
        pw.Center(
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: kSectionSpace),
            child: pw.Text('Leave & License', style: titleStyle),
          ),
        ),

        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: 'This Leave & License is made and executed on this ',
                style: baseStyle,
              ),
              pw.TextSpan(
                text: currentDateFormatted,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              ),
              pw.TextSpan(
                text: ' by and Between:',
                style: baseStyle,
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 6),

        pw.Text('$ownerName, $ownerRelation, $ownerRelationPerson, Resident of $ownerAddress (hereinafter called the FIRST PARTY/LANDLORD).', style: boldStyle),
        pw.SizedBox(height: 10),

        pw.Text('                                                                            AND', style: baseStyle),
        pw.SizedBox(height: 10),

        pw.Text('$tenantName, $tenantRelation, $tenantRelationPerson, Resident of $tenantPermAddress (hereinafter called the SECOND PARTY/TENANT).', style: boldStyle),

        if (additionalTenants.isNotEmpty) ...[
          pw.SizedBox(height: 8),

          pw.Text(
              '                                                                 CO-TENANTS',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
          ),

          pw.SizedBox(height: 8),

          pw.Text(
            additionalTenants.asMap().entries.map((entry) {
              final index = entry.key + 2;
              final t = entry.value;

              final name = t['tenant_name'] ?? '';
              final relation = t['tenant_relation'] ?? '';
              final relationPerson = t['relation_person_name_tenant'] ?? '';

              String relationText = '';
              if (relation.isNotEmpty && relationPerson.isNotEmpty) {
                relationText = ', $relation $relationPerson';
              }

              return '$index. $name$relationText, residing at $tenantPermAddress';
            }).join('\n'),
            style: boldStyle,
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            'All the above-named persons are hereinafter collectively referred to as the "TENANT/SECOND PARTY".',
            style: baseStyle,
          ),
        ],

        pw.SizedBox(height: 10),

        pw.Text('The expression of the both the parties shall mean and include their respective legal heirs, successors, Executors, administrators, representatives and legal assigns.', style: baseStyle),
        pw.SizedBox(height: 10),

        pw.Text('AND WHEREAS The first party agrees to let out', style: baseStyle),
        pw.Text(fullAddress, style: boldStyle),
        pw.SizedBox(height: 6),

        pw.Text('And the tenant also has agreed to take on rent the said property on the following terms and conditions of this Leave & License:-', style: baseStyle),
        pw.SizedBox(height: 10),

        pw.Text('NOW THIS LEAVE & LICENSE WITNESSETH AS UNDER:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 15),

        if (isRenewal) ...[
          pw.Text(
            'RENEWAL DECLARATION',
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 8),

          pw.Text(
            'The parties hereby confirm that this Agreement constitutes a renewal and continuation of the existing tenancy of the premises, and the possession of the Tenant shall be treated as uninterrupted. Any security deposit or obligations arising from the previous tenancy shall continue under this Agreement unless otherwise expressly stated.',
            style: baseStyle,
          ),

          pw.SizedBox(height: 15),
        ],

        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(text: '1. That the tenancy in respect of the above said premises has been granted by the First Party to the Second Party for a period of ', style: baseStyle),
              pw.TextSpan(text: '11 months', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(text: ' commencing ', style: baseStyle),

              pw.TextSpan(text: '$shiftingDateFormatted', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(text: ' to ', style: baseStyle),
              pw.TextSpan(text: '$endDateFormatted', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(text: '.', style: baseStyle),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        // Clause 2 with amounts bolded
            pw.RichText(
            text: pw.TextSpan(
            children: [
            pw.TextSpan(
            text: '2. Rent: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.TextSpan(
            text: 'The Second Party has paid an advance rent of ',
            style: baseStyle,
            ),
            pw.TextSpan(
            text: formatAmount(monthlyRentRaw),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.TextSpan(text: '. The monthly rent shall be ', style: baseStyle),
            pw.TextSpan(
            text: formatAmount(monthlyRentRaw),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.TextSpan(
            text: ' and is payable in advance on or before the ',
            style: baseStyle,
            ),
            pw.TextSpan( // 🔥 BOLD rentDueDay
            text: '$rentDueDay day',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.TextSpan(
            text: ' of each calendar month. ',
            style: baseStyle,
            ),
              pw.TextSpan(
                text: '$maintenanceLabel maintenance charges of ',
                style: baseStyle,
              ),
              pw.TextSpan(
                text: 'Rs. $maintenanceAmount ',
                style: boldStyle,
              ),
              pw.TextSpan(
                text: '( ${numberToWords(maintenanceInt)} RUPEES ).',
                style: boldStyle,
              ),
            ],
            ),
            ),
        pw.SizedBox(height: 10),
        // Clause 3 with amounts
        pw.RichText(
          text: pw.TextSpan(children: [
            pw.TextSpan(text: '3. Security Deposit: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: 'A security deposit of ', style: baseStyle),
            pw.TextSpan(text: formatAmount(securityRaw), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: ' is paid by the Second Party to the First Party This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Leave & License after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges as per actual.', style: baseStyle),
            pw.TextSpan(text: '(BNS 324, 316(2))', style: baseStyle),

          ]),
        ),
        pw.SizedBox(height: 10),
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(text: '4. Usage: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(text: 'The rented premises shall be used for '),
              pw.TextSpan(text: 'residential', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(text: ' purposes only.'),
              pw.TextSpan(text: '(IPC 420, 406)  (BNS 318, 316(1))', style: baseStyle),
            ],
            style: baseStyle,
          ),
        ),
        pw.SizedBox(height: 9),

        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(text: '5. Electricity & Water Charges: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              getMeterClause(data),
              pw.TextSpan(text: '(IPC 379, Electricity Act 135) (BNS 303(2))', style: baseStyle),

            ],
            style: baseStyle,
          ),
        ),
        pw.SizedBox(height: 10),
        clause('6. Hybrid Work and Not for Commercial Use:', 'The Tenant may work from home for personal or professional purposes; however, the premises shall not be used for any commercial registration or business setup, including but not limited to GST registration, trade licenses, or office establishment, without the prior written consent of the Landlord. Any violation shall be treated as a breach of this Agreement. (IPC 420, 468, 471) (BNS 318, 326, 327(2))'),
        pw.SizedBox(height: 10),
        clause('7. Mandatory Police Verification & Visitor Compliance:', 'The Tenant shall complete mandatory Police Verification within 7 days from the date of possession.Failure to comply may result in legal action under Section 188 IPC. The First Party/Landlord may submit tenant information to the local police station as required by law. (IPC 188) (BNS 223(3))'),
      ],
    ),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        );
      },
      build: (context) => [
        pw.SizedBox(height: 10),
        clause('8. Extension and Alterations:', 'The tenancy can be extended if both parties agree. The Tenant cannot make any alterations to the rented property without the owner\'s written permission.(IPC 425, 427) (BNS 324, 303)'),
        pw.SizedBox(height: 10),
        clause('9. Rules for Using Common Areas:', 'The Tenant shall not block staircases, corridors, terrace, or parking areas with personal belongings. Any violation may lead to penalty or termination.'),
        pw.SizedBox(height: 9),
        clause('10. Pet Policy:', 'No pets shall be kept on the premises without prior written approval of the Landlord. Any damage caused by pets shall be borne by the Tenant.'),
        pw.SizedBox(height: 12),
        clause('11. Inspection & Emergency Entry:', 'The Tenant must allow the Landlord or their authorized agent to enter the premises for inspection or required work. This access should be at any reasonable time, ensuring both parties can manage the property effectively. In situations involving a gas leak, fire, water leakage, flooding, structural danger, or any life-threatening emergency, the Landlord or authorized technicians may enter the premises without prior notice to prevent harm. (IPC 268, 269, 336, 188) (BNS 280, 285, 281, 223(3))'),
        pw.SizedBox(height: 12),
        clause('12. Taxes and Landlord\'s Liability:', 'The Landlord is responsible for paying house and municipal taxes. However, the Landlord isn\'t liable for disputes between the Tenant and other residents, or for any loss, damage, or injury to the Tenant\'s personal belongings or to the Tenant and their guests.'),
        pw.SizedBox(height: 12),
        clause('13. Damage, Handover, and Last Month Rent Adjustment:', 'The Tenant shall keep the premises in good, clean, and well-maintained condition. Any damage beyond normal wear and tear shall be repaired at the Tenant\'s cost. At the end of the tenancy, the Tenant must vacate and hand over the premises in the same condition as received. The Tenant shall not adjust or deduct the last month\'s rent from the security deposit under any circumstances. The security deposit will be refunded only after final inspection, verification of damages, and settlement of all outstanding dues including rent, electricity, cleaning charges, or repair expenses. Delay or failure to hand over possession, or refusal to pay for damages, will make the Tenant liable for penalties, recovery proceedings, and legal action under IPC Sections 441, 447, and 427 (BNS 329(5), 330, 303).'),
        pw.SizedBox(height: 12),
        clause('14. Vacating & Termination:', 'The Tenant must vacate the premises in its original condition, with whitewashing done before leaving. Either party may terminate the agreement by giving one month\'s written notice. If the tenancy is extended beyond the initial term, the monthly rent shall increase by 10%, unless both parties agree otherwise in writing. (IPC 441, 447) (BNS 329(5), 330)'),
        pw.SizedBox(height: 12),
        clause('15. Misconduct, Noise, and Community Disturbance:', 'The Tenant shall not engage in loud music, shouting, fighting, or any activity that disturbs neighbors, disrupts peace, or causes trouble in the society or locality. Any unlawful, improper, socially unacceptable behavior, repeated complaints from neighbors, or disturbance of public tranquility shall be treated as misconduct. In such cases, the Landlord shall have the right to terminate the tenancy by giving one month\'s written notice. After the notice period ends, the Tenant must vacate the premises without objection. Violations under this clause may attract action under IPC Sections 268, 290, 504, 506, and 323. (BNS 280, 356, 351, 115)'),
        pw.SizedBox(height: 12),
        clause('16. Tenant Information:', 'The Tenant and their visitors must provide valid ID and required details to the Owner before moving in. In case of disputes or misconduct, the Owner may evict the Tenant. The Owner also reserves the right to terminate the agreement with one month\'s notice before the term ends. (IPC 188, 177) (BNS 223(3), 223(2))'),
        pw.SizedBox(height: 12),
        clause('17. Prohibited Activities:', 'The Second Party shall not engage in illegal or unlawful activities in the premises. The Second Party shall not keep any unauthorized inflammable or explosive items in the premises. (IPC 285, 286, 188, 120B) (BNS 281(2), 282, 223(3), 61)'),
        pw.SizedBox(height: 12),
        clause('18. Loan & Credit Application:', 'The Second Party will not apply for any loan or credit card using the said address. If any loan is pending against the Second Party, the First Party will not be liable or responsible for the same. (IPC 420, 468, 471)  (BNS 318, 326, 327(2))'),
        pw.SizedBox(height: 12),

      ],
    ),
  );

  pdf.addPage(
    pw.MultiPage(
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        );
      },
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      build: (context) => [
        pw.SizedBox(height:20),
        clause('19. Restriction on GST Registration:', 'The Tenant is strictly prohibited from registering for GST using the Property\'s address. In the event that the Tenant obtains GST registration at the Property\'s address, the Owner shall bear no responsibility for any liabilities, penalties, or legal consequences arising therefrom. The Tenant shall be solely liable for any disputes, claims, or regulatory actions related to such unauthorized use. (IPC 420, 468, 471) (BNS 318, 326, 327(2))'),
        pw.SizedBox(height: 15),
        clause('20. Repair and Cleanliness:', 'The Tenant is responsible for minor, day-to-day repairs at their own expense. They must return the premises in the same condition as received and keep it clean and hygienic. (IPC 268) (BNS 280)'),
        pw.SizedBox(height: 15),
        clause('21. Liability for Death or Suicide:', 'In the event of any death, suicide, or injury occurring within the premises, the First Party/Landlord shall not be held responsible or liable for any claims arising therefrom.'),
        pw.SizedBox(height: 15),
        clause('22. Non-Payment of Rent:', 'If the Second Party/Tenant fails to pay the rent on time, the First Party/Landlord reserves the right to take legal action to recover the outstanding amount and repossess the premises. (IPC 421, 403) (BNS 319(3), 316(2))'),
        pw.SizedBox(height: 15),
        clause('23. Legal Issues or Police Cases:', 'If the Second Party/Tenant is involved in any police case or legal issue, the First Party/Landlord shall not be held responsible or liable for any consequences arising therefrom.'),
        pw.SizedBox(height: 15),
        clause('24. Fire Safety & Hazardous Materials Prohibition:', 'The Tenant shall not store flammable, chemical, explosive, or hazardous materials. Violation may attract action under IPC Section 285 and IPC Section 286, and may result in immediate termination.(IPC 285, 286) (BNS 281(2), 282)'),
        pw.SizedBox(height: 15),
        clause('25. Restriction on Subletting & Unauthorized Occupancy:', 'The Second Party/Tenant shall not sublet, share, transfer, or allow any third party to occupy the premises or any portion of it without the prior written consent of the First Party/Landlord. No person other than the Tenant is permitted to stay, reside, or use the premises in any manner without such written approval. Any form of unauthorized occupancy, shared accommodation, subletting, or permitting outsiders to stay whether temporary or permanent shall be treated as a violation of this Agreement and may result in immediate termination and legal action under IPC Sections 441 and 447. (BNS 329(5), 330)'),
        pw.SizedBox(height: 15),
        clause('26. Living Relationships:', 'The Tenant shall not enter into or maintain a live-in relationship in the premises without informing the Landlord in advance. If the Tenant hides such information, the Tenant will be solely responsible for any legal issues, disputes, or complaints that arise from the live-in arrangement. The Landlord will not be liable for any trouble caused due to the Tenant\'s personal relationship, and the Landlord may take necessary action, including termination of the tenancy, if such a situation creates disturbance or legal problems.'),
        pw.SizedBox(height: 15),
        clause('27. Disputes:', 'All disputes or legal matters arising out of this Leave & License shall be settled exclusively in the court that has lawful jurisdiction over the area in which the rented property is situated. Only the court designated by the Government for this locality shall have the authority to hear and decide such cases.'),
        pw.SizedBox(height: 15),
        clause('28. Digital Communication & E-Signature Validity:', 'Both parties agree that communication done through WhatsApp, Email, SMS, or any digital platform shall be considered valid. Digital signatures or scanned signatures shall be treated as legally binding under the Information Technology Act, 2000. (IPC 465, 471) (BNS 325(1), 327(2))'),
        pw.SizedBox(height: 15),
        clause('29. Full Non-Liability & Internet/Cyber Responsibility Clause', 'The First Party/Landlord and the property itself shall not be held liable for any actions, misconduct, illegal activity, disputes, fraud, civil matters, criminal cases, online offences, cyber crimes, internet misuse, illegal downloads, harassment, or any other legal violations committed by the Second Party/Tenant through physical means or through the use of the internet/Wi-Fi connection within the premises.All consequences arising from the behavior, actions, omissions, digital activities, or cyber activities of the Tenant shall be the sole responsibility of the Tenant alone, and the Landlord shall bear no legal, civil, or financial liability in any manner whatsoever.'),
        pw.SizedBox(height: 15),
        if (agreement_type.trim().toLowerCase() != "renewal agreement")
        clause('30. Lock-in Period:', 'The Second Party shall not terminate the lease within the first Six months. If terminated within this period, the security deposit shall be forfeited. After the lock-in period, the Second Party must give one month\'s notice to vacate, and the First Party must give the same notice to repossess the premises.'),
      ],
    ),
  );

  // PAGE 5 - Signatures
  pdf.addPage(
    pw.MultiPage(
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 20),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        );
      },
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      build: (context) => [

        pw.SizedBox(height: 30),

        if (agreement_type.trim().toLowerCase() != "external rental agreement" &&
            agreement_type.trim().toLowerCase() != "renewal agreement")
          clause(
            '31. Mediator:',
            'Swaven Realty Pvt. Ltd. ("Mediator") acts solely as a facilitator between the Owner and the Tenant. It operates as a pure agent, collecting the first month\'s rent from the Tenant, deducting commission, and transferring the balance to the Owner. From the second month onward, the Tenant shall pay rent directly to the Owner. The Mediator holds no responsibility for any disputes between the parties after the initial transaction.',
          ),
        pw.SizedBox(height: 18),
        pw.Text(
          'IN WITNESS WHEREOF, both the parties have signed this Deed of Agreement on the day, month and year first above written. That both the parties have read and understood the contents of this Agreement and have signed the same without any force or pressure from any side.',
          style: baseStyle,
        ),
        pw.SizedBox(height: 30),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [

            /// 🔹 OWNER COLUMN
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.only(right: 10),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(top: kSectionSpace),
                  child:  pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'FIRST PARTY / LANDLORD',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Name: $ownerName', style: boldStyle),
                    pw.Text('${getIdLabel(ownerAadhaar)} $ownerAadhaar', style: boldStyle),

                    pw.SizedBox(height: kSectionSpace),

                    pw.Text('Signature: ____________________________', style: baseStyle),
                  ],
                ),
              ),
              ),
            ),

            /// 🔹 TENANT COLUMN
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.only(left: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'SECOND PARTY / TENANT',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                    ),
                    pw.SizedBox(height: 8),

                    /// Main Tenant
                    pw.Text('Name: $tenantName', style: boldStyle),
                    pw.Text('${getIdLabel(tenantAadhaar)} $tenantAadhaar', style: boldStyle),
                    pw.SizedBox(height: 20),
                    pw.Text('Signature: ____________________________', style: baseStyle),

                    /// 🔥 Additional Tenants
                    if (additionalTenants.isNotEmpty)
                      ...additionalTenants.map((t) {
                        final name = t['tenant_name'] ?? '';
                        final rawAadhaar = t['tenant_aadhar_no'] ?? '';
                        final aadhaar =
                        hideAgreement ? maskIdNumber(rawAadhaar) : rawAadhaar;

                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 20),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Name: $name', style: boldStyle),
                              pw.Text(
                                '${getIdLabel(rawAadhaar)} $aadhaar',
                                style: boldStyle,
                              ),                              pw.SizedBox(height: 20),
                              pw.Text('Signature: ____________________________', style: baseStyle),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 30),

        pw.Text('WITNESS:-',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),

        pw.Row(
          children: [
            pw.Text('Signature: ____________________________', style: baseStyle),
            pw.SizedBox(width: 50),
            pw.Text('Signature: ____________________________', style: baseStyle),
          ],
        ),

      ],
    ),
  );

  // PAGE 5 - SHO letter (rent verification)
  pdf.addPage(
    pw.MultiPage(
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        );
      },
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      build: (context) => [
        pw.Text('To,', style: baseStyle),
        pw.Text('Respected SHO Sir,', style: baseStyle),
        pw.Text('Police Station - Fatehpur Beri,', style: baseStyle),
        pw.Text('South Delhi,', style: baseStyle),
        pw.SizedBox(height: 12),
        pw.Text('Subject: Rent Verification Request', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 12),

        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(text: 'Sir,\n\n', style: baseStyle),

              if (additionalTenants.isEmpty) ...[
                pw.TextSpan(text: 'I ', style: baseStyle),
                pw.TextSpan(text: tenantName, style: boldStyle),
                pw.TextSpan(text: ', $tenantRelation ', style: baseStyle),
                pw.TextSpan(text: tenantRelationPerson, style: boldStyle),
              ] else ...[
                pw.TextSpan(text: 'We ', style: baseStyle),
                pw.TextSpan(text: tenantName, style: boldStyle),

                ...additionalTenants.map((t) {
                  final name = t['tenant_name'] ?? '';
                  return pw.TextSpan(text: ', $name', style: boldStyle);
                }).toList(),

                pw.TextSpan(text: ', are residing at ', style: baseStyle),
              ],

              pw.TextSpan(
                text: fullAddress,
                style: boldStyle,
              ),

              pw.TextSpan(
                text: ' since ',
                style: baseStyle,
              ),
              pw.TextSpan(
                text: shiftingDateFormatted,
                style: boldStyle,
              ),

              pw.TextSpan(text: '. The owner of the property is ', style: baseStyle),
              pw.TextSpan(text: ownerName, style: boldStyle),
              pw.TextSpan(text: ', $ownerRelation ', style: baseStyle),
              pw.TextSpan(text: ownerRelationPerson, style: boldStyle),
              pw.TextSpan(text: ' residing at ', style: baseStyle),
              pw.TextSpan(text: ownerAddress, style: boldStyle),
              pw.TextSpan(text: '.\n', style: baseStyle),
            ],
          ),
        ),

        pw.SizedBox(height: 6),

        if (additionalTenants.isEmpty)
          pw.Text('My permanent address is: $tenantPermAddress',
              style: boldStyle)
        else ...[
          pw.Text('Our permanent addresses are:',
              style: boldStyle),
          pw.SizedBox(height: 6),
          pw.Text('1. $tenantName - $tenantPermAddress',
              style: boldStyle),
          pw.Text('Mobile Number: $tenantMobile', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ...additionalTenants.asMap().entries.map((entry) {
            final index = entry.key + 2;
            final t = entry.value;
            return pw.Text(
              '$index. ${t['tenant_name']} - $tenantPermAddress',
              style: boldStyle,
            );
          }).toList(),
        ],
        pw.Text('Mobile Number: $tenantMobile', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        pw.Text('Job Details/Designation: ________________________________________________', style: baseStyle),
        pw.SizedBox(height: 18),

        pw.Text(
          additionalTenants.isEmpty
              ? 'I fully understand and agree that all the information provided by me in this Rent Verification Form is true and correct. In case any information is found to be false, misleading, or incomplete, or if I am involved in any kind of illegal activity during my stay at the rented property, then the property owner, mediator, broker, or the property itself shall not be held responsible or liable in any legal, financial, or criminal proceedings. I, the tenant, will be solely and fully responsible for any consequences arising from such actions, and I shall bear all legal liabilities, penalties, or prosecution that may arise in the future.'
              : 'We fully understand and agree that all the information provided by us in this Rent Verification Form is true and correct. In case any information is found to be false, misleading, or incomplete, or if we are involved in any kind of illegal activity during our stay at the rented property, then the property owner, mediator, broker, or the property itself shall not be held responsible or liable in any legal, financial, or criminal proceedings. We, the tenants, will be solely and fully responsible for any consequences arising from such actions, and we shall bear all legal liabilities, penalties, or prosecution that may arise in the future.',
          style: baseStyle,
        ),
        pw.SizedBox(height: 20),

        pw.Text('Thank you for your attention to this matter.', style: baseStyle),
        pw.SizedBox(height: 12),
        pw.Text('Sincerely,', style: baseStyle),
        pw.SizedBox(height: 6),
        pw.Text('Name: $tenantName', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('${getIdLabel(tenantAadhaar)} $tenantAadhaar', style: boldStyle),


        if (additionalTenants.isNotEmpty)
          ...additionalTenants.map((t) {
            final name = t['tenant_name'] ?? '';
            final rawAadhaar = t['tenant_aadhar_no'] ?? '';
            final aadhaar = hideAgreement
                ? maskIdNumber(rawAadhaar)
                : rawAadhaar;

            return pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Name: $name', style: boldStyle),
                  pw.Text(
                    '${getIdLabel(rawAadhaar)} $aadhaar',
                    style: boldStyle,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Signature: ____________________________',
                      style: baseStyle),
                ],
              ),
            );
          }).toList(),

      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/agreement_${data['id'] ?? 'unknown'}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}

pw.Widget clause(String heading, String body) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.RichText(
        text: pw.TextSpan(
          style: pw.TextStyle(fontSize: 10.5, height: 1.2),
          children: [
            pw.TextSpan(
              text: '$heading ',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
            ),
            pw.TextSpan(text: body),
          ],
        ),
      ),
    ],
  );
}