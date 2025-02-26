import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/notification/notification_bloc.dart';
import 'package:sakay_app/bloc/notification/notification_event.dart';
import 'package:sakay_app/bloc/notification/notification_state.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/notificaton.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

// TODO: cache notifications list
class AdminNotification extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminNotification({super.key, required this.openDrawer});

  @override
  _AdminNotificationState createState() => _AdminNotificationState();
}

// TODO: add something bago makalipat nag page if may laman ang files, and controllers
class _AdminNotificationState extends State<AdminNotification>
    with InputValidationMixin {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  late NotificationBloc _notificationBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;

  final List<NotificationModel> notifications = [];

  final List<File> files = [];
  final ImagePicker _picker = ImagePicker();
  late UserModel _myUserModel;

  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _notificationBloc.add(GetAllNotificationsEvent(currentPage));
    _scrollController.addListener(_onScroll);
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

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      _notificationBloc.add(GetAllNotificationsEvent(currentPage));
    }
  }

  Future<void> _openCamera(Function setState) async {
    setState(() {
      _isLoading = true;
    });

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        files.add(File(image.path));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickMedia(Function setState) async {
    setState(() {
      _isLoading = true;
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
      _isLoading = false;
    });
  }

  Future<void> _pickFiles(Function setState) async {
    setState(() {
      _isLoading = true;
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
      _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationLoading) {
          // TODO: add lottie??
        } else if (state is SaveNotificationSuccess) {
          Navigator.pop(context);
          setState(() {
            notifications.insert(
              0,
              NotificationModel(
                headline: _headlineController.text.trim(),
                content: _contentController.text.trim(),
                posted_by: _myUserModel,
                files: convertFilesToFileModels(files),
              ),
            );
            _headlineController.clear();
            _contentController.clear();
            files.clear();
          });
        } else if (state is GetAllNotificationsSuccess) {
          setState(() {
            notifications.addAll(state.notifications);
          });
        } else if (state is SaveNotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GetAllNotificationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _showBottomSheet,
          backgroundColor: const Color(0xFF00A3FF),
          child: const Icon(
            Icons.add,
            color: Color(0xfffdfdfd),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.menu, color: Colors.black, size: 25),
                      onPressed: () {
                        widget.openDrawer();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Notification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: notifications.isEmpty
                      ? const Center(
                          child: Text("No notifications yet"),
                        )
                      : ListView.builder(
                          itemCount: notifications.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications,
                                      color: Color(0xFF00A3FF)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.headline,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          notification.content,
                                          style: const TextStyle(
                                              color: Color(0xFF888888)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.more_horiz,
                                      color: Colors.black),
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _headlineController,
                              label: 'Headline',
                              hint: 'Enter Headline',
                              contentPadding: const EdgeInsets.all(16),
                              validator: (value) =>
                                  validateHeadline(value ?? ''),
                            ),
                            _buildTextField(
                              controller: _contentController,
                              label: 'Content',
                              hint: 'Enter content',
                              maxLines: 20,
                              minLines: 8,
                              contentPadding: const EdgeInsets.all(16),
                              validator: (value) =>
                                  validateContent(value ?? ''),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        children: [
                          _buildFilePreview(setState),
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
                                    onPressed: isLoading
                                        ? null
                                        : () => _openCamera(setState),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.image_outlined,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () => _pickMedia(setState),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.upload_file_outlined,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () => _pickFiles(setState),
                                  ),
                                  if (_isLoading)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: FloatingActionButton.extended(
                                  onPressed: _submitNotification,
                                  backgroundColor: const Color(0xFF00A3FF),
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Post',
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
            );
          },
        );
      },
    );
  }

  Widget _buildFilePreview(Function setState) {
    return files.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                final bool isImage = _isImage(file.path);
                final bool isVideo = _isVideo(file.path);

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
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                file,
                                width: 50,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              isVideo ? Icons.movie : Icons.insert_drive_file,
                              size: 30,
                            ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          file.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() {
                            files.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
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

  void _submitNotification() {
    if (_formKey.currentState?.validate() ?? false) {
      _notificationBloc.add(
        SaveNotificationEvent(
          files,
          NotificationModel(
            headline: _headlineController.text.trim(),
            content: _contentController.text.trim(),
          ),
        ),
      );
    }
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
