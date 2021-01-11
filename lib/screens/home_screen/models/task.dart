import 'package:flutter/foundation.dart';

class Task {
  final String name;
  final int rating;

  Task({@required this.name, @required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
    };
  }
}
