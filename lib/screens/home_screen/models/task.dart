import 'package:flutter/foundation.dart';

class Task {
  final String name;
  final int rating;
  final String id;

  Task({@required this.id, @required this.name, @required this.rating});

  factory Task.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int rating = data['rating'];
    final String id = data['id'];
    return Task(
      name: name,
      rating: rating,
      id: id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'id': id,
    };
  }
}
