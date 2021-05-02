import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:attendance_system_app/screens/EditAttendanceScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatelessWidget {
  final List studentList;
  final List attendanceList;
  final ClassItem classDetails;
  AttendanceHistory(this.studentList, this.attendanceList, this.classDetails);

  void navigateToEdit(i, context) {
    final studentIdList = studentList.map((s) => s.id);
    final List presentList = studentIdList
        .where((s) => !attendanceList[i].absent.contains(s))
        .toList();
    Navigator.of(context)
        .pushNamed(EditAttendancecScreen.routeName, arguments: {
      'isNew': false,
      'attendanceId': attendanceList[i].id,
      'classDetails': classDetails,
      'studentList': studentList,
      'presentList': presentList
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            onTap: () => navigateToEdit(i, context),
            title: Text(
              '${DateFormat.EEEE().format(attendanceList[i].createdAt)} | ${DateFormat.MMMd().format(attendanceList[i].createdAt)} | ${DateFormat.jm().format(attendanceList[i].createdAt.toLocal())}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: Text(
                'Present: ${studentList.length - attendanceList[i].absent.length} \t Absent: ${attendanceList[i].absent.length}',
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        itemCount: attendanceList.length,
      ),
    );
  }
}
