import 'package:admin_pro/screens/create_new_task_page.dart';
import 'package:admin_pro/screens/home.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/screens/tutors.dart';
import 'package:admin_pro/screens/financials.dart';
import 'package:admin_pro/screens/analytics.dart';

class homeview extends StatefulWidget {
  homeview({Key key}) : super(key: key);

  @override
  _homeviewState createState() => _homeviewState();
}

class _homeviewState extends State<homeview> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Pro")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Home(),
            Financial(),
            Tutors(),
            Analytics(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
            title: Text('Financials'),
            icon: Icon(Icons.attach_money)
          ),
          BottomNavyBarItem(
            title: Text('Tutors'),
            icon: Icon(Icons.supervised_user_circle)
          ),
          BottomNavyBarItem(
            title: Text('Analysis'),
            icon: Icon(Icons.stacked_line_chart
          ),  
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    CreateNewTask()));
        },
      child: Icon(Icons.add),),
    );
  }
}