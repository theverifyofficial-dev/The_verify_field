// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
//
// class CallScreen extends StatefulWidget {
//   final String channel;
//
//   const CallScreen({required this.channel});
//
//   @override
//   _CallScreenState createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> {
//   late RtcEngine _engine;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     _engine = createAgoraRtcEngine();
//
//     await _engine.initialize(
//       RtcEngineContext(appId: "YOUR_APP_ID"),
//     );
//
//     await _engine.enableAudio();
//
//     await _engine.joinChannel(
//       token: "",
//       channelId: widget.channel,
//       uid: 0,
//       options: ChannelMediaOptions(),
//     );
//   }
//
//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("On Call")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text("End Call"),
//         ),
//       ),
//     );
//   }
// }