import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/complaint/new_complaint_controller/complaint_attachment_controller.dart';
import '../../../core/constant/appcolor.dart';

class AttachmentsSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final attachmentController = Get.put(ComplaintAttachmentController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Attachments (Images / Documents)'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.blue,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Obx(() => Text(
              '(${attachmentController.attachedFiles.length}/${attachmentController.maxFiles})',
              style: TextStyle(
                color: attachmentController.attachedFiles.length >= attachmentController.maxFiles
                    ? AppColor.red
                    : AppColor.grey,
                fontSize: 12.sp,
              ),
            )),
          ],
        ),
        const SizedBox(height: 10),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.blue,
            minimumSize: Size(double.infinity, 45.h),
          ),
          onPressed: attachmentController.attachFile,
          icon: Icon(Icons.attach_file, color: AppColor.white),
          label: Text(
            'Attach File or Image'.tr,
            style: TextStyle(color: AppColor.white),
          ),
        ),

        SizedBox(height: 10.h),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColor.blue, size: 16),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Tip: Use "Files & Documents" for PDF, DOC files. Use "Gallery" for images.'.tr,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        Obx(() {
          if (attachmentController.attachedFiles.isEmpty) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.attach_file, color: AppColor.bluegrey, size: 40),
                    SizedBox(height: 8.h),
                    Text(
                      'No attachments yet'.tr,
                      style: TextStyle(
                        color: AppColor.bluegrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Tap above to attach files'.tr,
                      style: TextStyle(
                        color: AppColor.bluegrey,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: attachmentController.attachedFiles.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              final fileName = file.path.split('/').last;
              final fileSize = file.lengthSync();
              final fileType = _getFileType(fileName);

              return Dismissible(
                key: Key('attachment_${file.path}_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColor.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(Icons.delete, color: AppColor.white),
                ),
                confirmDismiss: (_) async {
                  return await _showDeleteConfirmation(fileName);
                },
                onDismissed: (_) => attachmentController.removeFile(index),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  child: ListTile(
                    leading: _getFileIcon(fileName),
                    title: Text(
                      fileName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${(fileSize / 1024).toStringAsFixed(1)} KB'),
                        Text(
                          'Type: $fileType',
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: AppColor.red, size: 20),
                      onPressed: () => attachmentController.removeFile(index),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),

        SizedBox(height: 8.h),
        Text(
          'Supported formats: JPG, PNG, PDF, DOC, DOCX, TXT (Max 10MB per file)'.tr,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _getFileIcon(String fileName) {
    final lowerCaseName = fileName.toLowerCase();

    if (lowerCaseName.endsWith('.jpg') ||
        lowerCaseName.endsWith('.jpeg') ||
        lowerCaseName.endsWith('.png')) {
      return Icon(Icons.image, color: AppColor.green);
    } else if (lowerCaseName.endsWith('.pdf')) {
      return Icon(Icons.picture_as_pdf, color: AppColor.red);
    } else if (lowerCaseName.endsWith('.doc') || lowerCaseName.endsWith('.docx')) {
      return Icon(Icons.description, color: AppColor.blue);
    } else if (lowerCaseName.endsWith('.txt')) {
      return Icon(Icons.text_fields, color: AppColor.orange);
    } else {
      return Icon(Icons.insert_drive_file, color: AppColor.grey);
    }
  }

  String _getFileType(String fileName) {
    final lowerCaseName = fileName.toLowerCase();

    if (lowerCaseName.endsWith('.pdf')) return 'PDF';
    if (lowerCaseName.endsWith('.doc')) return 'DOC';
    if (lowerCaseName.endsWith('.docx')) return 'DOCX';
    if (lowerCaseName.endsWith('.jpg') || lowerCaseName.endsWith('.jpeg')) return 'JPEG';
    if (lowerCaseName.endsWith('.png')) return 'PNG';
    if (lowerCaseName.endsWith('.txt')) return 'TXT';

    return 'File';
  }

  Future<bool> _showDeleteConfirmation(String fileName) async {
    final result = await Get.dialog(
      AlertDialog(
        title: Text('Delete Attachment'.tr),
        content: Text('Are you sure you want to delete $fileName?'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Delete'.tr, style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}