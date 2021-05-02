import 'dart:io';
import 'package:attendance_system_app/providers/attendanceProvider.dart';
import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:attendance_system_app/screens/EditAttendanceScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewAttendanceScreen extends StatefulWidget {
  static const routeName = '/new-attendance';
  @override
  _NewAttendanceScreenState createState() => _NewAttendanceScreenState();
}

class _NewAttendanceScreenState extends State<NewAttendanceScreen> {
  var _isLoading = false;
  List<File> images = [];
  Future getImageFromCamera() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (image == null) {
      return;
    }
    setState(() {
      images.insert(0, File(image.path));
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      return;
    }
    setState(() {
      images.insert(0, File(image.path));
    });
    print(images);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final classDetails = arguments['classDetails'];
    final studentList = arguments['studentList'];
    final token = Provider.of<Auth>(context).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(classDetails.subjectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    var presentList = [];
                    if (images.length > 0) {
                      presentList = await Provider.of<AttendanceProvider>(
                              context,
                              listen: false)
                          .getPresentStudentsFromPhoto(
                        images,
                        classDetails.id,
                        token,
                      );
                    }
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context)
                        .pushNamed(EditAttendancecScreen.routeName, arguments: {
                      'isNew': true,
                      'classDetails': classDetails,
                      'studentList': studentList,
                      'presentList': presentList
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat.EEEE().format(DateTime.now())}, ${DateFormat.MMMMd().format(DateTime.now())}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${DateFormat.jm().format(DateTime.now())}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  images.length == 0
                      ? Center(
                          child: Text('No images chosen!'),
                        )
                      : Expanded(
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 16 / 9,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 25,
                              horizontal: 10,
                            ),
                            children: images
                                .map(
                                  (i) => Image.file(
                                    i,
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: getImageFromCamera,
                        icon: Icon(Icons.camera),
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: getImageFromGallery,
                        icon: Icon(Icons.image),
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
