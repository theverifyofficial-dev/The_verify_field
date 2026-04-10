class DemandUtils {
  static String FormatPrice(num value) {
    if (value >= 10000000) {
      final v = value / 10000000;
      return v % 1 == 0 ? "₹${v.toInt()}Cr" : "₹${v.toStringAsFixed(1)}Cr";
    } else if (value >= 100000) {
      final v = value / 100000;
      return v % 1 == 0 ? "₹${v.toInt()}L" : "₹${v.toStringAsFixed(1)}L";
    } else if (value >= 1000) {
      return "₹${(value / 1000).toStringAsFixed(0)}k";
    } else {
      return "₹${value.toInt()}";
    }
  }

  static String formatPriceRange(dynamic price) {
    if (price == null || price.toString().trim().isEmpty) {
      return "₹ --";
    }

    try {
      final str = price.toString().replaceAll(RegExp(r'[^\d\-]'), '');

      if (str.contains("-")) {
        final parts = str.split("-");
        if (parts.length != 2) return "₹ --";

        final start = double.tryParse(parts[0]);
        final end = double.tryParse(parts[1]);

        if (start == null || end == null) return "₹ --";

        return "${FormatPrice(start)} – ${FormatPrice(end)}";
      }

      final single = double.tryParse(str);
      if (single != null) return FormatPrice(single);

      return "₹ --";
    } catch (_) {
      return "₹ --";
    }
  }

  static String formatDate(String apiDate) {
    if (apiDate.isEmpty) return "";
    try {
      final dt = DateTime.parse(apiDate);
      return "${dt.day} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return apiDate;
    }
  }

  static String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}