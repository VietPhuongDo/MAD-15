import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/formats.dart';

class Habit {
  String id;
  String name;
  String category; // Trường category mới
  Map<String, int> frequency;
  List<TimeOfDay> reminders;
  bool notification;
  DateTime createdAt;
  String createdBy;
  List<String> completedDays;

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.frequency,
    required this.reminders,
    required this.notification,
    required this.createdAt,
    required this.createdBy,
    required this.completedDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'frequency': frequency,
      'reminders': reminders.map((x) => x.labelTime).toList(),
      'notification': notification,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'completedDays': completedDays,
    };
  }

  factory Habit.fromMap(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      frequency: Map<String, int>.from(map['frequency']),
      reminders: List<TimeOfDay>.from(
        map['reminders']?.map(
              (x) => Parsers.parse(x),
        ) ??
            [],
      ),
      notification: map['notification'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
      completedDays: List<String>.from(map['completedDays'] ?? []),
    );
  }

  factory Habit.empty(Map<String, int> fr) {
    return Habit(
      id: '',
      name: '',
      category: '',
      frequency: fr,
      reminders: [],
      notification: false,
      createdAt: DateTime.now(),
      createdBy: '',
      completedDays: [],
    );
  }
}
