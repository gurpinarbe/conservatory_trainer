import 'package:flutter/material.dart';

class ExerciseModule {
  const ExerciseModule({
    required this.title,
    required this.description,
    required this.icon,
    required this.isAvailable,
    this.routePath,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isAvailable;
  final String? routePath;
}
