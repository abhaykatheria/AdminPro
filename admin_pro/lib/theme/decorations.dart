import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
InputDecoration getTextDecoration({String label, String prefix=""}) {
  return InputDecoration(
    labelStyle: TextStyle(color: Colors.black45),
    border: OutlineInputBorder(),
    labelText: label,
    prefix: Text(prefix)
  );
}


Row taskviewfield({String field, String value }){

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(field+" :    ",
        style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
              fontSize: 15.0,
            color: Colors.white
          )
        ),
      ),
      Text(value,
        style: GoogleFonts.oxygenMono(
          textStyle: TextStyle(
            fontSize: 15.0,
          )
        ),
      ),
    ],
  );


}