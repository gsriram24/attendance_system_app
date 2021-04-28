import 'package:flutter/material.dart';

class EditAttendancecScreen extends StatefulWidget {
  static const routeName = '/edit-attendance';

  @override
  _EditAttendancecScreenState createState() => _EditAttendancecScreenState();
}

class _EditAttendancecScreenState extends State<EditAttendancecScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final classDetails = arguments['classDetails'];
    final studentList = arguments['studentList'];
    var presentList = arguments['presentList'];
    return Scaffold(
      appBar: AppBar(
        title: Text(classDetails.subjectName),
      ),
      body: Padding(
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
