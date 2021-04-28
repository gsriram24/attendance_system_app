import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Attendance {
  final String id;
  final String classId;
  final List absent;
  final DateTime createdAt;
  Attendance(this.id, this.classId, this.absent, this.createdAt);
}

class AttendanceProvider with ChangeNotifier {
  Dio dio = new Dio();

  Future<List> getPresentStudentsFromPhoto(images, classId, token) async {
    dio.options.headers["Authorization"] = "Bearer $token";
    try {
      var formData = FormData.fromMap({
        'classId': classId,
      });

      for (var image in images) {
        formData.files.addAll([
          MapEntry("files", await MultipartFile.fromFile(image.path)),
        ]);
      }
      final response = await dio.post(
        'https://attendancefaceapi.herokuapp.com/',
        data: formData,
      );
      return response.data['data'];
    } catch (error) {
      print(error);
    }
  }
}
