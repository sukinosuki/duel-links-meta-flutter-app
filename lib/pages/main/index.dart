import 'package:duel_links_meta/pages/articles/index.dart';
import 'package:duel_links_meta/pages/ban_list_change/index.dart';
import 'package:duel_links_meta/pages/home/index.dart';
import 'package:duel_links_meta/pages/packs/index.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [BottomNavigationBar].

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          PacksPage(),
          ArticlesPage(),
          BanListChangePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.card_giftcard), label: 'Packs'),
          NavigationDestination(icon: Icon(Icons.article), label: 'Articles'),
          NavigationDestination(icon: Icon(Icons.sync_disabled), label: 'Ban list'),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 70,
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
        // surfaceTintColor: Colors.tealAccent,
        // surfaceTintColor: Colors.transparent,
        // backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
