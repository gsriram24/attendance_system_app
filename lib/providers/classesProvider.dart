import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ClassItem {
  final String id;
  final String classId;
  final String subjectName;
  final int semester;
  final String section;
  final String branch;

  ClassItem(this.id, this.classId, this.subjectName, this.semester,
      this.section, this.branch);
}

class Classes with ChangeNotifier {
  final List<ClassItem> teacherClasses = [];
  Dio dio = new Dio();

  Future<void> fetchAndSetTeacherClasses(token) async {
    final List<ClassItem> loadedRequests = [];
    dio.options.headers["Authorization"] = "Bearer $token";
    try {
      final response = await dio
          .get('https://attendancesystemadmin.herokuapp.com/api/class/teacher');
      final data = response.data.toList();
      print(data);
      data.forEach((item) => {
            teacherClasses.add(ClassItem(
                item['_id'],
                item['classId'],
                item['subjectName'],
                item['semester'],
                item['section'],
                item['branch']))
          });
    } catch (error) {
      print(error.response);
    }
  }
}
