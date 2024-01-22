import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Models/directory_model.dart';
import 'package:learnizer/Models/task_model.dart';
import 'package:learnizer/Views/Add/add_task.dart';
import 'package:learnizer/Views/Visualize/Individual/view_task.dart';
import '../../../Models/user_model.dart';
import '../../Edit/edit_task.dart';
import '../Menus/user_menu.dart';


class ViewDirectoryPage extends StatefulWidget {
  final UserModel user;
  final int directoryIndex;
  const ViewDirectoryPage({required this.user,required this.directoryIndex,Key? key}) : super(key: key);

  @override
  State<ViewDirectoryPage> createState() => _ViewDirectoryPageState();
}

class _ViewDirectoryPageState extends State<ViewDirectoryPage>{
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  late final _index = widget.directoryIndex;
  late DirectoryModel _directory = _user.directories.elementAt(_index);
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlCover='';
  final controllerSearch = TextEditingController();
  String? errorMessage;
  // This widget is the root of your application.

  Future<String> getThemeFromUtilities(String file) async {
    String imageUrl = await utilities.getTheme(file);
    imageUrlLogo = imageUrl;
    return imageUrl;
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
            getThemeFromUtilities("learnizer.png"),
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
                          colors: utilities.getCorrectColors(_user.theme),
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
                                              builder: (context) => UserMenuPage(user: _user),
                                            ),
                                          );
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        weight: 9,
                                        size: 30, // Set the size of the icon to make it bigger
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddTaskPage(user: _user,directory: _index,),
                                          ),
                                        );
                                      },
                                    ),
                              ]
                            ),
                            buildSearchBox(),
                            Text(
                              _user.directories.elementAt(_index).name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 30),
                            buildTileList()
                          ],
                        )
                    )
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column buildTileList(){
    List<Widget> tiles = [];
    if(controllerSearch.text.isNotEmpty) {
      for (TaskModel task in _user.directories.elementAt(_index).tasks) {
        if (task.name.contains(controllerSearch.text)) {
          tiles.add(buildTile(task, _user.directories.elementAt(_index).tasks.indexOf(task)));
        }
      }
    }else{
      for (TaskModel task in _user.directories.elementAt(_index).tasks) {
          tiles.add(buildTile(task, _user.directories.elementAt(_index).tasks.indexOf(task)));
      }
    }
    return Column(
      children: tiles,
    );
  }

  buildTile(TaskModel task, int index){
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTaskPage(user: _user,directoryIndex: _index,taskIndex: index,),
                ),
              );
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.transparent,
            leading: Icon(
                task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.white),
            title: Text(
              task.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                decoration: task.isDone? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.zero,
              height: 35,
              width: 100,
              child: Row(
                children:[
                  IconButton(
                    color: Colors.white,
                    iconSize: 18,
                    icon: Icon(Icons.edit),
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskPage(user: _user,directoryIndex: _index,taskIndex: index,),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    color: Colors.white,
                    iconSize: 18,
                    icon: Icon(Icons.delete),
                    onPressed:(){
                      setState(() {
                        int indexTask = _user.directories.elementAt(_index).tasks.indexOf(task);
                        _user.directories.elementAt(_index).tasks.removeAt(indexTask);
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

  buildSearchBox(){
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 40),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
          controller: controllerSearch,
          obscureText: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(Icons.search,color: utilities.returnColorByTheme(_user.theme), size: 20),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.grey),
          )
      ),
    );
  }

}


