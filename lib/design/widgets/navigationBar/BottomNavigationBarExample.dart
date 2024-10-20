import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  void _onItemTapped(int index, TabsRouter tabsRouter) {
    setState(() {
      tabsRouter.setActiveIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.badge_outlined),
          label: 'Читатели',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_stories_outlined),
          label: 'Книги',
        ),
      ],
      currentIndex: tabsRouter.activeIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (index) => _onItemTapped(index, tabsRouter),
      selectedFontSize: 18,
      unselectedFontSize: 14,
      iconSize: 40,
    );
  }
}
