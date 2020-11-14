import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
InputDecoration getTextDecoration(String label) {
  return InputDecoration(
    labelStyle: TextStyle(color: Colors.black45),
    border: OutlineInputBorder(),
    labelText: label,
  );
}


Row taskviewfield({String field, String value }){

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(field+" :    ",
        style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
              fontSize: 20.0,
            color: Colors.white
          )
        ),
      ),
      Text(value,
        style: GoogleFonts.oxygenMono(
          textStyle: TextStyle(
            fontSize: 20.0,
          )
        ),
      ),
    ],
  );


}