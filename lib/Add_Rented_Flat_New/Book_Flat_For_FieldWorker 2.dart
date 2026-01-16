import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RentedPropertyPage extends StatefulWidget {
  final String id;
  final String subid;

  const RentedPropertyPage({Key? key, required this.id, required this.subid})
      : super(key: key);

  @override
  State<RentedPropertyPage> createState() => _RentedPropertyPageState();
}

class _RentedPropertyPageState extends State<RentedPropertyPage> {
  bool _loading = false;
  String _responseMessage = "";

  Future<void> _performAllActions() async {
    setState(() {
      _loading = true;
      _responseMessage = "";
    });

    try {
      final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
      final bookingDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final bookingTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/book_flat_for_fieldworkar.php");

      // Step 1
      final copy = await http.post(url, body: {
        "action": "copy",
        "p_id": widget.id,
        "booking_date": bookingDate,
        "booking_time": bookingTime,
      });

      // Step 2
      final update = await http.post(url, body: {
        "action": "update",
        "subid": widget.subid,
      });

      // Step 3
      final delete = await http.post(url, body: {
        "action": "delete",
        "p_id": widget.id,
      });

      if (copy.statusCode == 200 &&
          update.statusCode == 200 &&
          delete.statusCode == 200) {
        setState(() {
          _responseMessage = "✅ Property booked successfully";
        });
      } else {
        setState(() {
          _responseMessage = "❌ Something went wrong while processing.";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "❌ Error: ${e.toString()}";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rented Property"),
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Property ID: ${widget.id}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // ✅ Single Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _loading ? null : _performAllActions,
                child: const Text(
                  "Book",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "PoppinsBold"),
                ),
              ),

              const SizedBox(height: 24),

              if (_responseMessage.isNotEmpty)
                Builder(
                  builder: (context) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    final isSuccess = _responseMessage.toLowerCase().contains("success");

                    final Color bgColor = isSuccess
                        ? (isDark ? Colors.green.shade900 : Colors.green.shade100)
                        : (isDark ? Colors.red.shade900 : Colors.red.shade100);

                    final Color borderColor = isSuccess
                        ? (isDark ? Colors.greenAccent : Colors.green)
                        : (isDark ? Colors.redAccent : Colors.red);

                    final Color textColor = isSuccess
                        ? (isDark ? Colors.white : Colors.green.shade800)
                        : (isDark ? Colors.red.shade200 : Colors.red.shade800);


                    return Expanded(
                      child: Text(
                        _responseMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    );
                  },
                ),

            ],
          ),
        ),
      ),
    );
  }
}
