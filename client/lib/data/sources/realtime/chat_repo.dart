import 'package:sakay_app/data/models/inbox.dart';

abstract class ChatRepo {
  Future<bool> saveMessage(String message, String chat_id, String receiver_id);
  Future<String> createPrivateInbox();
  Future<String> openCreatedInboxContentByChatID(String chat_id);
  Future<Map<String, dynamic>> getMessage(String chat_id, String? cursor);
  Future<InboxModel> openInbox();
  Future<Map<String, dynamic>> getAllInboxes(String? cursor);
  Future<bool> IsReadInboxes(String chat_id);
}
