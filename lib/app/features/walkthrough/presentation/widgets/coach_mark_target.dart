import 'package:flutter/material.dart';

enum CoachMarkPosition { top, bottom, left, right }

class CoachMarkTarget {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final CoachMarkPosition position;
  final Future<void> Function()? onBeforeTarget;

  const CoachMarkTarget({
    required this.targetKey,
    required this.title,
    required this.description,
    this.position = CoachMarkPosition.bottom,
    this.onBeforeTarget,
  });
}
