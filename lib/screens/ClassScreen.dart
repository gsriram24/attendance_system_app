import 'package:attendance_system_app/providers/attendanceProvider.dart';
import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:attendance_system_app/providers/studentProvider.dart';
import 'package:attendance_system_app/screens/NewAttendanceScreen.dart';
import 'package:attendance_system_app/widgets/ClassScreen/AttendanceHistory.dart';
import 'package:attendance_system_app/widgets/ClassScreen/ClassStats.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ClassScreen extends StatefulWidget {
  static const routeName = '/class';

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Student> studentList = [];
  List<Attendance> attendanceList = [];

  @override
  void didChangeDependencies() {
    final token = Provider.of<Auth>(context).token;

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final classDetails =
          ModalRoute.of(context).settings.arguments as ClassItem;

      Provider.of<Classes>(context)
          .getStudentsOfClass(classDetails.id, token)
          .then((data) {
        setState(() {
          studentList = data;
        });
      });
      Provider.of<Classes>(context)
          .getAttendanceOfClass(classDetails.id, token)
          .then((data) {
        setState(() {
          attendanceList = data;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final classDetails = ModalRoute.of(context).settings.arguments as ClassItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(classDetails.subjectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(NewAttendanceScreen.routeName,
                  arguments: {
                    'classDetails': classDetails,
                    'studentList': studentList
                  });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  ClassStats(studentList, attendanceList),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AttendanceHistory(studentList, attendanceList),
                ],
              ),
            ),
    );
  }
}
