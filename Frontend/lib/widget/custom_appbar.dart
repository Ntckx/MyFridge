import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const CustomAppBar(
      {super.key, required this.title, this.height = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: AppBar(
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColors.cream),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).go('/notifications');
            },
            icon: const Icon(Icons.notifications, color: AppColors.cream),
          ),
        ],
        backgroundColor: AppColors.blue,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
