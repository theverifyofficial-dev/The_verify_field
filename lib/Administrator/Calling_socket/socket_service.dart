// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class SocketService {
//   static late IO.Socket socket;
//
//   static void connect(String userId) {
//     socket = IO.io(
//       "http://YOUR_IP:3000",
//       IO.OptionBuilder().setTransports(['websocket']).build(),
//     );
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       print("Connected");
//       socket.emit("register", userId);
//     });
//   }
//
//   static void callUser(String adminId, String userId) {
//     socket.emit("callUser", {
//       "adminId": adminId,
//       "userId": userId,
//       "channel": "channel_123"
//     });
//   }
// }