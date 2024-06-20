import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  bool _isHomePage(GoRouter router) {
    final location = router.routerDelegate.currentConfiguration?.uri.toString();
    return location == '/home';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () {
            final router = GoRouter.of(context);

            if (router.canPop() && !_isHomePage(router)) {
              router.pop();
            } else {
              router.go('/home');
            }
          },
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: AppColors.white),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final userId = await _getUserId();
            print('Navigating to notifications for user: $userId');
            GoRouter.of(context).go('/home/notifications', extra: userId);
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
