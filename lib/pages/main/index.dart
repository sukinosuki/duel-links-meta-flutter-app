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
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.business), label: 'Packs'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Articles'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Ban list'),
        ],
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 70,
        // overlayColor: Colors.white,
        // indicatorColor: Colors.teal,
        // surfaceTintColor: Colors.tealAccent, // 背景
        // backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   selectedFontSize: 12,
      //   // useLegacyColorScheme: false,
      //   // enableFeedback: true,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), backgroundColor: Colors.transparent, label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Packs'),
      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Articles'),
      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Ban list'),
      //   ],
      //
      //   type: BottomNavigationBarType.fixed,
      //   // backgroundColor: BaColors.main,
      //   // selectedIconTheme: const IconThemeData(color: Colors.white),
      //   // selectedItemColor: Theme.of(context).colorScheme.secondary,
      //   // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      //   // unselectedItemColor: Colors.grey,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
