import 'package:admin_pro/screens/create_new_task_page.dart';
import 'package:admin_pro/screens/home.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/screens/tutors.dart';
import 'package:admin_pro/screens/financials.dart';
import 'package:admin_pro/screens/analytics.dart';
import 'package:admin_pro/screens/add_timed_ass.dart';
import 'package:flutter/rendering.dart';
import 'students.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class homeview extends StatefulWidget {
  homeview({Key key}) : super(key: key);

  @override
  _homeviewState createState() => _homeviewState();
}

class _homeviewState extends State<homeview> {
  int _currentIndex = 0;
  PageController _pageController;
  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  bool dialVisible = true;

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
            Students()
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
          ),
          BottomNavyBarItem(
            title: Text('Students'),
            icon: Icon(Icons.school
          ),  
          )
        ],
      ),
      floatingActionButton: SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.pending_actions, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    AddTimed()));
          },
          label: 'Timed',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.assignment, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    CreateNewTask()));
          },
          label: 'Assignment',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
      ],
    ),
    );
  }
}