import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SubmitVideoPage extends StatefulWidget {
  final int propertyId;
  final String action;
  final String userName;
  final String userRole; // editor / fieldworker
  final String status;

  const SubmitVideoPage({
    super.key,
    required this.propertyId,
    required this.action,
    required this.userName,
    required this.userRole,
    required this.status,
  });

  @override
  State<SubmitVideoPage> createState() => _SubmitVideoPageState();
}

class _SubmitVideoPageState extends State<SubmitVideoPage> {
  final TextEditingController msgController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  Map<int, String> submittedStatus = {};
  Map<String, dynamic>? editorInfo;

  @override
  void initState() {
    super.initState();
    loadStatus();
    fetchEditorInfo();
  }

  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString("videoStatus_${widget.propertyId}");
    if (saved != null) {
      submittedStatus[widget.propertyId] = saved;
    }
    setState(() {});
  }

  Future<void> fetchEditorInfo() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/video_editor.php",
    );

    try {
      final res = await http.post(url, body: {
        "action": "get_status",
        "id": widget.propertyId.toString(),
      });

      final decoded = jsonDecode(res.body);
      print("📥 STATUS FETCHED: $decoded");

      if (decoded is List && decoded.isNotEmpty) {
        editorInfo = decoded.first;
      } else if (decoded is Map && decoded["data"] is Map) {
        editorInfo = decoded["data"];
      } else if (decoded is Map && decoded["data"] is List) {
        editorInfo = decoded["data"].first;
      }
    } catch (e) {
      print("❌ ERROR get_status: $e");
    }

    setState(() {});
  }

  Future<String?> submitVideo({
    required String action,
    String? text,
    String? videoLink,
  }) async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/video_editor.php");

    Map<String, String> body = {
      "action": action,
      "id": widget.propertyId.toString(),
      "by_name": widget.userName,
      "role": widget.userRole,
    };

    if (action == "upload_video_link") {
      body["video_link"] = videoLink ?? "";
    } else {
      body["text"] = text ?? "";
    }

    try {
      final res = await http.post(url, body: body);
      print("📤 SENT: $body");
      print("📩 RESPONSE: ${res.body}");

      final data = jsonDecode(res.body);

      if (data["ok"] == true) {
        return data["data"]["messages"][0]["status_after"];
      }
    } catch (e) {
      print("❌ SUBMIT ERROR: $e");
    }

    return null;
  }

  Future<void> openTelegram() async {
    final Uri url = Uri.parse("https://t.me/Nakli_artist");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    String rawStatus = widget.status.trim().toLowerCase();

    bool isEditor = widget.userRole.toLowerCase() == "editor";
    bool isFieldworker = widget.userRole.toLowerCase() == "fieldworker";

    /// FIX → API sometimes gives "video uploaded" OR "video_uploaded"
    bool isUploaded =
        rawStatus == "video uploaded" || rawStatus == "video_uploaded";

    bool showLinkBox = widget.action == "upload_video_link" && isEditor;

    /// FINAL LOGIC
    bool hideMessageBox = isFieldworker && isUploaded;
    bool hideSubmitButton = isFieldworker && isUploaded;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Video", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// STATUS BANNER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.status.isEmpty ? "Editor Request" : widget.status,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Text("Property ID: ${widget.propertyId}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),

            const SizedBox(height: 20),

            /// TELEGRAM BUTTON
            Center(
              child: InkWell(
                onTap: openTelegram,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.telegram, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Open Telegram",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// FINAL VIDEO LINK BOX (ONLY EDITOR)
            if (showLinkBox) ...[
              const Text("Final Video Link",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              TextField(
                controller: linkController,
                decoration: InputDecoration(
                  hintText: "Paste YouTube Link",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],

            /// MESSAGE BOX (HIDE IF FIELDWORKER + UPLOADED)
            if (!showLinkBox && !hideMessageBox) ...[
              const Text("Message",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              TextField(
                controller: msgController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write something...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),
            ],

            /// SUBMIT BUTTON (HIDE IF FIELDWORKER + UPLOADED)
            if (!hideSubmitButton)
              GestureDetector(
                onTap: () async {
                  if (showLinkBox) {
                    if (linkController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter YouTube Link")),
                      );
                      return;
                    }

                    String? status = await submitVideo(
                        action: "upload_video_link",
                        videoLink: linkController.text.trim());

                    if (status != null) Navigator.pop(context, true);
                  } else {
                    if (msgController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Enter Message")));
                      return;
                    }

                    String? status = await submitVideo(
                        action: widget.action,
                        text: msgController.text.trim());

                    if (status != null) Navigator.pop(context, true);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      showLinkBox ? "Submit Video Link" : "Submit",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// MESSAGE HISTORY
            if (editorInfo != null)
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.mail,color: Colors.blue,),
                        SizedBox(width: 6,),
                        const Text("Message History",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ...List.generate(
                      (editorInfo?["messages"] ?? []).length,
                          (i) {
                        var msg = editorInfo!["messages"][i];
                        bool isEditorMessage = msg["role"] == "editor";

                        return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            // 🔥 Auto Light/Dark Theme Background
                            color: isEditorMessage
                            ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue.withOpacity(0.15)
                                : Colors.blue.withOpacity(0.08))
                                : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.green.withOpacity(0.15)
                                : Colors.green.withOpacity(0.08)),

                            // 🔥 Auto Border According to theme
                            border: Border.all(
                            color: isEditorMessage
                            ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue.shade300
                                : Colors.blue.shade600)
                                : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.green.shade300
                                : Colors.green.shade600),
                            width: 1.2,
                            ),
                            ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${msg["actor_name"]} (${msg["role"]})",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isEditorMessage ? Colors.blue : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  msg["message_text"] ?? "",
                                  style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(
                                "Time: ${formatDateTime(msg["created_at"]["date"] ?? "")}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  String formatDateTime(String raw) {
    try {
      DateTime date = DateTime.parse(raw);
      return DateFormat('dd-MM-yyyy  hh:mm a').format(date);
    } catch (e) {
      return raw; // fallback if parsing fails
    }
  }

}
