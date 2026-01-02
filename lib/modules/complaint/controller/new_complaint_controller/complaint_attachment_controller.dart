import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/appcolor.dart';

enum FileSource { gallery, camera, documents, none }

class ComplaintAttachmentController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final int maxFiles = 15;

  var attachedFiles = <File>[].obs;
  var isLoading = false.obs;

  Future<void> attachFile() async {
    try {
      if (attachedFiles.length >= maxFiles) {
        _showLimitError();
        return;
      }

      final result = await Get.bottomSheet(_buildSourceSelector());

      switch (result) {
        case FileSource.gallery:
          await _handleGallery();
          break;
        case FileSource.camera:
          await _handleCamera();
          break;
        case FileSource.documents:
          await _handleDocuments();
          break;
        case FileSource.none:
          break;
      }
    } catch (e) {
      print('Error attaching file: $e');
      Get.snackbar('Error'.tr, 'Failed to attach file'.tr);
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < attachedFiles.length) {
      final removedFile = attachedFiles[index];
      attachedFiles.removeAt(index);
      Get.snackbar('Removed'.tr, 'File removed'.tr);
    }
  }

  void clearFiles() {
    attachedFiles.clear();
  }

  bool get canAddMoreFiles => attachedFiles.length < maxFiles;
  int get remainingFilesCount => maxFiles - attachedFiles.length;

  String getFileInfo(File file) {
    final fileName = file.path.split('/').last;
    final fileSize = file.lengthSync();
    final fileType = _getFileType(fileName);
    return '$fileName ($fileType) - ${(fileSize / 1024).toStringAsFixed(1)} KB';
  }

  // Private methods
  Widget _buildSourceSelector() {
    final isDark = Get.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'.tr),
              onTap: () => Get.back(result: FileSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'.tr),
              onTap: () => Get.back(result: FileSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Files & Documents'.tr),
              onTap: () => Get.back(result: FileSource.documents),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Cancel'.tr, style: TextStyle(color: Colors.red)),
              onTap: () => Get.back(result: FileSource.none),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGallery() async {
    if (await _requestStoragePermission()) {
      final images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (images != null) {
        for (var image in images) {
          if (attachedFiles.length >= maxFiles) break;
          final file = File(image.path);
          if (_isFileSizeValid(file)) attachedFiles.add(file);
        }
        _showSuccessMessage('Images attached');
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _handleCamera() async {
    if (await _requestCameraPermission()) {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (photo != null) {
        final file = File(photo.path);
        if (_isFileSizeValid(file)) {
          attachedFiles.add(file);
          _showSuccessMessage('Photo attached');
        }
      }
    } else {
      _showCameraPermissionDialog();
    }
  }

  Future<void> _handleDocuments() async {
    if (await _requestStoragePermission()) {
      final typeGroup = XTypeGroup(
        label: 'documents',
        extensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'txt'],
      );
      final files = await openFiles(acceptedTypeGroups: [typeGroup]);

      for (var xfile in files) {
        if (attachedFiles.length >= maxFiles) break;
        final picked = File(xfile.path);
        if (_isFileTypeAllowed(picked) && _isFileSizeValid(picked)) {
          attachedFiles.add(picked);
        }
      }
      if (files.isNotEmpty) _showSuccessMessage('Files attached');
    } else {
      _showPermissionDeniedDialog();
    }
  }

  bool _isFileTypeAllowed(File file) {
    final fileName = file.path.toLowerCase();
    final allowedExtensions = ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png', '.txt'];
    return allowedExtensions.any((ext) => fileName.endsWith(ext));
  }

  bool _isFileSizeValid(File file) {
    const maxSize = 10 * 1024 * 1024;
    try {
      final fileSize = file.lengthSync();
      if (fileSize > maxSize) {
        Get.snackbar('File Too Large'.tr, 'Max size: 10MB'.tr);
        return false;
      }
      return true;
    } catch (e) {
      return false;
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

  // Permission methods
  Future<bool> _requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.photos.request().isGranted) return true;
        final status = await Permission.storage.request();
        return status.isGranted;
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Dialog methods
  void _showLimitError() {
    Get.snackbar('Limit Reached'.tr, 'Max $maxFiles files'.tr);
  }

  void _showSuccessMessage(String message) {
    Get.snackbar('Success'.tr, message.tr, duration: Duration(seconds: 2));
  }

  void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Permission Required'.tr),
        content: Text('Storage permission is required'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr)),
          TextButton(
            onPressed: () { Get.back(); openAppSettings(); },
            child: Text('Open Settings'.tr),
          ),
        ],
      ),
    );
  }

  void _showCameraPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Camera Permission Required'.tr),
        content: Text('Camera permission is required'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel'.tr)),
          TextButton(
            onPressed: () { Get.back(); openAppSettings(); },
            child: Text('Enable in Settings'.tr),
          ),
        ],
      ),
    );
  }
}