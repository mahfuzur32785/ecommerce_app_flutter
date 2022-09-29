import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:ecommerce_app/screen/all_screens/category/category_page.dart';
import 'package:ecommerce_app/screen/all_screens/order_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screen/all_screens/homepage.dart';
class CustomBtmNavBar extends StatefulWidget {
  const CustomBtmNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBtmNavBar> createState() => _CustomBtmNavBarState();
}

class _CustomBtmNavBarState extends State<CustomBtmNavBar> {

  int _currentIndex=0;

  List _pages = [
    HomePage(),
    CategoryPage(),
    OrderPage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ecommerce App'),
      ),
      body: BottomBarPageTransition(builder: (BuildContext context, int index) {
        return Container(
          child: _pages[_currentIndex],
        );
      },
        currentIndex: _currentIndex,
        totalLength: 4,
        transitionType: TransitionType.circular,
        transitionDuration: Duration(milliseconds: 400),
        transitionCurve: Curves.ease,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _currentIndex = index;
            setState(() {});
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Category"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Order"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Setting"),
          ]
      ),
    );
  }
}
