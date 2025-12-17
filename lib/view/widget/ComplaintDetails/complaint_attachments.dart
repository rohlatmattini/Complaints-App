// lib/view/widget/complaint/complaint_details/attachments_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constant/appcolor.dart';
import '../../../../data/model/complaint/attachment_model.dart';

class AttachmentsWidget extends StatelessWidget {
  final List<Attachment> attachments;
  final bool isDark;

  const AttachmentsWidget({
    Key? key,
    required this.attachments,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        return _buildAttachmentItem(attachment);
      },
    );
  }

  Widget _buildAttachmentItem(Attachment attachment) {
    if (attachment.isImage) {
      return GestureDetector(
        onTap: () => _showImagePreview(attachment.url, attachment.originalName),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.getCardColor(isDark: isDark),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: attachment.url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.blue),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      attachment.originalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () =>_openFile(attachment.url),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 120,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.getCardColor(isDark: isDark),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                _getFileIcon(attachment),
                size: 40, // قللت الحجم
                color: _getFileIconColor(attachment),
              ),
              const SizedBox(height: 8), // قللت المسافة
              Flexible( // أضفت Flexible هنا
                child: Text(
                  attachment.originalName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColor.darkText : AppColor.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatFileSize(attachment.size),
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? AppColor.darkSubtitle : AppColor.subtitleColor,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  IconData _getFileIcon(Attachment attachment) {
    if (attachment.isPdf) {
      return Icons.picture_as_pdf;
    } else if (attachment.isDocument) {
      return Icons.description;
    } else {
      return Icons.insert_drive_file;
    }
  }

  Color _getFileIconColor(Attachment attachment) {
    if (attachment.isPdf) {
      return AppColor.red;
    } else if (attachment.isDocument) {
      return AppColor.blue;
    } else {
      return AppColor.blue;
    }
  }

  Future<void> _showImagePreview(String imageUrl, String title) async {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        width: Get.width * 0.9,
                        height: Get.height * 0.7,
                        placeholder: (context, url) => Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(color: AppColor.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'error'.tr,
        'cannot_open_file'.tr,
        backgroundColor: AppColor.red,
        colorText: AppColor.white,
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}