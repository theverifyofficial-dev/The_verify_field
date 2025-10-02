import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class AddRentedMain extends StatefulWidget {
  const AddRentedMain({super.key});

  @override
  State<AddRentedMain> createState() => _AddRentedMainState();
}

class _AddRentedMainState extends State<AddRentedMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Performance"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Monthly"),
            Tab(text: "Yearly"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _wrapWithScroll(_buildMonthlyReport()),
          _wrapWithScroll(_buildYearlyReport()),
        ],
      ),
    );
  }

  /// ✅ Wrap all content in scrollable view
  Widget _wrapWithScroll(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  /// -------------------- MONTHLY REPORT --------------------
  Widget _buildMonthlyReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Monthly Performance Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        // ✅ Progress Circles (easy for workers to read)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildProgress("Rent", 0.7, Colors.green, "70/100"),
            _buildProgress("Sell", 0.6, Colors.orange, "50/80"),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildProgress("Agreement", 0.5, Colors.blue, "30/60"),
            _buildProgress("Add", 0.4, Colors.red, "20/50"),
          ],
        ),

        const SizedBox(height: 40),

        // ✅ One simple Bar Chart for comparison
        const Text("Overall Comparison (Target vs Achieved)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              maxY: 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text("Rent");
                        case 1:
                          return const Text("Sell");
                        case 2:
                          return const Text("Agreement");
                        case 3:
                          return const Text("Add");
                        default:
                          return const Text("");
                      }
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(toY: 100, color: Colors.grey, width: 15),
                  BarChartRodData(toY: 70, color: Colors.green, width: 15),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(toY: 80, color: Colors.grey, width: 15),
                  BarChartRodData(toY: 50, color: Colors.orange, width: 15),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(toY: 60, color: Colors.grey, width: 15),
                  BarChartRodData(toY: 30, color: Colors.blue, width: 15),
                ]),
                BarChartGroupData(x: 3, barRods: [
                  BarChartRodData(toY: 50, color: Colors.grey, width: 15),
                  BarChartRodData(toY: 20, color: Colors.red, width: 15),
                ]),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ✅ Simple Summary Text
        const Text("Summary:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("✔ You completed 70% of Rent target 🎉"),
        const Text("✔ You completed 62% of Sell target 👍"),
        const Text("✔ You completed 50% of Agreement target ✍️"),
        const Text("✔ You completed 40% of Add target 🔴"),
      ],
    );
  }

  /// -------------------- YEARLY REPORT --------------------
  Widget _buildYearlyReport() {
    final List<int> target = [1000, 900, 950, 1100, 1050, 1200, 1150, 1300, 1250, 1400, 1350, 1500];
    final List<int> achieved = [800, 700, 750, 900, 850, 1000, 950, 1200, 1100, 1300, 1250, 1400];

    // Track chart type (true = Bar, false = Line)
    bool showBarChart = true;

    return StatefulBuilder(
      builder: (context, setState) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Yearly Performance Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // ✅ Chart Switcher
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Bar Chart"),
                  selected: showBarChart,
                  onSelected: (val) => setState(() => showBarChart = true),
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text("Line Chart"),
                  selected: !showBarChart,
                  onSelected: (val) => setState(() => showBarChart = false),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ✅ Chart Container
            SizedBox(
              height: 400,
              width: double.infinity,
              child: showBarChart
                  ? BarChart(
                BarChartData(
                  maxY: 1600,
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(12, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: target[index].toDouble(),
                          color: Colors.grey.shade300,
                          width: 20,
                        ),
                        BarChartRodData(
                          toY: achieved[index].toDouble(),
                          color: Colors.blueAccent,
                          width: 20,
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("M${value.toInt() + 1}", style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 200,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 200,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 0.5),
                  ),
                ),
              )
                  : LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY: 1600,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      spots: List.generate(
                          12, (index) => FlSpot((index + 1).toDouble(), achieved[index].toDouble())),
                    ),
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.grey,
                      barWidth: 3,
                      spots: List.generate(
                          12, (index) => FlSpot((index + 1).toDouble(), target[index].toDouble())),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("M${value.toInt()}", style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 200,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 200,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Yearly Summary:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text("✔ You improved steadily across the months 📈"),
            const SizedBox(height: 8),
            const Text("✔ Biggest jump in Month 8 (1200 units) 🚀"),
            const SizedBox(height: 8),
            const Text("✔ You finished the year strong with 1400 units 👏"),
          ],
        ),
      ),
    );
  }


  /// -------------------- REUSABLE PROGRESS WIDGET --------------------
  Widget _buildProgress(
      String title, double percent, Color color, String label) {
    return CircularPercentIndicator(
      radius: 60,
      lineWidth: 12,
      percent: percent,
      center: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      progressColor: color,
      backgroundColor: Colors.grey.shade200,
      footer: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
      animation: true,
      animationDuration: 800,
    );
  }
}