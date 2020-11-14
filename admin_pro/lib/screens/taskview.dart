import 'package:flutter/material.dart';
import 'package:admin_pro/widgets/data.dart';
import 'package:admin_pro/theme/colors/light_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_pro/theme/decorations.dart';

class TaskView extends StatefulWidget {
  TaskView({Key key, this.a}) : super(key: key);
  final Assignment a;
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _formattedDate =
        "${widget.a.dueDate.day}/${widget.a.dueDate.month}/${widget.a.dueDate.year}";
    return Scaffold(
      backgroundColor: LightColors.kLightGreen,
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 15.0),
                Text(
                  "Assignment Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [LightColors.kGreen, Colors.blue]),
                      backgroundBlendMode: BlendMode.darken,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    constraints: BoxConstraints(minWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Student", value: widget.a.student),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Subject", value: widget.a.subject),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Tutor", value: widget.a.subject),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Price",
                              value: widget.a.price.toString() + " \$"),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Amount Paid",
                              value: widget.a.amountPaid.toString() + " \$"),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Tutor Fee",
                              value: widget.a.price.toString() + " \$"),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Assigned Date", value: _formattedDate),
                          SizedBox(
                            height: 12.0,
                          ),
                          taskviewfield(
                              field: "Due Date", value: _formattedDate),
                          SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                FlatButton(
                      onPressed: () {
                        
                      },
                      child: Container(
                        child: Center(child: Text("Change Due Date",style: TextStyle(color: Colors.white),)),
                        height: 50.0,
                        width: 320.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        
                      },
                      child: Container(
                        child: Center(child: Text("Mark Completed",style: TextStyle(color: Colors.white),)),
                        height: 50.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        
                      },
                      child: Container(
                        child: Center(child: Text("Delete Assignment",style: TextStyle(color: Colors.white),)),
                        height: 50.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
