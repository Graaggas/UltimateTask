import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertFromTimeStampToString(Timestamp date) =>
    DateFormat("dd.MM.yyyy").format(date.toDate()).toString();

String convertColorToString(Color currentColor) {
  RegExp reg = RegExp('primary');
  String forTrim = currentColor.toString();
  print("==> forTrim = $forTrim");
  //  "MaterialColor(primary value: Color(0xff9e9e9e))";
  bool str = reg.hasMatch(forTrim);
  if (str) {
    print("==> long version of Color = ${str.toString()}");
    print("==> length = ${forTrim.length}");
    String trimmedString = forTrim.substring(35, forTrim.length - 2);
    print("==> final = $trimmedString");
    return trimmedString;
  } else {
    String trimmedString = forTrim.substring(6, forTrim.length - 1);
    print("==> final = $trimmedString");
    return trimmedString;
  }
}
