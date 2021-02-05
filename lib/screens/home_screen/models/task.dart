import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part "task.g.dart";

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String memo;
  @HiveField(1)
  final String id;
  @HiveField(2)
  DateTime creationDate;
  @HiveField(3)
  DateTime doingDate;
  @HiveField(4)
  DateTime lastEditDate;
  @HiveField(5)
  String color;
  @HiveField(6)
  bool outOfDate;
  @HiveField(7)
  bool isDeleted;

  Task({
    @required this.id,
    @required this.memo,
    @required this.color,
    @required this.creationDate,
    @required this.doingDate,
    @required this.isDeleted,
    @required this.lastEditDate,
    @required this.outOfDate,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String memo = data['memo'];
      final String id = data['id'];
      final DateTime creationDate = data['creationDate'].toDate();
      final DateTime doingDate = data['doingDate'].toDate();
      final DateTime lastEditDate = data['lastEditDate'].toDate();
      final String color = data['color'];
      final bool outOfDate = data['outOfDate'];
      final bool isDeleted = data['isDeleted'];
      return Task(
        memo: memo,
        id: id,
        creationDate: creationDate,
        doingDate: doingDate,
        lastEditDate: lastEditDate,
        color: color,
        outOfDate: outOfDate,
        isDeleted: isDeleted,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'memo': memo,
      'id': id,
      'creationDate': Timestamp.fromDate(creationDate),
      'doingDate': Timestamp.fromDate(doingDate),
      'lastEditDate': Timestamp.fromDate(lastEditDate),
      'color': color,
      'outOfDate': outOfDate,
      'isDeleted': isDeleted,
    };
  }
}
