import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Navigator.of(context).canPop()
          ? Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: AppColors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            GoRouter.of(context).go('/notifications');
          },
          icon: const Icon(Icons.notifications, color: AppColors.white),
        ),
        const SizedBox(width: 20),
      ],
      backgroundColor: AppColors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}