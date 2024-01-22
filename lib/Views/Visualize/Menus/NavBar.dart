import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:learnizer/Business/utilities_learnize.dart";
import "package:learnizer/Views/Edit/edit_directory.dart";
import "package:learnizer/Views/Visualize/Individual/view_directory.dart";
import "package:learnizer/Views/Visualize/Menus/user_menu.dart";
import "package:learnizer/Views/login_page.dart";

import "../../../Models/user_model.dart";

class NavBar extends StatefulWidget {
  final UserModel user;

  NavBar({required this.user, Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}
class _NavBarState extends State<NavBar>{
  final UtilitiesLearnizer utilities = UtilitiesLearnizer();
  late final user = widget.user;
  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: utilities.returnColorByTheme(user.theme),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                      user.profileImage,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: utilities.getCorrectColors(user.theme),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.white),
            title: Text("Logout",style: const TextStyle(color: Colors.white)),
            onTap: () => logout(context),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever,color: Colors.white),
            title: Text("Delete Account",style: const TextStyle(color: Colors.white)),
            onTap: () => _deleteAccount(),
          ),
          const SizedBox(height: 50),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text("Your Folders:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          ),
          buildFolderTiles(context)
        ],
      ),
    );
  }

  buildFolderTiles(BuildContext context){
    List<ListTile> tiles = [];
    for(int i=0;i<user.directories.length;i++){
      ListTile tile = ListTile(
        leading: Icon(
            Icons.folder,
            color: Colors.white,
        ),
        title: Text(user.directories.elementAt(i).name,style: const TextStyle(color: Colors.white)),
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
                          builder: (context) => EditDirectoryPage(user: user,directoryIndex: i),
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
                        user.directories.removeAt(i);
                        utilities.updateUserData(user);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserMenuPage(user: user),
                        ),
                      );
                    },
                  ),
                ]
            ),
        ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ViewDirectoryPage(user: user,directoryIndex: i)
            ),//
        ),
      );
      tiles.add(tile);
    }
    return Column(
      children: tiles,
    );
  }

  logout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(),
      ),//
    );
  }
  _deleteAccount(){
    utilities.deleteUserData(user);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()
      ),//
    );
  }
}
