import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color? textColor;
  final Widget? trailing;

  const AppTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.deepOrangeAccent,
    this.textColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).cardColor,
            child: ListTile(
              tileColor: Colors.transparent,
              leading: Icon(icon, color: iconColor),
              title: TextButton(
                onPressed: onTap,
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor ?? Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              trailing: trailing,
            ),
          ),
        ),
      ],
    );
  }
}
