import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/notification/notification_bloc.dart';
import 'package:sakay_app/bloc/notification/notification_event.dart';
import 'package:sakay_app/bloc/report/report_bloc.dart';
import 'package:sakay_app/bloc/report/report_event.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/notificaton.dart';
import 'package:sakay_app/data/models/report.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final _apiUrl = "${dotenv.env['API_URL']}/realtime";

abstract class RealtimeSocketController {
  Future<void> passChatBloc(ChatBloc boc);
  Future<void> passNotificationBloc(NotificationBloc bloc);
  Future<void> passReportBloc(ReportBloc bloc);
  Future<void> connect();
  Future<void> connectAdmin();
  void sendMessage(
    String receiver_id,
    String message,
    String chat_id,
  );
  void sendNotification(NotificationModel notification);
  void sendReport(ReportModel report);
  void toggleReport(String report_id);
  void disconnect();
}

class RealtimeSocketControllerImpl extends RealtimeSocketController {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  static final RealtimeSocketControllerImpl _singleton =
      RealtimeSocketControllerImpl._internal();
  late IO.Socket socket;
  late ChatBloc chatBloc;
  late NotificationBloc notificationBloc;
  late ReportBloc reportBloc;

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

  @override
  Future<void> passReportBloc(ReportBloc bloc) async {
    reportBloc = bloc;
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
        audience: data["audience"],
        files: (data['files'] as List)
            .map((json) => FileModel.fromJson(json))
            .toList(),
      )));
    });

    socket.on('toggle-report-receive', (data) {
      reportBloc.add(
          OnReceiveToggleReportEvent(ReportModel.fromJson(data["report"])));
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
    socket.on('msg-receive-admin', (message) {
      chatBloc.add(OnReceiveMessageEvent(
        message['chat_id'],
        message['message'],
        message['sender_id'],
        UserModel.fromJson(message['user']),
      ));
    });
    socket.on('report-receive-admin', (message) {
      reportBloc.add(
          OnReceiveAdminReportEvent(ReportModel.fromJson(message["report"])));
    });
    socket.on('toggle-report-receive-admin', (message) {
      reportBloc.add(OnReceiveAdminToggleReportEvent(
          ReportModel.fromJson(message["report"])));
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
      'audience': notification.audience,
      'notif_id': notification.id,
    });
  }

  @override
  void sendReport(ReportModel report) {
    socket.emit('send-report', {
      'report': report.toJson(),
    });
  }

  @override
  void toggleReport(String report_id) {
    socket.emit('send-report', {
      'report_id': report_id,
    });
  }

  @override
  void disconnect() {
    socket.disconnect();
  }
}
