import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/sources/realtime/chat_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final RealtimeSocketController _socketRealtimeRepo;
  final ChatRepo _chatRepo;
  bool _isSending = false;

  ChatBloc(this._chatRepo, this._socketRealtimeRepo) : super(ChatLoading()) {
    on<ConnectRealtimeEvent>((event, emit) async {
      try {
        emit(ConnectingRealtimeSocket());
        await _socketRealtimeRepo.passChatBloc(this);
        await _socketRealtimeRepo.connect();
        emit(ConnectedRealtimeSocket());
      } catch (e) {
        emit(const ConnectionRealtimeError("Connection Error"));
      }
    });

    on<ConnectAdminEvent>((event, emit) async {
      try {
        emit(ConnectingRealtimeSocket());
        await _socketRealtimeRepo.connectAdmin();
        emit(ConnectedRealtimeSocket());
      } catch (e) {
        emit(const ConnectionRealtimeError("Connection Error"));
      }
    });
    on<CreateInboxEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final inboxId = await _chatRepo.createPrivateInbox();
          // final inbox =
          //     await _chatRepo.openCreatedInboxContentByChatID(inboxId);
          emit(CreateInboxSuccess(inboxId));
        } catch (e) {
          emit(const CreateInboxError("Internet Connection Error"));
        }
      },
    );

    on<OpenInboxEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final inbox = await _chatRepo.openInbox();
          emit(OpenInboxSuccess(inbox));
        } catch (e) {
          emit(const OpenInboxError("Internet Connection Error"));
        }
      },
    );

    on<SaveMessageEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(MessageSending());

        try {
          final isSent = await _chatRepo.saveMessage(
            event.message,
            event.chat_id,
            event.receiver_id,
          );
          if (isSent) {
            emit(const SaveMessageSuccess());
          } else {
            emit(const SaveMessageError("Failed to send message."));
          }
        } catch (e) {
          emit(const SaveMessageError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(ChatReady());
        }
      },
    );

    on<GetMessageEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final messages =
              await _chatRepo.getMessage(event.chat_id, event.page);
          emit(GetMessageSuccess(messages));
        } catch (e) {
          emit(const GetMessageError("Internet Connection Error"));
        }
      },
    );

    on<OnReceiveMessageEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final message = MessageModel(
            message: event.msg,
            sender: event.sender_id,
            chat_id: event.chat_id,
            is_read: false,
            created_at: DateTime.now().toString(),
            updated_at: DateTime.now().toString(),
          );
          emit(OnReceiveMessageSuccess(message, event.user));
        } catch (e) {
          emit(const OnReceiveMessageError("Internet Connection Error"));
        }
      },
    );

    on<GetInboxesEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final inboxes = await _chatRepo.getAllInboxes(event.page);
          emit(GetInboxesSuccess(inboxes));
        } catch (e) {
          emit(const GetInboxesError("Internet Connection Error"));
        }
      },
    );

    on<IsReadInboxesEvent>(
      (event, emit) async {
        try {
          emit(ChatLoading());
          final isRead = await _chatRepo.IsReadInboxes(event.chat_id);
          if (isRead) {
            emit(IsReadInboxSuccess(isRead));
          } else {
            emit(const IsReadInboxError("Internet Connection Error"));
          }
        } catch (e) {
          emit(const IsReadInboxError("Internet Connection Error"));
        }
      },
    );
  }
}
