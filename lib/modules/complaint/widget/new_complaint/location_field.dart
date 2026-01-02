import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/new_complaint_controller/complaint_form_controller.dart';

class LocationField extends StatelessWidget {
  const LocationField({super.key});

  @override
  Widget build(BuildContext context) {
    final formController = Get.find<ComplaintFormController>();

    return TextFormField(
      controller: formController.locationController,
      onChanged: formController.updateLocation,
      validator: formController.validateLocation,
      decoration: InputDecoration(
        labelText: 'Location'.tr,
        labelStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        prefixIcon: Icon(Icons.location_on),
      ),
    );
  }
}