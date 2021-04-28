import 'package:attendance_system_app/providers/attendanceProvider.dart';
import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAttendancecScreen extends StatefulWidget {
  static const routeName = '/edit-attendance';

  @override
  _EditAttendancecScreenState createState() => _EditAttendancecScreenState();
}

class _EditAttendancecScreenState extends State<EditAttendancecScreen> {
  var _isLoading = false;

  void addAttendance(classId, presentList, studentList) async {
    final token = Provider.of<Auth>(context, listen: false).token;
    setState(() {
      _isLoading = true;
    });
    final studentIdList = studentList.map((s) => s.id);
    final List absentList =
        studentIdList.where((s) => !presentList.contains(s)).toList();
    final bool success =
        await Provider.of<AttendanceProvider>(context, listen: false)
            .enterAttendanceData(
      absentList,
      classId,
      token,
    );
    setState(() {
      _isLoading = false;
    });
    if (success) {
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final classDetails = arguments['classDetails'];
    final studentList = arguments['studentList'];
    var presentList = arguments['presentList'];
    return Scaffold(
      appBar: AppBar(
        title: Text(classDetails.subjectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading
                ? null
                : () =>
                    addAttendance(classDetails.id, presentList, studentList),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, int index) => SwitchListTile(
                  value: presentList.contains(studentList[index].id),
                  onChanged: (val) {
                    setState(() {
                      if (val) {
                        presentList.add(studentList[index].id);
                      } else {
                        presentList.remove(studentList[index].id);
                      }
                    });
                  },
                  secondary: CircleAvatar(
                    backgroundImage: NetworkImage(
                      studentList[index].images[0],
                    ),
                  ),
                  title: Text(
                    studentList[index].fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                itemCount: studentList.length,
              ),
            ),
    );
  }
}
