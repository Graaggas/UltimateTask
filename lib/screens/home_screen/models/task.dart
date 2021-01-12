import 'package:flutter/foundation.dart';

class Task {
  final String name;
  final int rating;

  Task({@required this.name, @required this.rating});

  factory Task.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int rating = data['rating'];
    return Task(
      name: name,
      rating: rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
    };
  }
}
