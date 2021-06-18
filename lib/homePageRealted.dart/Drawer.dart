import 'package:cached_network_image/cached_network_image.dart';
import 'package:dominators/StorageDataBase.dart/database.dart';
import 'package:dominators/homePageRealted.dart/members.dart';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'package:dominators/Authentication.dart/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:dominators/TabBar2.dart/WallpaperChanger.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final AuthService auth = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance; // firebase instance
  String name;
  String profileUrl;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    var currentUserUid = _auth.currentUser.uid;
    StorageDataBase storageDataBase = StorageDataBase(uid: currentUserUid);
    var profile = await storageDataBase.profileDetails();
    print(profile.toString());
    print('fgjhhcjjkgjgjkjj');
    setState(() {
      name = profile['name'];
      print(name);
      profileUrl = profile['profileUrl'];
      print(profileUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    var wallpaperProvider = Provider.of<WallpaperChanger>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profileUrl != null
                          ? CachedNetworkImageProvider(
                              profileUrl,
                            )
                          : AssetImage(
                              'assets/none_profile.jpg',
                            ),
                    ),
                    name != null ? Text('AmitKumar') : Text('unknown'),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, Profile.id);
            },
          ),
          ListTile(
            title: Text('members'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Members()));
            },
          ),
          ListTile(
            title: Text('Theme'),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('Select Theme'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            ThemeProvider.controllerOf(context)
                                .setTheme('dark');
                          },
                          child: Text('Dark'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            ThemeProvider.controllerOf(context)
                                .setTheme('light');
                          },
                          child: Text('Light'),
                        ),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            title: Text('BackgroundColor'),
            onTap: () async {
              await await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('Select Theme'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            wallpaperProvider.setWallpaper(Colors.redAccent);
                            Navigator.pop(context);
                          },
                          child: Text('redAccent'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            wallpaperProvider.setWallpaper(Colors.white);
                            Navigator.pop(context);
                          },
                          child: Text('white'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            wallpaperProvider.setWallpaper(Colors.lightBlue);
                            Navigator.pop(context);
                          },
                          child: Text('light Blue'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            wallpaperProvider.setWallpaper(Colors.purple[300]);
                            Navigator.pop(context);
                          },
                          child: Text('light purple'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            wallpaperProvider.setWallpaper(Colors.green);
                            Navigator.pop(context);
                          },
                          child: Text('Green'),
                        ),
                      ],
                    );
                  });
            },
          ),
          SizedBox(
            height: 300,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async {
              await auth.signout();
            },
          ),
        ],
      ),
    );
  }
}
