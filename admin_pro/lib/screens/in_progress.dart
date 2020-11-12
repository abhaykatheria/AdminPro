import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';

class InProgress extends StatelessWidget {
  const InProgress({Key key}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Text(
                    "Upcoming Tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  Divider(color: Colors.black12,),
                  SizedBox(
                    height: 20.0,
                  ),
                  subheading("This week"),
                  SizedBox(height: 15.0,),
                  Container(color: Colors.amber,
                  height: 200,
                  ),
                  SizedBox(height: 15.0,),
                  subheading("After This week"),
                  SizedBox(height: 15.0,),
                  Container(color: Colors.redAccent,
                  height: 200,
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
