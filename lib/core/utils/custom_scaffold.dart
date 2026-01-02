import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants/appcolor.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final String? backgroundImage;
  final AppBar? appBar;
  final Widget? drawer;
  final Color? backgroundColor;

  const CustomScaffold({
    super.key,
    this.child,
    this.backgroundImage,
    this.appBar,
    this.drawer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: backgroundColor ?? (isDark ? AppColor.darkBackground : AppColor.white),
      appBar: appBar,
      drawer: drawer,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (backgroundImage != null)
            SizedBox(
              width: double.infinity,
              height: 250.h,
              child: Image.asset(
                backgroundImage!,
                fit: BoxFit.cover,
                color: isDark ? Colors.black54 : null,
                colorBlendMode: isDark ? BlendMode.darken : null,
              ),
            )
          else
            Container(
              color: isDark ? AppColor.darkSubtitle : AppColor.grey,
              height: 200.h,
              width: double.infinity,
            ),

          SafeArea(child: child ?? const SizedBox()),
        ],
      ),
    );
  }
}