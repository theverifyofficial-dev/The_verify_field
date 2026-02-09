import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SubmitVideoPage extends StatefulWidget {
  final int? propertyId;
  final String? userName;
  final String? sourceId;
  final bool fromNotification;
  final String? buildingId;
  const SubmitVideoPage({
    super.key,
    this.propertyId,
    this.userName,
    this.sourceId,
    this.fromNotification = false,
    this.buildingId,
  });

  @override
  State<SubmitVideoPage> createState() => _SubmitVideoPageState();
}

class _SubmitVideoPageState extends State<SubmitVideoPage> {
  final TextEditingController messageController = TextEditingController();

  final String apiUrl =
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/video_editor.php";

  bool loading = false;
  bool chatLoading = true;
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchChat();
  }

  Future<void> sendData({
    required String action,
    String? text,
  }) async {
    if (widget.propertyId == null) return;

    final body = <String, String>{
      "action": action,
      "id": widget.propertyId.toString(),
      "by_name": widget.userName ?? "",
    };

    if (text != null && text.isNotEmpty) {
      body["text"] = text;
    }

    try {
      await http.post(Uri.parse(apiUrl), body: body);

      messageController.clear();

      FocusScope.of(context).unfocus();

      setState(() {});

      fetchChat();
    } catch (e) {
      debugPrint("❌ SEND ERROR: $e");
    }
  }

  Future<void> fetchChat() async {
    try {
      final res = await http.post(Uri.parse(apiUrl), body: {
        "action": "get_chat",
        "id": widget.propertyId.toString(),
      });

      final decoded = jsonDecode(res.body);

      if (decoded is Map && decoded["messages"] is List) {
        messages = decoded["messages"];
      } else if (decoded is List) {
        messages = decoded;
      }
    } catch (e) {
      debugPrint("❌ GET CHAT ERROR: $e");
    }

    chatLoading = false;
    setState(() {});
  }

  Future<void> openTelegram() async {
    final Uri url = Uri.parse("https://t.me/Nakli_artist");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  Future<void> uploadVideo() async {
    final Uri url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/videos_link.html");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_left)),
        title: const Text("Video Communication"),
        backgroundColor: Colors.blueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: fetchChat,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Live Property Id: ${widget.propertyId}"),
                  Text("Source Id:${widget.sourceId}"),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: openTelegram,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.telegram, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Open Telegram",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: InkWell(
                          onTap: uploadVideo,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_circle_fill, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Upload Video",
                                  style: TextStyle(
                                    fontFamily: 'PoppinsMedium',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                          loading ? null : () => sendData(
                            action: "editor_request_video",
                          ),
                          child: const Text("Request Video"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                            if (messageController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Enter message first")),
                              );
                              return;
                            }
                            sendData(
                              action: "editor_message",
                              text: messageController.text.trim(),
                            );
                          },
                          child: const Text("Send"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            Expanded(
              child: chatLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                  ? const Center(child: Text("No chat found"))
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  final String actor =
                      msg["actor_name"] ?? "";
                  final String role = msg["role"] ?? "";
                  final String text =
                      msg["message_text"] ?? "";
                  final String actionType =
                      msg["action_type"] ?? "";

                  final bool isMe =
                      actor == widget.userName;
                  final bool isEditor = role == "Editor";
                  final Color bubbleColor = isMe
                      ? Colors.blue.shade600
                      : Colors.green.shade600;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft:
                          isMe ? const Radius.circular(16) : const Radius.circular(4),
                          bottomRight:
                          isMe ? const Radius.circular(4) : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "$actor • $role",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isMe ? Colors.white70 : Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PoppinsMedium",
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formatDate(msg["created_at"]?["date"] ?? ""),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: "Poppins",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String raw) {
    try {
      return DateFormat('dd MMM, hh:mm a')
          .format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}
