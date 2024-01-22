import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/Add/add_task.dart';
import 'package:learnizer/Views/Visualize/Individual/view_directory.dart';
import 'package:learnizer/services/search_youtube.dart';
import '../../../Models/user_model.dart';


class ViewTaskPage extends StatefulWidget {
  final UserModel user;
  final int directoryIndex;
  final int taskIndex;
  const ViewTaskPage({required this.user,required this.directoryIndex,required this.taskIndex, Key? key}) : super(key: key);

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage>{
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  late final _directoryIndex = widget.directoryIndex;
  late final _taskIndex = widget.taskIndex;
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlCover='';
  String? errorMessage;
  // This widget is the root of your application.
  Future<String> getThemeFromUtilities(String file, String caseImg) async {
    String imageUrl = await utilities.getTheme(file);
    if (caseImg == "cover") {
      imageUrlCover = imageUrl;
    } else {
      imageUrlLogo = imageUrl;
    }
    return imageUrl;
  }

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the widget is initialized
    getThemeFromUtilities("learnizer.png", "logo");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: FutureBuilder(
          // Use FutureBuilder to wait for the image URLs
            future: Future.wait([
              getThemeFromUtilities("learnizer.png", "logo"),
            ]),
            builder: (context, snapshot) {
              // Render the UI once the image URLs are fetched
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: utilities.getCorrectColors(_user.theme)
                          )
                      ),
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 60
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        weight: 9,
                                        size: 30, // Set the size of the icon to make it bigger
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewDirectoryPage(user: _user,directoryIndex: _directoryIndex,),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.question_mark,
                                        color: Colors.white,
                                        weight: 9,
                                        size: 30, // Set the size of the icon to make it bigger
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SearchPage(user: _user, directoryIndex: _directoryIndex,taskIndex: _taskIndex),
                                          ),
                                        );
                                      },
                                    ),
                                  ]
                              ),
                              const SizedBox(height: 30),
                              Text(
                                _user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height:40),
                              buildDeadline(),
                              buildDescription(),
                              const SizedBox(height: 50),
                              Text(
                                "Your Attachments",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                              for(int i=0;i<_user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).attachments.length;i++)
                                buildTile(_user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).attachments.elementAt(i),i)
                            ],
                          )
                      )
                  )
                ],
              );
            }
        ),
      ),
    );
  }

  buildDeadline(){
    return Column(
      children:[
         Container(
            margin: EdgeInsets.only(top: 20,bottom: 40,left:70,right: 70),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children:[
                Icon(
                  Icons.alarm_on_outlined,
                  color: utilities.returnColorByTheme(_user.theme),
                  size:15
                ),
                Text(
                  _user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).deadline.toString(),
                  style: TextStyle(
                    color: utilities.returnColorByTheme(_user.theme),
                    fontSize: 15
                  )
                )
              ]
            )
          )
      ]
    );
  }
  buildTile(String attachment, int index){
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.transparent,
            leading: CachedNetworkImage(
              imageUrl: attachment,
              width: 30,height: 30,
            ),
            title: Text(
              "Image ${index}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.zero,
              height: 35,
              width: 60,
              child: Row(
                  children:[
                    IconButton(
                      color: Colors.white,
                      iconSize: 18,
                      icon: Icon(Icons.delete),
                      onPressed:(){
                        setState(() {
                          _user.directories.elementAt(_directoryIndex).tasks.removeAt(_taskIndex).attachments.removeAt(index);
                          utilities.updateUserData(_user);
                        });
                      },
                    ),
                  ]
              ),
            )
        )
    );
  }

  buildDescription() {
    return Column(
      children:[
        Text(
          "Description",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ]
    );
  }

  buildDeadLine() {

  }

}

