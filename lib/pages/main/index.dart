import 'package:duel_links_meta/pages/articles/index.dart';
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

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Articles', style: optionStyle),
    Text('Index 3: School', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomePage(),
          const PacksPage(),
          const ArticlesPage(),
          Container(
            color: Colors.purple,
          )
        ],
      ),
      // bottomNavigationBar: NavigationBar(
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.home, size: 20,), label: 'home'),
      //     NavigationDestination(icon: Icon(Icons.home), label: 'home'),
      //     NavigationDestination(icon: Icon(Icons.home), label: 'home'),
      //     NavigationDestination(icon: Icon(Icons.home), label: 'home'),
      //   ],
      //   // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //   selectedIndex: _selectedIndex,
      //   onDestinationSelected: _onItemTapped,
      //   height: 70,
      // ),
      bottomNavigationBar: Theme(
        data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Color(0xFF001427),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              backgroundColor: Color(0xFF001427),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
              backgroundColor: Color(0xFF001427),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
              backgroundColor: Color(0xFF001427),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF001427),
          selectedIconTheme: const IconThemeData(color: Colors.white),
          selectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
