import 'package:flutter/material.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:admin_pro/widgets/task_container.dart';
class Done extends StatelessWidget {
  const Done({Key key}) : super(key: key);
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
                    "Completed Assignments",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  
                  Container(
                    height: 125.0*assignments.length,
                    child: ListView.separated(
                      itemCount: assignments.length,
                      itemBuilder: (BuildContext context, int index) {
                        var date = assignments[index].dueDate;
                        var formattedDate =
                            "${date.day}-${date.month}-${date.year}";
                        return TaskContainer(
                          title: assignments[index].student,
                          subtitle: "Due " + formattedDate,
                          boxColor: LightColors.kLightGreen,
                          price: assignments[index].price,
                          tutor: "katheria" ,
                          a:assignments[index]
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      physics: const NeverScrollableScrollPhysics(),
                    ),
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