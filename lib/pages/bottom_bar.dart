
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:owe/pages/main_page.dart';
import 'package:owe/pages/profile_page.dart';
import 'package:owe/pages/search_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptopns = <Widget>[
    TotalPage(),
    Search(),
    Profile(),
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptopns[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: const Color(0xff526480),
         // ignore: prefer_const_literals_to_create_immutables
         items: [
           const BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined),
           activeIcon:Icon(Icons.monetization_on) ,
            label: "Home"),
           const BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_search_regular), 
           activeIcon:Icon(FluentSystemIcons.ic_fluent_search_filled) ,
           label: "Search"),
            const BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_person_regular), 
           activeIcon:Icon(FluentSystemIcons.ic_fluent_person_filled) ,
           label: "Search"),
      ]),
    );
  }
}