import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/user.dart';

class AnnouncementsModel extends Equatable {
  final String? id;
  final UserModel? posted_by;
  final UserModel? edited_by;
  final String headline;
  final String content;
  final String audience;
  final List<FileModel>? files;
  final String? created_at;
  final String? updated_at;

  const AnnouncementsModel({
    this.id,
    this.posted_by,
    this.edited_by,
    required this.headline,
    required this.content,
    required this.audience,
    this.files,
    this.created_at,
    this.updated_at,
  });

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
      id: json['_id'],
      posted_by: json['posted_by'] != null
          ? UserModel.fromJson(json['posted_by'])
          : null,
      edited_by: json['edited_by'] != null
          ? UserModel.fromJson(json['edited_by'])
          : null,
      headline: json['headline'],
      content: json['content'],
      audience: json['audience'] ?? "",
      files: (json['files'] as List)
          .map((json) => FileModel.fromJson(json))
          .toList(),
      created_at: json['createdAt'] ?? "",
      updated_at: json['updatedAt'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posted_by': posted_by,
      'edited_by': edited_by,
      'headline': headline,
      'content': content,
      'audience': audience,
      'files': files,
      'createdAt': created_at,
      'updatedAt': updated_at,
    };
  }

  AnnouncementsModel copyWith({
    String? id,
    UserModel? posted_by,
    UserModel? edited_by,
    String? headline,
    String? content,
    String? audience,
    List<FileModel>? files,
    String? created_at,
    String? updated_at,
  }) {
    return AnnouncementsModel(
      id: id ?? this.id,
      posted_by: posted_by ?? this.posted_by,
      edited_by: edited_by ?? this.edited_by,
      headline: headline ?? this.headline,
      content: content ?? this.content,
      audience: audience ?? this.audience,
      files: files ?? this.files,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  List<Object> get props => [headline, content, audience];
}
