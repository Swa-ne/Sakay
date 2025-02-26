import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/user.dart';

class NotificationModel extends Equatable {
  final String? id;
  final UserModel? posted_by;
  final UserModel? edited_by;
  final String headline;
  final String content;
  final List<FileModel>? files;

  const NotificationModel({
    this.id,
    this.posted_by,
    this.edited_by,
    required this.headline,
    required this.content,
    this.files,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      posted_by: json['posted_by'] != null
          ? UserModel.fromJson(json['posted_by'])
          : null,
      edited_by: json['edited_by'] != null
          ? UserModel.fromJson(json['edited_by'])
          : null,
      headline: json['headline'],
      content: json['content'],
      files: (json['files'] as List)
          .map((json) => FileModel.fromJson(json))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posted_by': posted_by,
      'edited_by': edited_by,
      'headline': headline,
      'content': content,
      'files': files,
    };
  }

  NotificationModel copyWith({
    String? id,
    UserModel? posted_by,
    UserModel? edited_by,
    String? headline,
    String? content,
    List<FileModel>? files,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      posted_by: posted_by ?? this.posted_by,
      edited_by: edited_by ?? this.edited_by,
      headline: headline ?? this.headline,
      content: content ?? this.content,
      files: files ?? this.files,
    );
  }

  @override
  List<Object> get props => [headline, content];
}
