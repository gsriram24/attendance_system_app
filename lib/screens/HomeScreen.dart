import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:attendance_system_app/screens/ClassScreen.dart';
import 'package:attendance_system_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    final token = Provider.of<Auth>(context).token;

    if (_isInit && Provider.of<Classes>(context).teacherClasses.length == 0) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Classes>(context).fetchAndSetTeacherClasses(token).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List imageList = [
    AssetImage("assets/Images/banner1.jpg"),
    AssetImage("assets/Images/banner2.jpg"),
    AssetImage("assets/Images/banner3.jpg"),
    AssetImage("assets/Images/banner4.jpg"),
    AssetImage("assets/Images/banner5.jpg"),
    AssetImage("assets/Images/banner6.jpg"),
    AssetImage("assets/Images/banner7.jpg"),
    AssetImage("assets/Images/banner8.jpg"),
    AssetImage("assets/Images/banner9.jpg"),
    AssetImage("assets/Images/banner10.jpg"),
    AssetImage("assets/Images/banner11.jpg"),
    AssetImage("assets/Images/banner12.jpg"),
  ];
  @override
  Widget build(BuildContext context) {
    var teacherClasses = Provider.of<Classes>(context).teacherClasses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      drawer: AppDrawer(),
      body: _isLoading || teacherClasses == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: teacherClasses.length,
                itemBuilder: (context, int index) {
                  return Stack(
                    children: [
                      Container(
                        height: 160,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageList[index % imageList.length],
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ClassScreen.routeName,
                                  arguments: teacherClasses[index]);
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25, left: 15),
                        width: 220,
                        child: Text(
                          teacherClasses[index].subjectName,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 55, left: 15),
                        child: Text(
                          '${teacherClasses[index].semester.toString()} ${teacherClasses[index].section}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 130, left: 15),
                        child: Text(
                          teacherClasses[index].branch,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
