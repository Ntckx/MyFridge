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
        icon: const Icon(Icons.shopping_cart),
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
      return 0;
    }

    void onChangeRoute(int index) {
      if (paths[index].isGo) {
        context.go(paths[index].path);
      } else {
        context.push(paths[index].path, extra: true);
      }
    }

    return BottomNavigationBar(
      backgroundColor: AppColors.blue,
      items: <BottomNavigationBarItem>[
        for (NavItem i in paths)
          BottomNavigationBarItem(icon: i.icon, label: i.label)
      ],
      currentIndex: whichIndex(),
      showSelectedLabels: false,
      selectedItemColor: AppColors.yellow,
      unselectedItemColor: AppColors.white,
      showUnselectedLabels: false,
      onTap: onChangeRoute,
    );
  }
}