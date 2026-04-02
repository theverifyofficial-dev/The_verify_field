import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> togglePinList({
  required int pId,
  required bool isWishlisted,
  required String type, // 👈 NEW
})
async {
  final prefs = await SharedPreferences.getInstance();
  final FName = prefs.getString('name') ?? "";

  print("🟡 Wishlist toggle tapped");
  print("➡️ Property ID: $pId");
  print("➡️ User ID: $FName");
  print("➡️ Current state: $isWishlisted");

  if (FName == null) {
    print("❌ User not logged in");
    return false;
  }

  final Uri url = Uri.parse(
    isWishlisted
        ? "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/wishlist_remove_for_tenant_demand.php"
        : "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/wishlist_add_for_tenant_demand.php",
  );

  final response = await http.post(url, body: {
    "user_names": FName,
    "demand_id": pId.toString(),
    "type": type, // 👈 ADD THIS

  });

  print("📡 API URL: $url");
  print("📡 Status: ${response.statusCode}");
  print("📡 Body: ${response.body}");

  return response.statusCode == 200;
}

class PinListButton extends StatefulWidget {
  final int pId;
  final bool initialState;
  final VoidCallback? onRemoved;
  final String type; // 👈 NEW


  const PinListButton({
    super.key,
    required this.pId,
    required this.initialState,
    required this.type, // 👈 REQUIRED
    this.onRemoved, // 👈 add this
  });
  @override
  State<PinListButton> createState() => _PinListButtonState();
}

class _PinListButtonState extends State<PinListButton> {
  late bool isWishlisted;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    isWishlisted = widget.initialState;
  }

  Future<void> _toggle() async {
    if (loading) return;

    setState(() => loading = true);

    final success = await togglePinList(
      pId: widget.pId,
      isWishlisted: isWishlisted,
      type: widget.type, // 👈 pass from widget
    );

    if (success) {
      final newState = !isWishlisted;

      setState(() => isWishlisted = newState);

      // 👇 if UNPIN → remove from list instantly
      if (!newState) {
        widget.onRemoved?.call();
      }

      print("❤️ UI updated → $newState");
    } else {
      print("❌ Pin toggle failed");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Icon(
        isWishlisted ? Icons.bookmark_outlined : Icons.bookmark_outline_sharp,
        color: isWishlisted ? Colors.green : Colors.green,
        size: 30,
      ),
    );
  }
}