import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Task {
  final String memo;
  final String id;
  DateTime creationDate;
  DateTime doingDate;
  DateTime lastEditDate;
  Color color;
  bool outOfDate;
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
    }
    final String memo = data['memo'];
    final String id = data['id'];
    final DateTime creationDate = data['creationDate'];
    final DateTime doingDate = data['doingDate'];
    final DateTime lastEditDate = data['lastEditDate'];
    final Color color = data['color'];
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

  Map<String, dynamic> toMap() {
    return {
      'memo': memo,
      'id': id,
      'creationDate': creationDate,
      'doingDate': doingDate,
      'lastEditDate': lastEditDate,
      'color': color,
      'outOfDate': outOfDate,
      'isDeleted': isDeleted,
    };
  }
}
