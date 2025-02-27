import 'package:sakay_app/data/models/inbox.dart';
import 'package:sakay_app/data/models/message.dart';

abstract class ChatRepo {
  Future<bool> saveMessage(String message, String chat_id, String receiver_id);
  Future<String> createPrivateInbox();
  Future<String> openCreatedInboxContentByChatID(String chat_id);
  Future<List<MessageModel>> getMessage(String chat_id, int page);
  Future<InboxModel> openInbox();
  Future<List<InboxModel>> getAllInboxes(int page);
}
