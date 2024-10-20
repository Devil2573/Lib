import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects/routes/app_router.dart';

import '../../design/widgets/navigationBar/BottomNavigationBarExample.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutoTabsRouter(
        routes: const [
          ReaderListRoute(),
          AllBookRoute(),
        ],
        transitionBuilder: (context, child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        builder: (context, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: const BottomNavigationBarExample(),
          );
        },
      ),
    );
  }
}
