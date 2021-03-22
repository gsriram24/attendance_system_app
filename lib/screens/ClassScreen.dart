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
      body: Container(
        child: Text(
          studentList.length.toString(),
        ),
      ),
    );
  }
}
