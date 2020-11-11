import 'package:admin_pro/screens/create_new_task_page.dart';
import 'package:admin_pro/screens/home.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text("Nav Bar")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Home(),
            Container(color: Colors.red,),
            Container(color: Colors.green,),
            Container(color: Colors.blue,),
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
            title: Text('Item One'),
            icon: Icon(Icons.apps)
          ),
          BottomNavyBarItem(
            title: Text('Item One'),
            icon: Icon(Icons.chat_bubble)
          ),
          BottomNavyBarItem(
            title: Text('Item One'),
            icon: Icon(Icons.settings)
          ),
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