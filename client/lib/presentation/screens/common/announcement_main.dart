import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/common/mixins/convertion.dart';
import 'package:sakay_app/common/widgets/local_video_player.dart';
import 'package:sakay_app/common/widgets/video_player.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/data/models/file.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/admin/admin_edit_announcement.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication/fetch-file?path=";

class AnnouncementDetailScreen extends StatefulWidget {
  final AnnouncementsModel announcement;
  final Function(AnnouncementsModel)? updateAnnouncementsList;

  const AnnouncementDetailScreen(
      {super.key, required this.announcement, this.updateAnnouncementsList});

  @override
  _AnnouncementDetailScreenState createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen>
    with Convertion {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  late Future<String> _userTypeFuture;
  late AnnouncementsModel _currentAnnouncement;

  @override
  void initState() {
    super.initState();
    _userTypeFuture = _tokenController.getUserType();
    setState(() {
      _currentAnnouncement = widget.announcement;
    });
  }

  final PageController _pageController = PageController();

  final List<String> _videoExtensions = ['.mp4', '.avi', '.mov', '.mkv'];
  final List<String> _documentExtensions = ['.pdf', '.docx', '.doc', '.txt'];

  @override
  Widget build(BuildContext context) {
    final List<FileModel> mediaUrls = _currentAnnouncement.files
            ?.where((file) => !_isDocument(file.file_url))
            .map((file) => file)
            .toList() ??
        [];

    final List<FileModel> documentUrls = _currentAnnouncement.files
            ?.where((file) => _isDocument(file.file_url))
            .map((file) => file)
            .toList() ??
        [];

    final bool hasMultipleImages = mediaUrls.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Announcement",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          FutureBuilder<String>(
            future: _userTypeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasData && snapshot.data == "ADMIN") {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _editAnnouncement,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _deleteAnnouncement,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _userTypeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(_currentAnnouncement
                            .posted_by!.profile), //TODO: change this
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_currentAnnouncement.posted_by!.first_name} ${_currentAnnouncement.posted_by!.last_name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatToDate(_currentAnnouncement.created_at!),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentAnnouncement.headline,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentAnnouncement.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (mediaUrls.isNotEmpty)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 300,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: mediaUrls.length,
                              itemBuilder: (context, index) {
                                final url = mediaUrls[index];

                                if (_isVideo(url.file_url)) {
                                  return GestureDetector(
                                    onTap: () => _showMediaDialog(
                                        context, mediaUrls, index, true),
                                    child: url.file_category == "default"
                                        ? LocalVideoPlayerWidget(
                                            videoPath: url.file_url)
                                        : VideoPlayerWidget(
                                            videoPath:
                                                "$_apiUrl\"${url.file_url}\"",
                                          ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () => _showMediaDialog(
                                        context, mediaUrls, index, false),
                                    child: url.file_category == "default"
                                        ? Image.file(File(url.file_url))
                                        : CachedNetworkImage(
                                            imageUrl:
                                                "$_apiUrl\"${url.file_url}\"",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        if (hasMultipleImages) ...[
                          const SizedBox(height: 12),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: mediaUrls.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              activeDotColor: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  if (documentUrls.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "Attached Files",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...documentUrls.map((url) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.insert_drive_file,
                                color: Colors.blue),
                            title: Text(
                              url.file_url.split('/').last,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () =>
                                _openFile(url.file_url, url.file_category),
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  bool _isVideo(String url) {
    return _videoExtensions.any((ext) => url.endsWith(ext));
  }

  bool _isDocument(String url) {
    return _documentExtensions.any((ext) => url.endsWith(ext));
  }

  void _showMediaDialog(BuildContext context, List<FileModel> mediaUrls,
      int initialIndex, bool isVideo) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isVideo
                ? mediaUrls[initialIndex].file_category == "default"
                    ? LocalVideoPlayerWidget(
                        videoPath: mediaUrls[initialIndex].file_url,
                      )
                    : VideoPlayerWidget(
                        videoPath:
                            "$_apiUrl\"${mediaUrls[initialIndex].file_url}\"",
                      )
                : PhotoViewGallery.builder(
                    itemCount: mediaUrls.length,
                    builder: (context, index) {
                      return mediaUrls[initialIndex].file_category == "default"
                          ? PhotoViewGalleryPageOptions(
                              imageProvider: FileImage(
                                  File(mediaUrls[initialIndex].file_url)),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                            )
                          : PhotoViewGalleryPageOptions(
                              imageProvider: CachedNetworkImageProvider(
                                "$_apiUrl\"${mediaUrls[index].file_url}\"",
                              ),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                            );
                    },
                    scrollPhysics: const BouncingScrollPhysics(),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    pageController: PageController(initialPage: initialIndex),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _openFile(String url, String category) async {
    final fullUrl = category == "default" ? url : "$_apiUrl\"$url\"";
    if (await canLaunch(fullUrl)) {
      await launch(fullUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open the file"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editAnnouncement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return EditAnnouncementDialog(
          announcement: _currentAnnouncement,
          onSave: (updatedAnnouncement) {
            setState(() {
              final newAnnouncement = _currentAnnouncement.copyWith(
                edited_by: updatedAnnouncement.edited_by,
                headline: updatedAnnouncement.headline,
                content: updatedAnnouncement.content,
                audience: updatedAnnouncement.audience,
                updated_at: updatedAnnouncement.updated_at,
                files: updatedAnnouncement.files,
              );
              _currentAnnouncement = newAnnouncement;
              widget.updateAnnouncementsList!(newAnnouncement);
            });
          },
        );
      },
    );
  }

  void _deleteAnnouncement() {
    // TODO: Implement your delete logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Delete functionality not implemented yet"),
      ),
    );
  }
}
