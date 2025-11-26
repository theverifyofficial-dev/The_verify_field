import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RealEstateAnalyticsPage extends StatelessWidget {
  const RealEstateAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Real Estate Analytics",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerText("📈 Monthly Performance Trend"),
            _proCard(_lineChart()),

            const SizedBox(height: 22),
            _headerText("🏡 Rent vs Buy Overview"),
            _proCard(_multiLineChart()),

            const SizedBox(height: 22),
            _headerText("📊 Property Type Distribution"),
            _proCard(_barChart()),

            const SizedBox(height: 22),
            _headerText("📅 Daily Activity Frequency"),
            _proCard(_verticalBarChart()),

            const SizedBox(height: 22),
            _headerText("📦 Overall Business Share"),
            _proCard(_pieChart()),

            const SizedBox(height: 22),
            _headerText("🎯 Target Completion Status"),
            _proCard(_donutChart()),
          ],
        ),
      ),
    );
  }

  // --------------------- HEADER TITLE ---------------------
  Widget _headerText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  // --------------------- PROFESSIONAL CARD ---------------------
  Widget _proCard(Widget child) {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff1A1A1A), Color(0xff0F0F0F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  // ---------------------------------------------------------------
  // --------------------- LINE CHART ------------------------------
  // ---------------------------------------------------------------
  Widget _lineChart() {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white12,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.greenAccent,
            barWidth: 4,
            dotData: FlDotData(show: false),
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 3),
              FlSpot(2, 2.5),
              FlSpot(3, 4),
              FlSpot(4, 3),
              FlSpot(5, 5),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------- MULTI LINE CHART ------------------------

  Widget _multiLineChart() {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.tealAccent,
            barWidth: 4,
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 2),
              FlSpot(2, 1.5),
              FlSpot(3, 3),
              FlSpot(4, 2),
            ],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.purpleAccent,
            barWidth: 4,
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 3),
              FlSpot(2, 2.5),
              FlSpot(3, 3.5),
              FlSpot(4, 4),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------- BAR CHART -------------------------------

  Widget _barChart() {
    return BarChart(
      BarChartData(
        backgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        barGroups: [
          _bar(0, 5, Colors.orangeAccent),
          _bar(1, 3, Colors.blueAccent),
          _bar(2, 4, Colors.greenAccent),
          _bar(3, 2, Colors.pinkAccent),
        ],
      ),
    );
  }

  BarChartGroupData _bar(double x, double y, Color c) {
    return BarChartGroupData(
      x: x.toInt(),
      barRods: [
        BarChartRodData(
          toY: y,
          width: 22,
          color: c,
          borderRadius: BorderRadius.circular(8),
        )
      ],
    );
  }


  // --------------------- VERTICAL BAR CHART ----------------------

  Widget _verticalBarChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: [
          _bar(0, 8, Colors.cyanAccent),
          _bar(1, 10, Colors.pinkAccent),
          _bar(2, 6, Colors.tealAccent),
          _bar(3, 12, Colors.yellowAccent),
          _bar(4, 9, Colors.greenAccent),
        ],
      ),
    );
  }

  // --------------------- PIE CHART -------------------------------

  Widget _pieChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sectionsSpace: 4,
        sections: [
          _pie(40, Colors.blueAccent),
          _pie(25, Colors.orangeAccent),
          _pie(20, Colors.greenAccent),
          _pie(15, Colors.purpleAccent),
        ],
      ),
    );
  }

  PieChartSectionData _pie(double value, Color c) {
    return PieChartSectionData(
      value: value,
      color: c,
      radius: 65,
      showTitle: false,
    );
  }

  // --------------------- DONUT CHART -----------------------------

  Widget _donutChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 45,
        sectionsSpace: 5,
        sections: [
          _pie(60, Colors.greenAccent),
          _pie(40, Colors.white12),
        ],
      ),
    );
  }
}
