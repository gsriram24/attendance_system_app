import 'package:attendance_system_app/providers/authProvider.dart';
import 'package:attendance_system_app/providers/classesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    final token = Provider.of<Auth>(context).token;

    if (_isInit) {
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
      body: _isLoading || teacherClasses == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: teacherClasses.length,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () => {},
                  child: Stack(
                    children: [
                      Container(
                        height: 140,
                        margin: EdgeInsets.all(15),
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
                            onTap: () {},
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 30),
                        width: 220,
                        child: Text(
                          teacherClasses[index].subjectName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 65, left: 30),
                        child: Text(
                          '${teacherClasses[index].semester.toString()} ${teacherClasses[index].section}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 125, left: 30),
                        child: Text(
                          teacherClasses[index].branch,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
