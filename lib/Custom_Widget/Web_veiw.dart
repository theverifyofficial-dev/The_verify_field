import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EStampWebView extends StatefulWidget {
  final Map<String, dynamic> stampData;
  const EStampWebView({super.key, required this.stampData});

  @override
  State<EStampWebView> createState() => _EStampWebViewState();
}

class _EStampWebViewState extends State<EStampWebView> {
  late final WebViewController _controller;
  bool isFilling = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            await Future.delayed(const Duration(seconds: 3));
            _waitAndFill();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.shcilestamp.com/#'));
  }

  // 🔐 SAFE STRING (prevents JS break)
  String safe(String? v) {
    return (v ?? '')
        .replaceAll("\\", "\\\\")
        .replaceAll("'", "\\'")
        .replaceAll("\n", " ");
  }

  // ⏳ WAIT UNTIL FORM LOADS
  Future<void> _waitAndFill() async {
    for (int i = 0; i < 12; i++) {
      try {
        final result =
        await _controller.runJavaScriptReturningResult('''
          document.querySelector('input') != null
        ''');

        if (result.toString() == 'true') {
          await _autoFillForm();
          return;
        }
      } catch (_) {}

      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() => isFilling = false);
    debugPrint("❌ Form not detected");
  }

  // ⚡ MAIN AUTO FILL
  Future<void> _autoFillForm() async {
    final d = widget.stampData;

    final tenant = safe(d['tenant_name']);
    final owner = safe(d['owner_name']);
    final address = safe(d['rented_address']);
    final rent = safe(d['monthly_rent']);

    await _controller.runJavaScript('''
      (function() {

        function setField(selectors, value) {
          for (var i = 0; i < selectors.length; i++) {
            var el = document.querySelector(selectors[i]);
            if (el) {
              el.focus();
              el.value = value;

              el.dispatchEvent(new Event('input', { bubbles: true }));
              el.dispatchEvent(new Event('change', { bubbles: true }));
              el.dispatchEvent(new Event('blur', { bubbles: true }));

              console.log("Filled:", selectors[i]);
              return true;
            }
          }
          return false;
        }

        // 🔥 Try multiple selectors (real-world safe)
        setField(['#applicantName','input[name="applicantName"]'], '$tenant');

        setField(['#partyName1','input[name="party1"]'], '$tenant');

        setField(['#partyName2','input[name="party2"]'], '$owner');

        setField(['#address','textarea[name="address"]'], '$address');

        setField(['#considerationAmt','input[name="amount"]'], '$rent');

        console.log("✅ Autofill executed");

      })();
    ''');

    setState(() => isFilling = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Fields auto-filled. Please verify."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // 🔁 MANUAL REFILL BUTTON
  void _refill() {
    setState(() => isFilling = true);
    _waitAndFill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Stamp Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: _refill,
          ),
        ],
      ),

      body: Column(
        children: [
          // ⚠️ Warning Banner
          Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(10),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verify all pre-filled data before submitting.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // 🔄 Loading Indicator
          if (isFilling)
            const LinearProgressIndicator(minHeight: 3),

          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}