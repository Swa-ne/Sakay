import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_event.dart';
import 'package:sakay_app/bloc/announcement/announcement_state.dart';
import 'package:sakay_app/data/sources/realtime/announcement_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final RealtimeSocketController _socketRealtimeRepo;
  final AnnouncementRepo _announcementRepo;
  bool _isSending = false;

  AnnouncementBloc(this._announcementRepo, this._socketRealtimeRepo)
      : super(AnnouncementLoading()) {
    on<ConnectAnnouncementRealtimeEvent>((event, emit) async {
      try {
        emit(ConnectingAnnouncementRealtimeSocket());
        await _socketRealtimeRepo.passAnnouncementBloc(this);
        emit(ConnectedAnnouncementRealtimeSocket());
      } catch (e) {
        emit(const ConnectionAnnouncementRealtimeError("Connection Error"));
      }
    });
    on<SaveAnnouncementEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(AnnouncementLoading());

        try {
          final isSent = await _announcementRepo.saveAnnouncement(
            event.files,
            event.announcement,
          );
          if (isSent) {
            emit(SaveAnnouncementSuccess());
          } else {
            emit(const SaveAnnouncementError("Failed to send announcement."));
          }
        } catch (e) {
          emit(const SaveAnnouncementError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(AnnouncementReady());
        }
      },
    );

    on<GetAllAnnouncementsEvent>(
      (event, emit) async {
        try {
          emit(AnnouncementLoading());
          final announcements =
              await _announcementRepo.getAllAnnouncements(event.cursor);
          emit(GetAllAnnouncementsSuccess(
              announcements["announcements"], announcements["nextCursor"]));
        } catch (e) {
          emit(const GetAllAnnouncementsError("Internet Connection Error"));
        }
      },
    );

    on<GetAnnouncementEvent>(
      (event, emit) async {
        try {
          emit(AnnouncementLoading());
          final announcements =
              await _announcementRepo.getAnnouncement(event.announcement_id);
          emit(GetAnnouncementSuccess(announcements));
        } catch (e) {
          emit(const GetAnnouncementError("Internet Connection Error"));
        }
      },
    );

    on<EditAnnouncementEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(AnnouncementLoading());

        try {
          final isSent = await _announcementRepo.editAnnouncement(
            event.files,
            event.existing_file_ids,
            event.announcement,
          );
          if (isSent) {
            emit(EditAnnouncementSuccess(event.announcement));
          } else {
            emit(const EditAnnouncementError("Failed to send announcement."));
          }
        } catch (e) {
          emit(const EditAnnouncementError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(AnnouncementReady());
        }
      },
    );

    on<DeleteAnnouncementEvent>(
      (event, emit) async {
        try {
          emit(AnnouncementLoading());
          final isDeleted =
              await _announcementRepo.deleteAnnouncement(event.announcement_id);
          if (isDeleted) {
            emit(DeleteAnnouncementSuccess());
          } else {
            emit(const DeleteAnnouncementError("Failed to send announcement."));
          }
        } catch (e) {
          emit(const DeleteAnnouncementError("Internet Connection Error"));
        }
      },
    );
    on<OnReceiveAnnouncementEvent>(
      (event, emit) async {
        try {
          emit(AnnouncementLoading());
          emit(OnReceiveAnnouncementSuccess(event.announcement));
        } catch (e) {
          emit(const OnReceiveAnnouncementError("Internet Connection Error"));
        }
      },
    );
    on<OnReceiveUpdateAnnouncementEvent>(
      (event, emit) async {
        try {
          emit(AnnouncementLoading());
          emit(OnReceiveUpdateAnnouncementSuccess(event.announcement));
        } catch (e) {
          emit(const OnReceiveUpdateAnnouncementError(
              "Internet Connection Error"));
        }
      },
    );
  }
}
