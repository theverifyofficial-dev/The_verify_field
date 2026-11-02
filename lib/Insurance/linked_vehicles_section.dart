// 2026-10-29, Building/Flat insurance-linking feature.
//
// One shared widget used by both the Building Detail page and the Flat
// Detail page to show their linked vehicles as a small grid, with an
// "Add Vehicle" action and its own loading/error/empty states -- so both
// detail pages share exactly one implementation instead of two drifting
// copies (the project's own InsuranceModel/InsuranceListCard precedent).
//
// 2026-10-29 (same day, follow-up): the mini-card was recreated to surface
// more of the "important data" a field worker actually needs at a glance --
// vehicle number, owner name, and vehicle model, in addition to the photo,
// insurer, and expiry status this card already had -- see the project doc's
// §37 for the full writeup.

import 'package:flutter/material.dart';
import 'InsuranceDetail.dart';
import 'InsuranceShowListPage.dart' show InsuranceModel;
import 'insurance_ui_kit.dart' show InsColors, InsBadgeTone, insuranceExpiryStatusFor, insuranceExpiryTone, insuranceExpiryIcon, insuranceExpiryCardText;

class LinkedVehiclesSection extends StatefulWidget {
  const LinkedVehiclesSection({
    super.key,
    required this.title,
    required this.fetcher,
    required this.onAddVehicle,
  });

  final String title;
  final Future<List<InsuranceModel>> Function() fetcher;
  final VoidCallback onAddVehicle;

  @override
  State<LinkedVehiclesSection> createState() => LinkedVehiclesSectionState();
}

class LinkedVehiclesSectionState extends State<LinkedVehiclesSection> {
  bool _loading = true;
  String? _error;
  List<InsuranceModel> _vehicles = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.fetcher();
      if (!mounted) return;
      setState(() {
        _vehicles = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load linked vehicles. Pull to retry.';
        _loading = false;
      });
    }
  }

  /// Public so the parent page can refresh this section after returning
  /// from the Add Vehicle form (same pattern as the other list screens'
  /// `.then((_) => fetchInsurance())`).
  Future<void> refresh() => _load();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
            TextButton.icon(
              onPressed: widget.onAddVehicle,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Add Vehicle', style: TextStyle(fontWeight: FontWeight.w700)),
              style: TextButton.styleFrom(foregroundColor: InsColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(_error!, style: const TextStyle(color: InsColors.textSecondary, fontSize: 12.5), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_vehicles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: const Text('No vehicles linked yet', style: TextStyle(color: InsColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.98,
      ),
      itemCount: _vehicles.length,
      itemBuilder: (context, index) => _VehicleMiniCard(item: _vehicles[index]),
    );
  }
}

class _VehicleMiniCard extends StatelessWidget {
  const _VehicleMiniCard({required this.item});

  final InsuranceModel item;

  static Widget _photoPlaceholder() => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.directions_car_outlined, color: InsColors.textMuted, size: 19),
      );

  /// Same "prefer the model, fall back to the maker description" rule
  /// `InsuranceListCard`'s `_vehicleModelLabel` already established
  /// (§25.2) -- duplicated here rather than imported, since the List
  /// screens' helper is private to each of those files, not shared.
  String? _modelLabel() {
    final model = item.makerModel?.trim();
    if (model != null && model.isNotEmpty) return model;
    final desc = item.makerDesc?.trim();
    if (desc != null && desc.isNotEmpty) return desc;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final expiryStatus = insuranceExpiryStatusFor(item.insuranceUpto);
    final modelLabel = _modelLabel();
    final ownerName = item.name?.trim();
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InsuranceDetailScreen(insuranceId: item.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: InsColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: InsColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Photo + vehicle number (the most important identifier -- kept
            // primary/bold, same as the List screens' card, §32).
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.carPhotoUrl != null
                      ? Image.network(
                          item.carPhotoUrl!,
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _photoPlaceholder(),
                        )
                      : _photoPlaceholder(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.vehicleNumber?.trim().isNotEmpty == true ? item.vehicleNumber! : 'No vehicle number',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Owner name -- secondary line, same priority order the List
            // cards use (vehicle number primary, owner name secondary, §32).
            Row(
              children: [
                const Icon(Icons.person_outline, size: 12, color: InsColors.textMuted),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    ownerName != null && ownerName.isNotEmpty ? ownerName : 'Owner not set',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: InsColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (modelLabel != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.directions_car_filled_outlined, size: 12, color: InsColors.textMuted),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      modelLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: InsColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 6),
            const Divider(height: 10, color: InsColors.border),
            Text(
              item.insuranceComp?.trim().isNotEmpty == true ? item.insuranceComp! : 'Insurer not set',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: InsColors.textSecondary, fontSize: 11),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(insuranceExpiryIcon(expiryStatus), size: 13, color: insuranceExpiryTone(expiryStatus) == InsBadgeTone.error ? InsColors.error : InsColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    insuranceExpiryCardText(item.insuranceUpto),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: InsColors.textSecondary, fontSize: 10.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
