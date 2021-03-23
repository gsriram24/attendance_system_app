import 'package:attendance_system_app/providers/attendanceProvider.dart';
import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:attendance_system_app/providers/studentProvider.dart';
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
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Students',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              studentList.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Classes',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              attendanceList.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
