// lib/view/widget/complaint/load_more_indicator.dart

import 'package:flutter/material.dart';
import '../../../core/constant/appcolor.dart';

class LoadMoreIndicator extends StatelessWidget {
  final bool isLoading;

  const LoadMoreIndicator({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator(color: AppColor.primaryColor)
            : const SizedBox.shrink(),
      ),
    );
  }
}