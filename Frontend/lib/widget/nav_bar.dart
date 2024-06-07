import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final paths = [
      NavItem(
        icon: const Icon(Icons.checklist),
        label: 'Shopping list',
        path: "/shoppinglist",
      ),
      NavItem(
          icon: const Icon(Icons.home),
          label: 'Home',
          path: "/",
          isGo: true),
      NavItem(
          icon: const Icon(Icons.person),
          label: 'Profile',
          path: "/profile",
          isGo: true),
    ];

    int whichIndex() {
      for (int i = 0; i < paths.length; i++) {
        if (path == paths[i].path) {
          return i;
        }
      }
      return -1; // Return -1 if the path is not found
    }

    void onChangeRoute(int index) {
      if (paths[index].isGo) {
        context.go(paths[index].path);
      } else {
        context.push(paths[index].path, extra: true);
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
