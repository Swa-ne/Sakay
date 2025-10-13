import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_event.dart';
import 'package:sakay_app/bloc/announcement/announcement_state.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/common/announcement_main.dart';

class AdminAnnouncement extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminAnnouncement({super.key, required this.openDrawer});

  @override
  _AdminAnnouncementState createState() => _AdminAnnouncementState();
}

class _AdminAnnouncementState extends State<AdminAnnouncement>
    with InputValidationMixin {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  late AnnouncementBloc _announcementBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isButtonLoading = false;
  final List<AnnouncementsModel> announcements = [];
  final List<File> files = [];
  final ImagePicker _picker = ImagePicker();
  late UserModel _myUserModel;
  String _selectedAudience = "EVERYONE";
  final List<String> _audienceOptions = ["DRIVER", "COMMUTER", "EVERYONE"];

  String cursor = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    _announcementBloc.add(GetAllAnnouncementsEvent(cursor));
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

  void _updateAnnouncementsList(AnnouncementsModel announcement) {
    setState(() {
      final index =
          announcements.indexWhere((inbox) => inbox.id == announcement.id);
      announcements[index] = announcement;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
      });
      _announcementBloc.add(GetAllAnnouncementsEvent(cursor));
    }
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

  Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850]!
        : Colors.grey[200]!;
  }

  Color getTextColor(BuildContext context, {Color lightColor = Colors.black}) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : lightColor;
  }

  Color getInputFillColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnnouncementBloc, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementLoading) {
        } else if (state is SaveAnnouncementSuccess) {
          setState(() {
            announcements.insert(
              0,
              AnnouncementsModel(
                headline: _headlineController.text.trim(),
                content: _contentController.text.trim(),
                audience: _selectedAudience,
                posted_by: _myUserModel,
                files: convertFilesToFileModels(files),
                createdAt: DateTime.now().toIso8601String(),
              ),
            );
            _headlineController.clear();
            _contentController.clear();
            files.clear();
          });
          Navigator.pop(context);
        } else if (state is OnReceiveAnnouncementSuccess) {
          setState(() {
            announcements.insert(0, state.announcement);
          });
        } else if (state is GetAllAnnouncementsSuccess) {
          setState(() {
            announcements.addAll(state.announcements);
            cursor = state.cursor;
          });
        } else if (state is SaveAnnouncementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GetAllAnnouncementsError) {
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
                      icon: Icon(
                        Icons.menu,
                        color: getTextColor(context),
                        size: 25,
                      ),
                      onPressed: () {
                        widget.openDrawer();
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: getTextColor(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: announcements.isEmpty
                      ? Center(
                          child: Text(
                            "No announcements yet",
                            style: TextStyle(color: getTextColor(context)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: announcements.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final announcement = announcements[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AnnouncementDetailScreen(
                                      announcement: announcement,
                                      updateAnnouncementsList:
                                          _updateAnnouncementsList,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: getCardColor(context),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.campaign,
                                        color: Color(0xFF00A3FF)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            announcement.headline,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: getTextColor(context),
                                            ),
                                          ),
                                          Text(
                                            announcement.content,
                                            style: TextStyle(
                                                color: getTextColor(context,
                                                    lightColor:
                                                        Color(0xFF888888))),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.more_horiz,
                                        color: getTextColor(context)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
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
      backgroundColor: getCardColor(context),
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
              decoration: BoxDecoration(
                color: getCardColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Text(
                    'Post Announcements',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: getTextColor(context)),
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
                              validator: (value) =>
                                  validateHeadline(value ?? ''),
                              fillColor: getInputFillColor(context),
                              textColor: getTextColor(context),
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
                              fillColor: getInputFillColor(context),
                              textColor: getTextColor(context),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: DropdownButtonFormField<String>(
                                value: _selectedAudience,
                                decoration: InputDecoration(
                                  labelText: "Select Audience",
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: getTextColor(context)),
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
                                  filled: true,
                                  fillColor: getInputFillColor(context),
                                ),
                                dropdownColor: getCardColor(context),
                                icon: Icon(Icons.arrow_drop_down,
                                    color: getTextColor(context)),
                                style: TextStyle(
                                    fontSize: 16, color: getTextColor(context)),
                                alignment: Alignment.center,
                                items: _audienceOptions.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: getTextColor(context))),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAudience = newValue!;
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
                          _buildFilePreview(setState),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.photo_camera_outlined,
                                      color: getTextColor(context),
                                      size: 22,
                                    ),
                                    onPressed: _isButtonLoading
                                        ? null
                                        : () => _openCamera(setState),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.image_outlined,
                                      color: getTextColor(context),
                                      size: 22,
                                    ),
                                    onPressed: _isButtonLoading
                                        ? null
                                        : () => _pickMedia(setState),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.upload_file_outlined,
                                      color: getTextColor(context),
                                      size: 22,
                                    ),
                                    onPressed: _isButtonLoading
                                        ? null
                                        : () => _pickFiles(setState),
                                  ),
                                  if (_isButtonLoading)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: getTextColor(context)),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    _submitAnnouncement();
                                  },
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
                    color: getCardColor(context),
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
                              color: getTextColor(context),
                            ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          file.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12, color: getTextColor(context)),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close,
                            size: 20, color: getTextColor(context)),
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

  void _submitAnnouncement() {
    if (_formKey.currentState?.validate() ?? false) {
      _announcementBloc.add(
        SaveAnnouncementEvent(
          files,
          AnnouncementsModel(
            headline: _headlineController.text.trim(),
            content: _contentController.text.trim(),
            audience: _selectedAudience,
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
    Color? fillColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        style: TextStyle(color: textColor ?? Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(
            color: textColor?.withOpacity(0.7) ?? Colors.grey,
            height: 1.3,
          ),
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: textColor?.withOpacity(0.6) ?? Colors.grey,
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
