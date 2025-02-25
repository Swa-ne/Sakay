import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/notification/notification_event.dart';
import 'package:sakay_app/bloc/notification/notification_state.dart';
import 'package:sakay_app/data/sources/realtime/Notification_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final RealtimeSocketController _socketRealtimeRepo;
  final NotificationRepo _notificationRepo;
  bool _isSending = false;

  NotificationBloc(this._notificationRepo, this._socketRealtimeRepo)
      : super(NotificationLoading()) {
    on<ConnectNotificationRealtimeEvent>((event, emit) async {
      try {
        emit(ConnectingNotificationRealtimeSocket());
        await _socketRealtimeRepo.passNotificationBloc(this);
        emit(ConnectedNotificationRealtimeSocket());
      } catch (e) {
        emit(const ConnectionNotificationRealtimeError("Connection Error"));
      }
    });
    on<SaveNotificationEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(NotificationLoading());

        try {
          final isSent = await _notificationRepo.saveNotification(
            event.files,
            event.notification,
          );
          if (isSent) {
            emit(SaveNotificationSuccess());
          } else {
            emit(const SaveNotificationError("Failed to send notification."));
          }
        } catch (e) {
          emit(const SaveNotificationError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(NotificationReady());
        }
      },
    );

    on<GetAllNotificationsEvent>(
      (event, emit) async {
        try {
          emit(NotificationLoading());
          final notifications =
              await _notificationRepo.getAllNotifications(event.page);
          emit(GetAllNotificationsSuccess(notifications));
        } catch (e) {
          emit(const GetAllNotificationsError("Internet Connection Error"));
        }
      },
    );

    on<GetNotificationEvent>(
      (event, emit) async {
        try {
          emit(NotificationLoading());
          final notifications =
              await _notificationRepo.getNotification(event.notification_id);
          emit(GetNotificationSuccess(notifications));
        } catch (e) {
          emit(const GetNotificationError("Internet Connection Error"));
        }
      },
    );

    on<EditNotificationEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(NotificationLoading());

        try {
          final isSent = await _notificationRepo.editNotification(
            event.files,
            event.notification,
          );
          if (isSent) {
            emit(EditNotificationSuccess());
          } else {
            emit(const EditNotificationError("Failed to send notification."));
          }
        } catch (e) {
          emit(const EditNotificationError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(NotificationReady());
        }
      },
    );

    on<DeleteNotificationEvent>(
      (event, emit) async {
        try {
          emit(NotificationLoading());
          final isDeleted =
              await _notificationRepo.deleteNotification(event.notification_id);
          if (isDeleted) {
            emit(DeleteNotificationSuccess());
          } else {
            emit(const DeleteNotificationError("Failed to send notification."));
          }
        } catch (e) {
          emit(const DeleteNotificationError("Internet Connection Error"));
        }
      },
    );
    on<OnReceiveNotificationEvent>(
      (event, emit) async {
        try {
          emit(OnReceiveNotificationSuccess(event.notification));
        } catch (e) {
          emit(const OnReceiveNotificationError("Internet Connection Error"));
        }
      },
    );

    // on<GetInboxesEvent>(
    //   (event, emit) async {
    //     try {
    //       emit(NotificationLoading());
    //       final inboxes = await _notificationRepo.getAllInboxes(event.page);
    //       emit(GetInboxesSuccess(inboxes));
    //     } catch (e) {
    //       emit(const GetInboxesError("Internet Connection Error"));
    //     }
    //   },
    // );
  }
}
