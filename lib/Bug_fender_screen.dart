import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:verify_feild_worker/constant.dart';

/// =====================
/// API ERROR GUARD
/// =====================
class ApiErrorGuard {
  static bool shown = false;
}

/// =====================
/// MODEL
/// =====================
class ErrorLog {
  final int id;
  final String apiLink;
  final String error;
  final String statusCode;
  final String? date;
  final String? time;


  ErrorLog({
    required this.id,
    required this.apiLink,
    required this.error,
    required this.statusCode,
    this.date,
    this.time,

  });

  factory ErrorLog.fromJson(Map<String, dynamic> json) {
    return ErrorLog(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      apiLink: json['API_link']?.toString() ?? '',
      error: json['error']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      date: json['date']?.toString(),
      time: json['time']?.toString(),

    );
  }
}

/// =====================
/// LOCAL NOTIFICATION
/// =====================
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> showApiError({
    required String api,
    required String statusCode,
    required String message,
  }) async {
    try {
      await init();
      await _plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "🚨 API Error",
        "$api\nStatus: $statusCode",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'api_error',
            'API Errors',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (_) {}
  }
}

/// =====================
/// API SAFE GET
/// =====================
Future<http.Response> safeGet(
    String url, {
      bool notify = false,
    }) async {
  try {
    final res =
    await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (res.statusCode >= 400 && notify && !ApiErrorGuard.shown) {
      ApiErrorGuard.shown = true;
      await LocalNotificationService.showApiError(
        api: url,
        statusCode: res.statusCode.toString(),
        message: res.body,
      );
    }
    return res;
  } catch (e) {
    if (notify && !ApiErrorGuard.shown) {
      ApiErrorGuard.shown = true;
      await LocalNotificationService.showApiError(
        api: url,
        statusCode: "EXCEPTION",
        message: e.toString(),
      );
    }
    rethrow;
  }
}

Future<List<ErrorLog>> fetchErrorLogs() async {
  const url =
      'https://verifyserve.social/Second%20PHP%20FILE/bug_founder/error_show_api.php';

  final res = await safeGet(url); // ❌ no notification here

  if (res.statusCode != 200) {
    throw Exception('HTTP ${res.statusCode}');
  }

  final decoded = jsonDecode(res.body);
  if (decoded is! Map || decoded['status'] != 'success') {
    throw Exception('API failed');
  }

  final List list = decoded['data'] ?? [];
  final logs = list
      .map((e) => ErrorLog.fromJson(Map<String, dynamic>.from(e)))
      .toList();

  logs.sort((a, b) => b.id.compareTo(a.id));
  return logs;
}

/// =====================
/// SCREEN
/// =====================
class ErrorLogScreen extends StatefulWidget {
  static const String errorLogScreen = "/errorLogScreen";

  final bool fromNotification;
  final String? apiFilter;
  final String? statusCodeFilter;
  final String? dateFilter;
  final int tabIndex;

  const ErrorLogScreen({
    Key? key,
    this.fromNotification = false,
    this.apiFilter,
    this.statusCodeFilter,
    this.dateFilter,
    this.tabIndex = 0,
  }) : super(key: key);

  @override
  State<ErrorLogScreen> createState() => _ErrorLogScreenState();
}

class _ErrorLogScreenState extends State<ErrorLogScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<ErrorLog>> _future;
  late TabController _tabController;
  DateTime? selectedDate;

  final categories = const [
    'Backend API',
    'Notification',
    'UI Render',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _future = fetchErrorLogs();

    final safeIndex =
    (widget.tabIndex >= 0 && widget.tabIndex < categories.length)
        ? widget.tabIndex
        : 0;

    _tabController = TabController(
      length: categories.length,
      vsync: this,
      initialIndex: safeIndex,
    );

    if (widget.dateFilter != null) {
      selectedDate = DateTime.tryParse(widget.dateFilter!);
    }
  }

  @override
  void dispose() {
    ApiErrorGuard.shown = false;
    _tabController.dispose();
    super.dispose();
  }

  /// =====================
  /// HELPERS
  /// =====================
  List<ErrorLog> applyDateFilter(List<ErrorLog> logs) {
    if (selectedDate == null) return logs;
    return logs.where((log) {
      if (log.date == null) return false;
      final d = DateTime.tryParse(log.date!);
      return d != null &&
          d.year == selectedDate!.year &&
          d.month == selectedDate!.month &&
          d.day == selectedDate!.day;
    }).toList();
  }

  String detectCategory(ErrorLog log) {
    final text = (log.error + log.apiLink).toLowerCase();

    // 🔔 Only REAL notification related logs
    if (text.contains('fcm') ||
        text.contains('firebase') ||
        text.contains('push') ||
        text.contains('notification')) {
      return 'Notification';
    }

    if (text.contains('render') ||
        text.contains('layout') ||
        text.contains('overflow')) {
      return 'UI Render';
    }

    if (text.contains('.php') ||
        text.contains('sql') ||
        text.contains('api') ||
        text.contains('server')) {
      return 'Backend API';
    }

    return 'Other';
  }



  Map<String, List<ErrorLog>> groupByCategory(List<ErrorLog> logs) {
    final map = <String, List<ErrorLog>>{};
    for (final log in logs) {
      final cat = detectCategory(log);
      map.putIfAbsent(cat, () => []).add(log);
    }
    return map;
  }

  bool isRealError(ErrorLog log) =>
      !log.statusCode.startsWith('200') && log.error.trim().isNotEmpty;

  Color getStatusColor(String code) {
    if (code.startsWith('5')) return Colors.redAccent;
    if (code.startsWith('4')) return Colors.orangeAccent;
    return Colors.grey;
  }

  /// =====================
  /// UI CARD
  /// =====================
  Widget buildErrorCard(ErrorLog log) {
    final statusColor = getStatusColor(log.statusCode);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF181B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ExpansionTile(
            title: Text(
              log.apiLink,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "${log.date ?? ''} ${log.time ?? ''}",
              style: const TextStyle(color: Colors.grey),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  log.error,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF7CFF9E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================
  /// BUILD
  /// =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(AppImages.transparent, height: 36),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF7CFF9E),
          labelColor: const Color(0xFF7CFF9E),
          unselectedLabelColor: Colors.grey,
          tabs: categories.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: Column(
        children: [
          /// DATE FILTER
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                FilterChip(
                  label: Text(selectedDate == null
                      ? 'Select Date'
                      : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"),
                  onSelected: (_) async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: () => setState(() => selectedDate = null),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ErrorLog>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Lottie.asset("assets/images/loadingHand.json"));
                }
                if (snap.hasError) {
                  return Center(child: Text(snap.error.toString()));
                }

                List<ErrorLog> logs =
                applyDateFilter(snap.data!.where(isRealError).toList());

                if (widget.fromNotification == true &&
                    widget.apiFilter != null &&
                    widget.statusCodeFilter != null) {
                  logs = logs.where((e) =>
                  e.apiLink.contains(widget.apiFilter!) &&
                      e.statusCode == widget.statusCodeFilter).toList();
                }

                final grouped = groupByCategory(logs);


                return TabBarView(
                  controller: _tabController,
                  children: categories.map((cat) {
                    List<ErrorLog> list = grouped[cat] ?? [];

                    if (cat == 'Notification' && widget.fromNotification == true) {
                      list = list.where((log) {
                        bool ok = true;

                        if (widget.apiFilter != null) {
                          ok &= log.apiLink.contains(widget.apiFilter!);
                        }

                        if (widget.statusCodeFilter != null) {
                          ok &= log.statusCode == widget.statusCodeFilter;
                        }

                        return ok;
                      }).toList();
                    }


                    if (list.isEmpty) {
                      return const Center(child: Text('No errors 🎉'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: list.length,
                      itemBuilder: (_, i) => buildErrorCard(list[i]),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
