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

    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/book_flat_for_fieldworkar.php",
    );

    try {
      // 1. Copy
      final copyResponse = await http.post(url, body: {
        "action": "copy",
        "p_id": widget.id,
      });

      _responseMessage += copyResponse.statusCode == 200
          ? "✅ Copy Success: ${copyResponse.body}\n"
          : "❌ Copy Failed: ${copyResponse.statusCode}\n";

      // 2. Update
      final updateResponse = await http.post(url, body: {
        "action": "update",
        "subid": widget.subid,
      });

      _responseMessage += updateResponse.statusCode == 200
          ? "✅ Update Success: ${updateResponse.body}\n"
          : "❌ Update Failed: ${updateResponse.statusCode}\n";

      // 3. Delete
      final deleteResponse = await http.post(url, body: {
        "action": "delete",
        "p_id": widget.id,
      });

      _responseMessage += deleteResponse.statusCode == 200
          ? "✅ Delete Success: ${deleteResponse.body}"
          : "❌ Delete Failed: ${deleteResponse.statusCode}";
    } catch (e) {
      _responseMessage += "⚠ Exception: $e";
    } finally {
      setState(() {
        _loading = false;
      });
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

              if (_loading) const CircularProgressIndicator(),
              if (_responseMessage.isNotEmpty)
                Text(_responseMessage,
                    style: const TextStyle(fontSize: 14, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}
