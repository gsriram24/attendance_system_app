import 'package:attendance_system_app/providers/attendanceProvider.dart';
import 'package:attendance_system_app/providers/studentProvider.dart';
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
    dio.options.headers["Authorization"] = "Bearer $token";
    try {
      final response = await dio
          .get('https://attendancesystemadmin.herokuapp.com/api/class/teacher');
      final data = response.data.toList();
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

  Future<List<Student>> getStudentsOfClass(classId, token) async {
    dio.options.headers["Authorization"] = "Bearer $token";
    final List<Student> studentList = [];
    try {
      final response = await dio.get(
          'https://attendancesystemadmin.herokuapp.com/api/student/byClass/$classId');

      final data = response.data['students'];
      data.forEach(
        (item) => {
          studentList.add(
            Student(
              item['_id'],
              item['usn'],
              item['fullName'],
              item['email'],
              item['classes'],
              item['images'],
            ),
          )
        },
      );
    } catch (error) {
      print(error);
    }
    return studentList;
  }

  Future<List<Attendance>> getAttendanceOfClass(classId, token) async {
    dio.options.headers["Authorization"] = "Bearer $token";
    final List<Attendance> attendanceList = [];
    try {
      final response = await dio.get(
          'https://attendancesystemadmin.herokuapp.com/api/attendance/byClass/$classId');

      final data = response.data['attendance'];
      data.forEach(
        (item) => {
          attendanceList.add(
            Attendance(
              item['_id'],
              item['classId'],
              item['absent'],
              DateTime.parse(item['createdAt']),
            ),
          )
        },
      );
    } catch (error) {
      print(error);
    }
    return attendanceList;
  }
}
