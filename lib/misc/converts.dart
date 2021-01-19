import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String convertFromTimeStampToString(Timestamp date) =>
    DateFormat("dd.MM.yyyy").format(date.toDate()).toString();
