import 'dart:async';
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
  Timer? _countdownTimer; // <-- add this

  @override
  void initState() {
    super.initState();
    _loadProperty(widget.id); // load initial data
  }
  @override
  void dispose() {
    _countdownTimer?.cancel();       // <-- cancel on dispose
    _subidController.dispose();
    super.dispose();
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
  int _countdown = 0;
  bool _showSuccess = false;

  bool _isButtonDisabled = false;

  void _confirmReverseProperty() {
    if (_isButtonDisabled) return; // avoid double taps
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Action"),
        content: const Text("Do you want to move this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close confirm dialog
              _startReverseProcess(); // start countdown + success + pop back
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _startReverseProcess() {
    setState(() {
      _isButtonDisabled = true;
      _countdown = 5;
      _showSuccess = false;
    });

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        bool started = false;

        return StatefulBuilder(
          builder: (ctx, setSB) {
            if (!started) {
              started = true;
              _countdownTimer?.cancel();
              _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) async {
                if (!mounted) { t.cancel(); return; }

                if (_countdown > 0) {
                  setSB(() => _countdown--);
                } else {
                  t.cancel();
                  await _sendPidAndSubid();

                  setSB(() => _showSuccess = true);

                  await Future.delayed(const Duration(seconds: 2));
                  if (!mounted) return;

                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                  if (Navigator.of(context).canPop()) Navigator.of(context).pop(true);

                  if (mounted) {
                    setState(() => _isButtonDisabled = false);
                  }
                }
              });
            }

            return AlertDialog(
              content: SizedBox(
                height: 150,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: _showSuccess
                        ? Column(
                      key: const ValueKey('success'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green, size: 72),
                        SizedBox(height: 8),
                        Text("Reverse Successful",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    )
                        : Column(
                      key: const ValueKey('count'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Reversing property in...",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text("$_countdown",
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // safety: ensure timer is off and button re-enabled if dialog closed early
      _countdownTimer?.cancel();
      if (mounted) setState(() => _isButtonDisabled = false);
    });
  }



  Widget _buildPropertyDetails() {
    if (propertyData == null) {
      return const Text("No property data available");
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Show property image only if present
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
            final key = entry.key ?? '';
            final value = entry.value?.toString().trim();

            if (value == null || value.isEmpty) return const SizedBox();

            final k = key.toLowerCase().replaceAll('_', ' ').replaceAll('-', ' ');

            // 🚫 Hide unwanted fields
            final hidePhone = (k.contains('caretaker') &&
                (k.contains('number') || k.contains('phone') || k.contains('mobile'))) ||
                (k.contains('owner') &&
                    (k.contains('number') || k.contains('phone') || k.contains('mobile'))) ||
                k.contains('contact number') ||
                k.contains('phone') ||
                k.contains('mobile');

            final hideTechnical = k.contains('image') ||
                k.contains('latitude') ||
                k.contains('longitude') ||
                k.contains('lat') ||
                k.contains('long');

            if (hidePhone || hideTechnical) return const SizedBox();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final subid = _subidController.text.trim();
                    if (subid.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("⚠️ Please enter SubID first")),
                      );
                      return;
                    }
                    _onSendData();
                  },
                  child: const Text("Check Data"),
                ),
                ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                    final subid = _subidController.text.trim();
                    if (subid.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("⚠️ Please enter SubID first")),
                      );
                      return;
                    }
                    _confirmReverseProperty();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonDisabled ? Colors.grey : Colors.blueAccent,
                  ),
                  child: Text(
                    _isButtonDisabled ? "Please wait..." : "Reverse Property",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
