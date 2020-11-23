import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveProjectsCard extends StatelessWidget {
  final Color cardColor;
  final int amount;
  final String title;
  final String subtitle;
  final String extend;

  ActiveProjectsCard({
    this.cardColor,
    this.amount,
    this.title,
    this.subtitle,
    this.extend = ""
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(15.0),
          height: 200,
          width: 170,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20.0),
            
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(amount.toString() + " " + extend,
                style: GoogleFonts.fjallaOne(
                  textStyle : TextStyle(
                    fontSize : 50.0
                  )
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
