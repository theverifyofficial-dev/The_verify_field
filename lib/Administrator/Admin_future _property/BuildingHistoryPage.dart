import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────
class NotifHistory {
  final int id;
  final int flatPId;
  final String liveId;
  final String actionType;
  final String fwName;
  final String fwNumber;
  final String notifTitle;
  final String notifBody;
  final DateTime createdAt;
  final String subid;

  NotifHistory({
    required this.id,
    required this.flatPId,
    required this.liveId,
    required this.actionType,
    required this.fwName,
    required this.fwNumber,
    required this.notifTitle,
    required this.notifBody,
    required this.createdAt,
    required this.subid,
  });

  factory NotifHistory.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      final raw = json['created_at'];
      if (raw is Map) {
        parsedDate = DateTime.parse(raw['date'].toString().trim());
      } else {
        parsedDate = DateTime.parse(raw.toString().trim());
      }
    } catch (_) {
      parsedDate = DateTime.now();
    }
    return NotifHistory(
      id:         json['id'] ?? 0,
      flatPId:    json['flat_p_id'] ?? 0,
      liveId:     json['live_id']?.toString() ?? '',
      actionType: json['action_type'] ?? '',
      fwName:     json['fw_name'] ?? '',
      fwNumber:   json['fw_number']?.toString() ?? '',
      notifTitle: json['notif_title'] ?? '',
      notifBody:  json['notif_body'] ?? '',
      createdAt:  parsedDate,
      subid:      json['subid']?.toString() ?? '',
    );
  }

  bool get isLive => actionType == 'update';
}

// ─────────────────────────────────────────────
// THEME COLORS HELPER
// ─────────────────────────────────────────────
class _C {
  final bool isDark;
  _C(this.isDark);

  Color get bg         => isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF2F4F7);
  Color get surface    => isDark ? const Color(0xFF1A1A1A) : Colors.white;
  Color get card       => isDark ? const Color(0xFF111111) : Colors.white;
  Color get border     => isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.07);
  Color get divider    => isDark ? Colors.white10 : Colors.black.withOpacity(0.08);
  Color get textPrimary   => isDark ? Colors.white : const Color(0xFF111827);
  Color get textSecondary => isDark ? Colors.white54 : const Color(0xFF6B7280);
  Color get textMuted     => isDark ? Colors.white24 : const Color(0xFFADB5BD);
  Color get chipBg        => isDark ? const Color(0xFF1A1A1A) : const Color(0xFFEEF0F3);
  Color get chipBorder    => isDark ? Colors.white12 : Colors.black.withOpacity(0.09);
  Color get iconMuted     => isDark ? Colors.white24 : Colors.black26;
  Color get refreshBg     => isDark ? const Color(0xFF1A1A1A) : Colors.white;
  Color get refreshIcon   => isDark ? Colors.white : Colors.black87;

  static const Color live   = Color(0xFF22C55E);
  static const Color booked = Color(0xFFF97316);
  static const Color total  = Color(0xFF3B82F6);
}

// ─────────────────────────────────────────────
// HISTORY PAGE
// ─────────────────────────────────────────────
class HistoryPage extends StatefulWidget {
  final String fwNumber;
  final String? fwName;

  const HistoryPage({
    super.key,
    required this.fwNumber,
    this.fwName,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<NotifHistory> _all      = [];
  List<NotifHistory> _filtered = [];
  bool    _isLoading = true;
  String? _error;
  String  _filter = 'all';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/'
            'dispay_notification_history_for_fields.php?fw_number=${widget.fwNumber}',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        final List raw = body['data'] ?? [];
        _all = raw.map((e) => NotifHistory.fromJson(e)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _applyFilter(_filter);
      } else {
        _error = 'Server error: ${res.statusCode}';
      }
    } catch (e) {
      _error = 'Connection failed. Pull to retry.';
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _applyFilter(String f) {
    _filter = f;
    if (f == 'live')        _filtered = _all.where((e) => e.isLive).toList();
    else if (f == 'booked') _filtered = _all.where((e) => !e.isLive).toList();
    else                    _filtered = List.from(_all);
    setState(() {});
  }

  Map<String, List<NotifHistory>> get _grouped {
    final map = <String, List<NotifHistory>>{};
    for (final h in _filtered) {
      map.putIfAbsent(_dateLabel(h.createdAt), () => []).add(h);
    }
    return map;
  }

  String _dateLabel(DateTime dt) {
    final now  = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(dt.year, dt.month, dt.day))
        .inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(dt);
  }

  String _timeStr(DateTime dt) => DateFormat('hh:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final c          = _C(isDark);
    final liveCount  = _all.where((e) => e.isLive).length;
    final bookedCount= _all.where((e) => !e.isLive).length;

    return RefreshIndicator(
      color: c.refreshIcon,
      backgroundColor: c.refreshBg,
      onRefresh: _fetch,
      child: SizedBox.expand(
        child: ColoredBox(
          color: c.bg,
          child: _isLoading
              ? _buildLoader(c)
              : _error != null
              ? _buildError(c)
              : Column(
            children: [
              _buildStats(c, liveCount, bookedCount),
              _buildFilterRow(c),
              Expanded(
                child: _filtered.isEmpty
                    ? _buildEmpty(c)
                    : ListView(
                  padding: const EdgeInsets.only(bottom: 30),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ..._grouped.entries.expand((entry) => [
                      _buildDateHeader(entry.key, c),
                      ...List.generate(
                        entry.value.length,
                            (i) => _buildCard(entry.value[i], c),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Loader ──
  Widget _buildLoader(_C c) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: c.textSecondary, strokeWidth: 2),
        const SizedBox(height: 14),
        Text('Loading history…',
            style: TextStyle(
                color: c.textSecondary,
                fontSize: 13,
                fontFamily: 'PoppinsRegular')),
      ],
    ),
  );

  // ── Error ──
  Widget _buildError(_C c) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(PhosphorIcons.wifi_slash, color: c.textMuted, size: 48),
        const SizedBox(height: 14),
        Text(_error!,
            style: TextStyle(
                color: c.textSecondary,
                fontSize: 13,
                fontFamily: 'PoppinsRegular'),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _fetch,
          child: Text('Retry',
              style: TextStyle(
                  color: c.textPrimary, fontFamily: 'PoppinsMedium')),
        ),
      ],
    ),
  );

  // ── Empty ──
  Widget _buildEmpty(_C c) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(PhosphorIcons.bell_slash, color: c.textMuted, size: 48),
        const SizedBox(height: 12),
        Text('No records found',
            style: TextStyle(
                color: c.textSecondary,
                fontSize: 14,
                fontFamily: 'PoppinsMedium')),
      ],
    ),
  );

  // ── Stats ──
  Widget _buildStats(_C c, int live, int booked) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          _statBox(c, 'Total',  _all.length.toString(), _C.total,  PhosphorIcons.list_bullets),
          const SizedBox(width: 10),
          _statBox(c, 'Live',   live.toString(),         _C.live,   PhosphorIcons.check_circle),
          const SizedBox(width: 10),
          _statBox(c, 'Booked', booked.toString(),       _C.booked, PhosphorIcons.tag),
        ],
      ),
    );
  }

  Widget _statBox(_C c, String label, String val, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: c.isDark ? color.withOpacity(0.08) : color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: c.isDark ? color.withOpacity(0.20) : color.withOpacity(0.25),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.bold,
                    fontFamily: 'PoppinsBold')),
                Text(label, style: TextStyle(
                    color: color.withOpacity(0.65), fontSize: 11,
                    fontFamily: 'PoppinsMedium')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter row ──
  Widget _buildFilterRow(_C c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          _chip(c, 'all',    'All',    PhosphorIcons.funnel),
          const SizedBox(width: 8),
          _chip(c, 'live',   'Live',   PhosphorIcons.check_circle),
          const SizedBox(width: 8),
          _chip(c, 'booked', 'Booked', PhosphorIcons.tag),
        ],
      ),
    );
  }

  Widget _chip(_C c, String val, String label, IconData icon) {
    final selected = _filter == val;
    final Color col = val == 'live'
        ? _C.live
        : val == 'booked'
        ? _C.booked
        : _C.total;
    return GestureDetector(
      onTap: () => _applyFilter(val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? col.withOpacity(c.isDark ? 0.15 : 0.10)
              : c.chipBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? col.withOpacity(0.5)
                : c.chipBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13,
                color: selected ? col : c.textSecondary),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                  color: selected ? col : c.textSecondary,
                  fontSize: 12,
                  fontFamily: selected ? 'PoppinsBold' : 'PoppinsMedium',
                )),
          ],
        ),
      ),
    );
  }

  // ── Date header ──
  Widget _buildDateHeader(String label, _C c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: c.textSecondary,
                  fontSize: 12,
                  fontFamily: 'PoppinsMedium',
                  letterSpacing: 0.5)),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: c.divider)),
        ],
      ),
    );
  }

  // ── Card ──
  Widget _buildCard(NotifHistory h, _C c) {
    final isLive  = h.isLive;
    final color   = isLive ? _C.live : _C.booked;
    final icon    = isLive ? PhosphorIcons.check_circle : PhosphorIcons.tag;
    final bgColor = color.withOpacity(c.isDark ? 0.07 : 0.06);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
          boxShadow: c.isDark
              ? []
              : [BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )],
        ),
        child: Row(
          children: [
            // Color bar
            Container(
              width: 4,
              height: 76,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Icon circle
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(h.notifTitle,
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: 13,
                                fontFamily: 'PoppinsBold',
                              )),
                        ),
                        Text(_timeStr(h.createdAt),
                            style: TextStyle(
                                color: c.refreshIcon,
                                fontSize: 11,
                                fontFamily: 'PoppinsMedium')),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(h.notifBody,
                        style: TextStyle(
                            color: c.textSecondary,
                            fontSize: 12,
                            fontFamily: 'PoppinsRegular'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _miniChip('SubId: ${h.subid}',
                            PhosphorIcons.door, c.refreshIcon),
                        const SizedBox(width: 10),
                        _miniChip('Building Id: ${h.subid}',
                            PhosphorIcons.buildings, c.refreshIcon),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(String label, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontFamily: 'PoppinsRegular')),
      ],
    );
  }
}