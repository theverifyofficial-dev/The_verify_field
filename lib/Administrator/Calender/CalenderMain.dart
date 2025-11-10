import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import '../Administator_Agreement/Admin_Agreement_details.dart';

/// MODEL FOR AGREEMENT TASKS
class AgreementTaskResponse {
  final String status;
  final List<AgreementTask> data;

  AgreementTaskResponse({required this.status, required this.data});

  factory AgreementTaskResponse.fromJson(Map<String, dynamic> json) {
    return AgreementTaskResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AgreementTask.fromJson(e))
          .toList() ??
          [],
    );
  }

  static AgreementTaskResponse fromRawJson(String str) =>
      AgreementTaskResponse.fromJson(json.decode(str));
}

class AgreementTask {
  final int id;
  final String ownerName;
  final String tenantName;
  final String rentedAddress;
  final String monthlyRent;
  final String bhk;
  final String floor;
  final String agreementType;
  final String status;
  final String? tenantImage;
  final String? shiftingDate;

  AgreementTask({
    required this.id,
    required this.ownerName,
    required this.tenantName,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.bhk,
    required this.floor,
    required this.agreementType,
    required this.status,
    this.tenantImage,
    this.shiftingDate,
  });

  factory AgreementTask.fromJson(Map<String, dynamic> json) {
    return AgreementTask(
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      tenantName: json['tenant_name'] ?? '',
      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      status: json['status'] ?? '',
      tenantImage: json['tenant_image'],
      shiftingDate: json['shifting_date'],
    );
  }
}

/// MAIN PAGE
class CalendarTaskPage extends StatefulWidget {
  const CalendarTaskPage({Key? key}) : super(key: key);

  @override
  State<CalendarTaskPage> createState() => _CalendarTaskPageState();
}

class _CalendarTaskPageState extends State<CalendarTaskPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = false;
  List<AgreementTask> _tasks = [];

  /// Dropdown lists
  final List<int> _years = List.generate(10, (i) => 2022 + i);
  final List<String> _months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedYear = _focusedDay.year;
    _selectedMonth = _focusedDay.month;
    _fetchTasks(_focusedDay);
  }

  /// ✅ Fetch API Data
  Future<void> _fetchTasks(DateTime date) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_agreement_on_date.php?current_dates=$formattedDate&Fieldwarkarnumber=11";

      final res =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (res.statusCode == 200 && res.body.contains('"status"')) {
        final parsed = AgreementTaskResponse.fromRawJson(res.body);
        setState(() {
          _tasks = parsed.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _tasks = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching tasks: $e");
      if (!mounted) return;
      setState(() {
        _tasks = [];
        _isLoading = false;
      });
    }
  }

  String _monthName(int month) => _months[month - 1];

  Future<void> _showMonthYearPicker(BuildContext context) async {
    int tempYear = _selectedYear;
    int tempMonth = _selectedMonth;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final accent = isDark ? Colors.indigoAccent : Colors.indigo;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // For glassy effect
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.6)
                        : Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 340,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    "Select Month & Year",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// 🧭 Wheel Pickers for Month & Year
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 🗓 Month Picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: tempMonth - 1),
                            itemExtent: 40,
                            looping: true,
                            backgroundColor: Colors.transparent,
                            onSelectedItemChanged: (index) {
                              setModalState(() => tempMonth = index + 1);
                            },
                            children: List.generate(
                              _months.length,
                                  (index) => Center(
                                child: Text(
                                  _months[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 📅 Year Picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: _years.indexOf(tempYear)),
                            itemExtent: 40,
                            backgroundColor: Colors.transparent,
                            onSelectedItemChanged: (index) {
                              setModalState(() => tempYear = _years[index]);
                            },
                            children: _years
                                .map(
                                  (y) => Center(
                                child: Text(
                                  y.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedYear = tempYear;
                        _selectedMonth = tempMonth;
                        _focusedDay = DateTime(tempYear, tempMonth, 1);
                        _selectedDay = _focusedDay;
                      });
                      _fetchTasks(_focusedDay);
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      "Apply",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F6FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Task Calendar", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            /// 🔹 Calendar Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _showMonthYearPicker(context),
                            child: Row(
                              children: [
                                Text(
                                  "${_monthName(_selectedMonth)} ${_selectedYear}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey.shade900,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(PhosphorIcons.arrow_clockwise),
                            color: Colors.grey,
                            onPressed: () =>
                                _fetchTasks(_selectedDay ?? DateTime.now()),
                          ),
                        ],
                      ),
                      TableCalendar(
                        focusedDay: _focusedDay,
                        firstDay: DateTime(2023),
                        lastDay: DateTime(2030),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarFormat: CalendarFormat.month,
                        headerVisible: false,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(

                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.grey.shade100
                                : Colors.grey[700],
                          ),
                          weekendStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade400,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: Colors.indigo,
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: TextStyle(
                            fontSize: 13,
                            color:
                            isDark ? Colors.white : Colors.grey.shade900,
                          ),
                        ),
                        onDaySelected: (selected, focused) {
                          setState(() {
                            _selectedDay = selected;
                            _focusedDay = focused;
                          });
                          _fetchTasks(selected);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 📋 Task List
            _isLoading
                ? const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: Colors.indigo),
            )
                : _tasks.isEmpty
                ? _buildEmptyState(context)
                : Padding(
              padding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tasks for ${_selectedDay?.day ?? _focusedDay.day} ${_monthName(_selectedMonth)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) =>
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 8),
                          child: _buildTaskCard(
                              context, _tasks[index]),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, AgreementTask task) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AdminAgreementDetails(agreementId: task.id.toString()),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.agreementType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    task.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("Owner: ${task.ownerName}"),
              Text("Tenant: ${task.tenantName}"),
              Text("Rent: ₹${task.monthlyRent}"),
              Text("Address: ${task.rentedAddress}",
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(Icons.task_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text("No tasks found for this date",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
