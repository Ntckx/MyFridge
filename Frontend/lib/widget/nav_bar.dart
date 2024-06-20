import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavItem {
  Widget icon;
  String label;
  String path;
  bool isGo = false;
  NavItem(
      {required this.icon,
      required this.label,
      required this.path,
      this.isGo = false});
}

class BottomNav extends StatelessWidget {
  final String? path;
  const BottomNav({super.key, required this.path});

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final paths = [
      NavItem(
        icon: const Icon(Icons.checklist),
        label: 'Shopping list',
        path: "/home/shoppinglist",
      ),
      NavItem(
          icon: const Icon(Icons.home),
          label: 'Home',
          path: "/home",
          isGo: true),
      NavItem(
          icon: const Icon(Icons.person),
          label: 'Profile',
          path: "/home/profile",
          isGo: true),
    ];

    int whichIndex() {
      for (int i = 0; i < paths.length; i++) {
        if (path == paths[i].path) {
          return i;
        }
      }
      return -1;
    }

    void onChangeRoute(int index) async {
      final userId = await _getUserId();
      if (paths[index].isGo) {
        GoRouter.of(context).go(paths[index].path, extra: userId);
      } else {
       GoRouter.of(context).push(paths[index].path, extra: userId);
      }
    }

    int currentIndex = whichIndex();

    return BottomNavigationBar(
      backgroundColor: AppColors.white,
      items: <BottomNavigationBarItem>[
        for (NavItem i in paths)
          BottomNavigationBarItem(icon: i.icon, label: i.label)
      ],
      currentIndex: currentIndex >= 0 ? currentIndex : 0,
      showSelectedLabels: false,
      selectedItemColor: currentIndex >= 0 ? AppColors.yellow : AppColors.darkblue,
      unselectedItemColor: AppColors.darkblue,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index != currentIndex) {
          onChangeRoute(index);
        }
      },
    );
  }
}