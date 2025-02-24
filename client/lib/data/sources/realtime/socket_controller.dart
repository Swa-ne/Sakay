import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final _apiUrl = "${dotenv.env['API_URL']}/realtime";

abstract class RealtimeSocketController {
  Future<void> passBloc(ChatBloc bloc);
  Future<void> connect();
  void sendMessage(String receiver_id, String message, String chat_id);
  void disconnect();
  Future<void> connectAdmin();
}

class RealtimeSocketControllerImpl extends RealtimeSocketController {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  static final RealtimeSocketControllerImpl _singleton =
      RealtimeSocketControllerImpl._internal();
  late IO.Socket socket;
  late ChatBloc chatBloc;

  factory RealtimeSocketControllerImpl() {
    return _singleton;
  }

  @override
  Future<void> passBloc(ChatBloc bloc) async {
    chatBloc = bloc;
  }

  RealtimeSocketControllerImpl._internal();

  @override
  Future<void> connect() async {
    socket = IO.io(_apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'token': await _tokenController.getAccessToken(),
      }
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to realtime socket');
    });

    socket.on('msg-receive', (message) {
      print("rinfdsnfsnakf $message");
      chatBloc.add(OnReceiveMessageEvent(
        message['chat_id'],
        message['message'],
        message['sender_id'],
        UserModel.fromJson(message['user']),
      ));
    });

    socket.onDisconnect((_) {
      print('Disconnected from realtime socket');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  @override
  void sendMessage(String receiver_id, String message, String chat_id) {
    socket.emit('send-msg', {
      'receiver_id': receiver_id,
      'msg': message,
      'chat_id': chat_id,
    });
  }

  @override
  Future<void> connectAdmin() async {
    print("connected admins $chatBloc");
    socket.on('msg-receive-admin', (message) {
      print("runninagnas ${message}");
      chatBloc.add(OnReceiveMessageEvent(
        message['chat_id'],
        message['message'],
        message['sender_id'],
        UserModel.fromJson(message['user']),
      ));

      // chatBloc.add(openInboxByUserIDEvent());
      // TODO: add reupdate list of inbox
    });
  }

  @override
  void disconnect() {
    socket.disconnect();
  }
}
