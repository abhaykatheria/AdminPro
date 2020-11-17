import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/active_project_card.dart';
import 'package:admin_pro/widgets/task_column.dart';
import 'package:flutter/material.dart';
import 'package:admin_pro/screens/in_progress.dart';
import 'package:admin_pro/screens/done.dart';
import 'package:admin_pro/screens/create_new_task_page.dart';
import 'package:admin_pro/screens/add_tutor.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Text subheading(String title) {
  return Text(
    title,
    style: TextStyle(
        color: LightColors.kDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2),
  );
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            subheading('My Tasks'),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        SizedBox(
                          height: 15.0,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InProgress()));
                          },
                          child: TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'In Progress',
                            subtitle: '1 tasks now. 1 started',
                          ),
                        ),
                        SizedBox(height: 15.0),
                        FlatButton(
                          onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Done()));
                          },
                          child: TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Done',
                            subtitle: '18 tasks now. 13 started',
                          ),
                        ),
                        SizedBox(height: 15.0),
                        FlatButton(
                          onPressed: () {},
                          child: TaskColumn(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'Past Due',
                            subtitle: '5 tasks now. 1 started',
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            subheading('Upcoming this week'),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          color: Colors.amber,
                          height: 100.0,
                        ),
                        SizedBox(height: 15.0),
                    //     FlatButton(
                    //   onPressed: () {
                    //       Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => AddTutor()));
                    //   },
                    //   child: Container(
                    //       child: Center(child: Text("Add Tutor",style: TextStyle(color: Colors.white),)),
                    //       height: 50.0,
                    //       width: 150.0,
                    //       decoration: BoxDecoration(
                    //           color: Colors.red,
                    //           borderRadius: BorderRadius.circular(10.0)),
                    //   ),
                    // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
