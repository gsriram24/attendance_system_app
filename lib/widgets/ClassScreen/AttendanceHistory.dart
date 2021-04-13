import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatelessWidget {
  final List studentList;
  final List attendanceList;
  AttendanceHistory(this.studentList, this.attendanceList);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
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
