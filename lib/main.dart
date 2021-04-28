import 'package:attendance_system_app/providers/attendanceProvider.dart';
import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:attendance_system_app/screens/ClassScreen.dart';
import 'package:attendance_system_app/screens/EditAttendanceScreen.dart';
import 'package:attendance_system_app/screens/HomeScreen.dart';
import 'package:attendance_system_app/screens/LoginScreen.dart';
import 'package:attendance_system_app/screens/NewAttendanceScreen.dart';
import 'package:attendance_system_app/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Classes(),
        ),
        ChangeNotifierProvider.value(
          value: AttendanceProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Attendance System',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
            ClassScreen.routeName: (_) => ClassScreen(),
            NewAttendanceScreen.routeName: (_) => NewAttendanceScreen(),
            EditAttendancecScreen.routeName: (_) => EditAttendancecScreen()
          },
        ),
      ),
    );
  }
}
