import 'package:equatable/equatable.dart';

class FileModel extends Equatable {
  final String? id;
  final String file_name;
  final String file_type;
  final String file_category;
  final String file_url;

  const FileModel({
    this.id,
    required this.file_name,
    required this.file_type,
    required this.file_category,
    required this.file_url,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['_id'],
      file_name: json['file_name'],
      file_type: json['file_type'],
      file_category: json['file_category'],
      file_url: json['file_url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': file_name,
      'file_type': file_type,
      'file_category': file_category,
      'file_url': file_url,
    };
  }

  @override
  List<Object> get props => [file_name, file_type, file_category, file_url];
}
