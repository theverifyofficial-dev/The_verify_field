import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class GeminiChatScreen extends StatefulWidget {
//   const GeminiChatScreen({super.key});
//
//   @override
//   State<GeminiChatScreen> createState() => _GeminiChatScreenState();
// }
//
// class _GeminiChatScreenState extends State<GeminiChatScreen> {
//   // Controller for the text input
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   // Initialize the model
//   late final GenerativeModel _model;
//   late final ChatSession _chatSession;
//
//   // List to store the chat history for the UI
//   final List<Map<String, String>> _messages = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // 1. Setup the model
//     _model = GenerativeModel(
//       model: 'gemini-2.5-flash',
//       apiKey: 'AIzaSyDri7Gn2OPFa70G3fq2UFCeQj4u8xDLs94', // My key
//     );
//     // 2. Start a chat session (this enables multi-turn conversation)
//     _chatSession = _model.startChat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   Future<void> _sendMessage() async {
//     final userMessage = _controller.text.trim();
//     if (userMessage.isEmpty) return;
//
//     setState(() {
//       _messages.add({"role": "user", "text": userMessage});
//       _isLoading = true;
//       _controller.clear();
//     });
//     _scrollToBottom();
//
//     try {
//       // Send the message through the chat session
//       final response = await _chatSession.sendMessage(Content.text(userMessage));
//
//       print("coming message: $response");
//
//       setState(() {
//         _messages.add({"role": "ai", "text": response.text ?? "No response"});
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add({"role": "ai", "text": "Error: $e"});
//
//         print("coming message: $e");
//
//         _isLoading = false;
//       });
//     }
//     _scrollToBottom();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Gemini AI Assistant", style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         elevation: 2,
//       ),
//       body: Column(
//         children: [
//           // Chat History Area
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(15),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 return _buildChatBubble(msg["text"]!, msg["role"] == "user");
//               },
//             ),
//           ),
//
//           // Loading Indicator
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: LinearProgressIndicator(backgroundColor: Colors.transparent),
//             ),
//
//           // Input Area
//           _buildInputArea(),
//         ],
//       ),
//     );
//   }
//
//   // --- UI Components ---
//
//   Widget _buildChatBubble(String text, bool isUser) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blueAccent : Colors.grey[200],
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(20),
//             topRight: const Radius.circular(20),
//             bottomLeft: Radius.circular(isUser ? 20 : 0),
//             bottomRight: Radius.circular(isUser ? 0 : 20),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isUser ? Colors.white : Colors.black87,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: "Type a message...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//               ),
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//           const SizedBox(width: 8),
//           CircleAvatar(
//             backgroundColor: Colors.blueAccent,
//             child: IconButton(
//               icon: const Icon(Icons.send, color: Colors.white),
//               onPressed: _isLoading ? null : _sendMessage,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class GeminiChatScreen extends StatefulWidget {
//   const GeminiChatScreen({super.key});
//
//   @override
//   State<GeminiChatScreen> createState() => _GeminiChatScreenState();
// }
//
// class _GeminiChatScreenState extends State<GeminiChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   final List<Map<String, String>> _messages = [];
//   bool _isLoading = false;
//
//   // 🔐 PUT YOUR REAL API KEY HERE (rotate old one!)
//   static const String _apiKey = "AIzaSyDri7Gn2OPFa70G3fq2UFCeQj4u8xDLs94";
//
//   // 🔥 Gemini REST call
//   Future<String> _sendToGemini(String message) async {
//     final uri = Uri.parse(
//       "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$_apiKey",
//     );
//
//     final response = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "contents": [
//           {
//             "role": "user",
//             "parts": [
//               {"text": message}
//             ]
//           }
//         ]
//       }),
//     );
//
//     final data = jsonDecode(response.body);
//
//     print(data);
//
//     if (response.statusCode != 200) {
//       throw Exception(data["error"]["message"] ?? "Unknown error");
//     }
//
//     return data["candidates"][0]["content"]["parts"][0]["text"];
//   }
//
//   Future<void> _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty || _isLoading) return;
//
//     setState(() {
//       _messages.add({"role": "user", "text": text});
//       _isLoading = true;
//       _controller.clear();
//     });
//     _scrollToBottom();
//
//     try {
//       final aiReply = await _sendToGemini(text);
//
//       setState(() {
//         _messages.add({"role": "ai", "text": aiReply});
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add({"role": "ai", "text": "Error: $e"});
//         _isLoading = false;
//       });
//     }
//
//     _scrollToBottom();
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Gemini AI Assistant",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(14),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 return _chatBubble(
//                   msg["text"]!,
//                   isUser: msg["role"] == "user",
//                 );
//               },
//             ),
//           ),
//
//           if (_isLoading)
//             const LinearProgressIndicator(minHeight: 2),
//
//           _inputArea(),
//         ],
//       ),
//     );
//   }
//
//   Widget _chatBubble(String text, {required bool isUser}) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.all(14),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blueAccent : Colors.grey.shade200,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: Radius.circular(isUser ? 16 : 0),
//             bottomRight: Radius.circular(isUser ? 0 : 16),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isUser ? Colors.white : Colors.black87,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _inputArea() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: const BoxDecoration(
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 4),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               textInputAction: TextInputAction.send,
//               onSubmitted: (_) => _sendMessage(),
//               decoration: InputDecoration(
//                 hintText: "Type a message…",
//                 filled: true,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 20),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           CircleAvatar(
//             backgroundColor: Colors.blueAccent,
//             child: IconButton(
//               icon: const Icon(Icons.send, color: Colors.white),
//               onPressed: _isLoading ? null : _sendMessage,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class GeminiChatBody extends StatefulWidget {
  final ScrollController externalScrollController;

  const GeminiChatBody({
    super.key,
    required this.externalScrollController,
  });

  @override
  State<GeminiChatBody> createState() => _GeminiChatBodyState();
}

class _GeminiChatBodyState extends State<GeminiChatBody> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // 🔐 PUT YOUR REAL API KEY HERE (rotate old one!)
  static const String _apiKey = "AIzaSyDri7Gn2OPFa70G3fq2UFCeQj4u8xDLs94";

  // 🔥 Gemini REST call
  Future<String> _sendToGemini(String message) async {
    final uri = Uri.parse(
      "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$_apiKey",
    );

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);

    print(data);

    if (response.statusCode != 200) {
      throw Exception(data["error"]["message"] ?? "Unknown error");
    }

    return data["candidates"][0]["content"]["parts"][0]["text"];
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
      _controller.clear();
    });

    try {
      final aiReply = await _sendToGemini(text);

      setState(() {
        _messages.add({"role": "ai", "text": aiReply});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({"role": "ai", "text": "AI is busy. Try again."});
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (bottomInset > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.externalScrollController.hasClients) {
          widget.externalScrollController.animateTo(
            widget.externalScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.externalScrollController,
            padding: const EdgeInsets.all(14),
            itemCount: _messages.length,
            itemBuilder: (_, index) {
              final msg = _messages[index];
              return _chatBubble(
                msg["text"]!,
                isUser: msg["role"] == "user",
              );
            },
          ),
        ),

        if (_isLoading)
          const LinearProgressIndicator(minHeight: 2),

        _inputArea(),
      ],
    );
  }


  Widget _chatBubble(String text, {required bool isUser}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blue
              : isDark
              ? const Color(0xFF1E1E1E)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser
                ? Colors.white
                : isDark
                ? Colors.white70
                : Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _inputArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        bottomInset > 0 ? bottomInset + 12 : 12,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: "Ask Gemini anything…",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isLoading
                    ? Colors.grey
                    : Colors.blue,
              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

}


