import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:flutter/material.dart';

class ClassScreen extends StatelessWidget {
  static const routeName = '/class';
  @override
  Widget build(BuildContext context) {
    final classDetails = ModalRoute.of(context).settings.arguments as ClassItem;
    return Container(
      child: Text(classDetails.subjectName),
    );
  }
}
