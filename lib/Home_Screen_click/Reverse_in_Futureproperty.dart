import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReverseInFutureProperty extends StatefulWidget {
  final int id; // initial pid

  const ReverseInFutureProperty({super.key, required this.id});

  @override
  State<ReverseInFutureProperty> createState() =>
      _ReverseInFuturePropertyState();
}

class _ReverseInFuturePropertyState extends State<ReverseInFutureProperty> {
  final TextEditingController _subidController = TextEditingController();
  Map<String, dynamic>? propertyData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProperty(widget.id); // load initial data
  }

  // First API
  Future<void> _loadProperty(int id) async {
    setState(() => _loading = true);

    try {
      final url = Uri.parse(
          "https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=$id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final raw = response.body.trim();

        final start = raw.indexOf("[");
        final end = raw.lastIndexOf("]") + 1;

        if (start != -1 && end != -1) {
          final jsonStr = raw.substring(start, end);
          final List<dynamic> data = jsonDecode(jsonStr);

          setState(() {
            propertyData = data.isNotEmpty ? data.first : null;
          });
        } else {
          setState(() => propertyData = null);
        }
      } else {
        setState(() => propertyData = null);
      }
    } catch (e) {
      print("🔴 Error: $e");
      setState(() => propertyData = null);
    }

    setState(() => _loading = false);
  }

  // Second API (pid + subid)
  Future<void> _sendPidAndSubid() async {
    final subid = _subidController.text.trim();
    if (subid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter SubID")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/reverised.php?pid=${widget.id}&subid=$subid");

      print("🔹 Calling Second API: $url");

      final response = await http.get(url);

      print("🔹 Second API Status: ${response.statusCode}");
      print("🔹 Response: ${response.body}");

      if (response.statusCode == 200) {
        final raw = response.body.trim();
        if (raw.startsWith("{") || raw.startsWith("[")) {
          final decoded = jsonDecode(raw);
          setState(() {
            propertyData =
            decoded is List ? (decoded.isNotEmpty ? decoded.first : null) : decoded;
          });
        }
      }
    } catch (e) {
      print("🔴 Error in second API: $e");
    }

    setState(() => _loading = false);
  }

  void _onSendData() {
    final subid = _subidController.text.trim();
    if (subid.isNotEmpty) {
      final newId = int.tryParse(subid);
      if (newId != null) {
        _loadProperty(newId); // reload with new ID
      }
    }
  }

  // 🔹 Show Alert before Reverse Property
  void _confirmReverseProperty() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Action"),
        content: const Text("Do you want to move this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // ❌ Cancel
            child: const Text("No",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _sendPidAndSubid(); // ✅ call API
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text("Yes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetails() {
    if (propertyData == null) {
      return const Text("No property data available");
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (propertyData!["images"] != null &&
              propertyData!["images"].toString().isNotEmpty)
            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${propertyData!["images"]}",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

          const SizedBox(height: 16),

          ...propertyData!.entries.map((entry) {
            final key = entry.key;
            final value = entry.value?.toString().trim();

            if (value == null || value.isEmpty) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "$key: $value",
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main RealEstate id : ${widget.id}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _subidController,
              decoration: const InputDecoration(
                labelText: "Enter SubID",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _onSendData,
              child: const Text("Send Data"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _confirmReverseProperty, // ✅ now shows alert
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text(
                "Reverse Property",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(child: _buildPropertyDetails()),
            ),
          ],
        ),
      ),
    );
  }
}
