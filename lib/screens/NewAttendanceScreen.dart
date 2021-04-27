import 'dart:io';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewAttendanceScreen extends StatefulWidget {
  static const routeName = '/new-attendance';
  @override
  _NewAttendanceScreenState createState() => _NewAttendanceScreenState();
}

class _NewAttendanceScreenState extends State<NewAttendanceScreen> {
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
    final classDetails = ModalRoute.of(context).settings.arguments as ClassItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(classDetails.subjectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
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
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 16 / 9,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
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
