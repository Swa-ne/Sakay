import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/notification/notification_bloc.dart';
import 'package:sakay_app/bloc/notification/notification_event.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/notificaton.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final _apiUrl = "${dotenv.env['API_URL']}/realtime";

abstract class RealtimeSocketController {
  Future<void> passChatBloc(ChatBloc boc);
  Future<void> passNotificationBloc(NotificationBloc bloc);
  Future<void> connect();
  Future<void> connectAdmin();
  void sendMessage(
    String receiver_id,
    String message,
    String chat_id,
  );
  void sendNotification(NotificationModel notification);
  void disconnect();
}

class RealtimeSocketControllerImpl extends RealtimeSocketController {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  static final RealtimeSocketControllerImpl _singleton =
      RealtimeSocketControllerImpl._internal();
  late IO.Socket socket;
  late ChatBloc chatBloc;
  late NotificationBloc notificationBloc;

  factory RealtimeSocketControllerImpl() {
    return _singleton;
  }

  @override
  Future<void> passChatBloc(ChatBloc bloc) async {
    chatBloc = bloc;
  }

  @override
  Future<void> passNotificationBloc(NotificationBloc bloc) async {
    notificationBloc = bloc;
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
      chatBloc.add(OnReceiveMessageEvent(
        message['chat_id'],
        message['message'],
        message['sender_id'],
        UserModel.fromJson(message['user']),
      ));
    });

    socket.on('notification-receive', (data) {
      notificationBloc.add(OnReceiveNotificationEvent(NotificationModel(
        id: data["notif_id"],
        posted_by: data["posted_by"],
        headline: data["headline"],
        content: data["content"],
        files: (data['files'] as List)
            .map((json) => FileModel.fromJson(json))
            .toList(),
      )));
    });

    socket.onDisconnect((_) {
      print('Disconnected from realtime socket');
    });

    socket.onError((error) {
      print('Socket error: $error');
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
  void sendMessage(
    String receiver_id,
    String message,
    String chat_id,
  ) {
    socket.emit('send-msg', {
      'receiver_id': receiver_id,
      'msg': message,
      'chat_id': chat_id,
    });
  }

  @override
  void sendNotification(NotificationModel notification) {
    socket.emit('send-notification', {
      'headline': notification.headline,
      'content': notification.content,
      'posted_by': notification.posted_by,
      'notif_id': notification.id,
    });
  }

  @override
  void disconnect() {
    socket.disconnect();
  }
}
