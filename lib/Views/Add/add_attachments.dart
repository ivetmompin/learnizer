
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnizer/Business/utilities_learnize.dart';
import 'package:learnizer/Views/Add/add_task.dart';
import 'package:learnizer/Views/Edit/edit_task.dart';
import '../../Models/user_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class AddAttachmentsPage extends StatefulWidget {
  final UserModel user;
  final int directoryIndex;
  final int taskIndex;
  final String origin;
  const AddAttachmentsPage({required this.user,required this.directoryIndex, required this.taskIndex, required this.origin, Key? key}) : super(key: key);

  @override
  State<AddAttachmentsPage> createState() => _AddAttachmentsPageState();
}

class _AddAttachmentsPageState extends State<AddAttachmentsPage>{
  final double coverHeight = 210;
  final double profileHeight = 144;
  late final _user = widget.user;
  late final _directoryIndex = widget.directoryIndex;
  late final _taskIndex = widget.taskIndex;
  late final _origin = widget.origin;
  String textDirectory = '';
  UtilitiesLearnizer utilities = UtilitiesLearnizer();
  String imageUrlLogo='';
  String imageUrlTask='';
  String? errorMessage;
  // This widget is the root of your application.
  Future<String> getThemeFromUtilities(String file, String caseImg) async {
    String imageUrl = await utilities.getTheme(file);
    if (caseImg == "cover") {
      imageUrlTask = imageUrl;
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
            getThemeFromUtilities("learnizer.png","logo"),
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
                                      if(_origin=="add") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddTaskPage(user: _user,
                                                    directory: _directoryIndex),
                                          ),
                                        );
                                      }else{
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditTaskPage(user: _user,
                                                    directoryIndex: _directoryIndex,taskIndex: _taskIndex),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ]
                            ),
                            Text(
                              "Add Attachment",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                buildAddAttachmentFromGallery(),
                                buildAddAttachmentFromCamera()
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Your Attachments",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 30),
                            for(int i=0;i<_user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).attachments.length;i++)
                              buildTile(_user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).attachments.elementAt(i),i)
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

  buildAddAttachmentFromCamera() {
    return Container(
      margin: EdgeInsets.only(left: 30),
        padding: const EdgeInsets.only(top: 25),
        child: SizedBox(
          width: 150,
          child: OutlinedButton(
            onPressed: () async {
              _addAttachment(await utilities.pickImageFromGalleryOrCamera("camera"));
            },
            style: OutlinedButton.styleFrom(
              // Customize the button style here
              side: const BorderSide(width: 2, color: Colors.white),
              foregroundColor: Colors.white, // Text color// Elevation (shadow)
            ),
            child: const Text('CAMERA',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        )
    );
  }
  buildAddAttachmentFromGallery() {
    return Container(
        padding: const EdgeInsets.only(top: 25),
        child: SizedBox(
          width: 150,
          child: OutlinedButton(
            onPressed: () async {
              _addAttachment(await utilities.pickImageFromGalleryOrCamera("gallery"));
            },
            style: OutlinedButton.styleFrom(
              // Customize the button style here
              side: const BorderSide(width: 2, color: Colors.white),
              foregroundColor: Colors.white, // Text color// Elevation (shadow)
            ),
            child: const Text('GALLERY',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        )
    );
  }

  _addAttachment(String attachment) async {
    if (errorMessage == null) {
      try {
        setState((){
          _user.directories.elementAt(_directoryIndex).tasks.elementAt(_taskIndex).attachments.add(attachment);
          utilities.updateUserData(_user);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAttachmentsPage(user: _user,directoryIndex: _directoryIndex, taskIndex: _taskIndex, origin: _origin,),
            ),
          );
        });
      } catch (e) {
        setState(() {
          errorMessage = 'An error occurred: $e';
        });
      }
    }
  }

}

