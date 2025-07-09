import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakay_app/bloc/announcement/announcement_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_event.dart';
import 'package:sakay_app/bloc/announcement/announcement_state.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication/fetch-file?path=";

class EditAnnouncementDialog extends StatefulWidget {
  final AnnouncementsModel announcement;
  final Function(AnnouncementsModel) onSave;

  const EditAnnouncementDialog({
    super.key,
    required this.announcement,
    required this.onSave,
  });

  @override
  _EditAnnouncementDialogState createState() => _EditAnnouncementDialogState();
}

class _EditAnnouncementDialogState extends State<EditAnnouncementDialog>
    with InputValidationMixin {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  late AnnouncementBloc _announcementBloc;

  late TextEditingController _headlineController;
  late TextEditingController _contentController;
  late String _audience;
  List<FileModel> _filesModel = [];
  final List<File> files = [];
  int filesModelLength = 0;

  final List<String> _audienceOptions = ["DRIVER", "COMMUTER", "EVERYONE"];

  bool _isButtonLoading = false;

  late UserModel _myUserModel;

  final List<AnnouncementsModel> announcements = [];

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    _headlineController =
        TextEditingController(text: widget.announcement.headline);
    _contentController =
        TextEditingController(text: widget.announcement.content);
    _audience = widget.announcement.audience;
    _filesModel = widget.announcement.files ?? [];
    filesModelLength = _filesModel.length;
    _initializeMyUserModel();
  }

  Future<void> _initializeMyUserModel() async {
    _myUserModel = UserModel(
      id: await _tokenController.getUserID(),
      first_name: await _tokenController.getFirstName(),
      last_name: await _tokenController.getLastName(),
      email: await _tokenController.getEmail(),
      profile: await _tokenController.getProfile(),
    );
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<AnnouncementBloc, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementLoading) {
          // TODO: add lottie??
        } else if (state is EditAnnouncementSuccess) {
          widget.onSave(state.announcement);
          files.clear();
          _filesModel.clear();
          _headlineController.text = "";
          _contentController.text = "";
          Navigator.of(context).pop();
        } else if (state is EditAnnouncementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Column(
          children: [
            const Text(
              'Post Announcements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _headlineController,
                        label: 'Headline',
                        hint: 'Enter Headline',
                        contentPadding: const EdgeInsets.all(16),
                        validator: (value) => validateHeadline(value ?? ''),
                      ),
                      _buildTextField(
                        controller: _contentController,
                        label: 'Content',
                        hint: 'Enter content',
                        maxLines: 20,
                        minLines: 8,
                        contentPadding: const EdgeInsets.all(16),
                        validator: (value) => validateContent(value ?? ''),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: DropdownButtonFormField<String>(
                          value: _audience,
                          decoration: InputDecoration(
                            labelText: "Select Audience",
                            labelStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                          ),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black54),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                          alignment: Alignment.center,
                          items: _audienceOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option,
                                  style: const TextStyle(fontSize: 16)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _audience = newValue!;
                            });
                          },
                          validator: (value) => value == null
                              ? "Please select an audience"
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: [
                    if (files.isNotEmpty || _filesModel.isNotEmpty)
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length + filesModelLength,
                          itemBuilder: (context, index) {
                            final file = filesModelLength > index
                                ? _filesModel[index]
                                : files[index - filesModelLength];
                            final String filePath = filesModelLength > index
                                ? (file as FileModel).file_url
                                : (file as File).path;
                            final bool isVideo = _isVideo(filePath);
                            final bool isImage = _isImage(filePath);

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  isImage
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: filesModelLength > index
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "$_apiUrl\"$filePath\"",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Image.file(
                                                  File(filePath),
                                                  width: 50,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                        )
                                      : Icon(
                                          isVideo
                                              ? Icons.movie
                                              : Icons.insert_drive_file,
                                          size: 30,
                                        ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      filePath.split('/').last,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        if (filesModelLength > index) {
                                          _filesModel.removeAt(index);
                                          filesModelLength -= 1;
                                        } else {
                                          files.removeAt(
                                              index - filesModelLength);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.black,
                                size: 22,
                              ),
                              onPressed: _isButtonLoading
                                  ? null
                                  : () => _openCamera(setState),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.image_outlined,
                                color: Colors.black,
                                size: 22,
                              ),
                              onPressed: _isButtonLoading
                                  ? null
                                  : () => _pickMedia(setState),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.upload_file_outlined,
                                color: Colors.black,
                                size: 22,
                              ),
                              onPressed: _isButtonLoading
                                  ? null
                                  : () => _pickFiles(setState),
                            ),
                            if (_isButtonLoading)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final List<FileModel> latestFiles = [];
                                latestFiles
                                    .addAll(convertFilesToFileModels(files));
                                latestFiles.addAll(_filesModel);
                                final updatedAnnouncement =
                                    widget.announcement.copyWith(
                                  edited_by: _myUserModel,
                                  headline: _headlineController.text,
                                  content: _contentController.text,
                                  audience: _audience,
                                  files: latestFiles,
                                  updatedAt: DateTime.now().toIso8601String(),
                                );
                                final existing_file_ids = _filesModel
                                    .map((file) => file.id)
                                    .where((id) => id != null)
                                    .cast<String>()
                                    .toList();
                                _announcementBloc.add(EditAnnouncementEvent(
                                  files,
                                  existing_file_ids,
                                  updatedAnnouncement,
                                ));
                              }
                            },
                            backgroundColor: const Color(0xFF00A3FF),
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            elevation: 2,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera(Function setState) async {
    setState(() {
      _isButtonLoading = true;
    });

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        files.add(File(image.path));
        _isButtonLoading = false;
      });
    } else {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> _pickMedia(Function setState) async {
    setState(() {
      _isButtonLoading = true;
    });

    final List<XFile>? pickedMedia = await _picker.pickMultipleMedia();

    if (pickedMedia != null) {
      List<File> validFiles = [];
      List<String> invalidFiles = [];

      for (XFile media in pickedMedia) {
        File file = File(media.path);
        int fileSize = await file.length();

        if (fileSize <= 50 * 1024 * 1024) {
          validFiles.add(file);
        } else {
          invalidFiles.add(media.name);
        }
      }

      if (validFiles.isNotEmpty) {
        setState(() {
          files.addAll(validFiles);
        });
      }

      if (invalidFiles.isNotEmpty) {
        _showFileSizeError(invalidFiles);
      }
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  Future<void> _pickFiles(Function setState) async {
    setState(() {
      _isButtonLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'txt',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'zip',
        'rar',
      ],
    );

    if (result != null) {
      List<File> validFiles = [];
      List<String> invalidFiles = [];

      for (var path in result.paths.whereType<String>()) {
        File file = File(path);
        int fileSize = await file.length();

        if (fileSize <= 50 * 1024 * 1024) {
          validFiles.add(file);
        } else {
          invalidFiles.add(file.path.split('/').last);
        }
      }

      if (validFiles.isNotEmpty) {
        setState(() {
          files.addAll(validFiles);
        });
      }

      if (invalidFiles.isNotEmpty) {
        _showFileSizeError(invalidFiles);
      }
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  void _showFileSizeError(List<String> fileNames) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Files Too Large"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "The following files exceed the 50MB limit and were not added:"),
            const SizedBox(height: 8),
            ...fileNames.map((name) =>
                Text("- $name", style: const TextStyle(fontSize: 14))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  List<FileModel> convertFilesToFileModels(List<File> files) {
    return files.map((file) {
      return FileModel(
        file_name: file.uri.pathSegments.last,
        file_type: file.path.split('.').last,
        file_category: 'default',
        file_url: file.path,
      );
    }).toList();
  }

  bool _isImage(String path) {
    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
    ].any((ext) => path.toLowerCase().endsWith(ext));
  }

  bool _isVideo(String path) {
    return ['.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv', '.webm']
        .any((ext) => path.toLowerCase().endsWith(ext));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int minLines = 1,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(vertical: 16.0),
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
            height: 1.3,
          ),
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          contentPadding: contentPadding,
        ),
        validator: validator,
        keyboardType: label == 'Price'
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
      ),
    );
  }
}
