// import 'package:flutter/material.dart';
//
// import 'Call_Screen.dart';
//
// class IncomingCallScreen extends StatelessWidget {
//   final String channel;
//
//   const IncomingCallScreen({required this.channel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             Text("Incoming Call 📞"),
//
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CallScreen(channel: channel),
//                   ),
//                 );
//               },
//               child: Text("Accept"),
//             ),
//
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Reject"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }