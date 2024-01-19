import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/task_model.dart';
import 'package:learnizer/Views/Add/add_task.dart';
import 'package:learnizer/Views/Visualize/Individual/view_task.dart';
import '../../../Models/user_model.dart';


class ViewDirectoryPage extends StatefulWidget {
  final UserModel user;
  final int directoryIndex;
  const ViewDirectoryPage({required this.user,required this.directoryIndex,Key? key}) : super(key: key);

  @override
  State<ViewDirectoryPage> createState() => _ViewDirectoryPageState();
}

class _ViewDirectoryPageState extends State<ViewDirectoryPage>{
  final _database = FirebaseFirestore.instance;
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  late final _index = widget.directoryIndex;
  late final _directory = _user.directories.elementAt(_index);
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
                children: [ElevatedButton(
                  onPressed: () { Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskPage(user: _user,directory: _index,),
                ),
              );},
              style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              backgroundColor: MaterialStateProperty.all(utilities.returnColorByTheme(_user.theme)), // <-- Button color
              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) return Colors.red;
              return null; // <-- Splash color
              }),
              ),
              child: const Icon(Icons.add),
              ),
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
                              vertical: 120
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const SizedBox(height: 30),
                              Text(
                                _directory.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),FutureBuilder<List<TaskModel>>(
                                future:  _getItems(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    print('Error fetching recipes: ${snapshot.error}');
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    if (_directory.tasks.isNotEmpty) {
                                      return ListView.builder(
                                        itemCount: _directory.tasks.length,
                                        itemBuilder: (context, index) {
                                          return _buildTaskItem(_directory.tasks.elementAt(index));
                                        },
                                      );
                                    } else {
                                      return const Text('No recipes found.');
                                    }
                                  }
                                },
                              ),
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

  Future<List<TaskModel>> _getItems() async {
    setState(() {});
    return _directory.tasks;
  }

  _buildTaskItem(TaskModel task) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: utilities.returnColorByTheme(_user.theme),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            task.name,
            style: const TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewTaskPage(user: _user, directoryIndex: _index, taskIndex: _directory.tasks.indexOf(task),),
              ),
            );
          }
      ),
    );
  }

  _deleteTask(String name) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("userDatabase")
        .where("Name", isEqualTo: _user.name)
        .get();

    // Check if there's a document with the given name
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document in the result (assuming there's only one match)
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      // Delete the document by its ID
      await FirebaseFirestore.instance.collection("userDatabase").doc(
          documentSnapshot.id).delete();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewDirectoryPage(user: _user,directoryIndex: _index),
        ),
      );
    }
  }

}


