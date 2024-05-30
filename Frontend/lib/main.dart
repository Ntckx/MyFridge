import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/custom_theme.dart';
import 'package:myfridgeapp/routes/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
      // providers: [

      // ],

    return Container(
      child: MaterialApp.router(
        title: "MyFridge",
        theme: CustomTheme.customTheme,
        routerConfig: router,
      ),
    );
  }
}
