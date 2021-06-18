import 'package:dominators/Database.dart/Database.dart';
import 'package:dominators/NotificationScreen.dart';
import 'package:flutter/material.dart';
import 'TabBar1.dart/TabBar1Main.dart';
import 'Authentication.dart/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePageRealted.dart/Drawer.dart';
import 'TabBar2.dart/chatScreen.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomeScreen';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AuthService auth = AuthService();
  TabController _controller;
  ScrollController _scrollController;
  bool spinner = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    _controller = new TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
        initialData: null,
        value: DataBaseService().userDetails,
        child: _selectedIndex == 0
            ? Scaffold(
                resizeToAvoidBottomInset: false,
                body: NestedScrollView(
                  reverse: false,
                  headerSliverBuilder:
                      (BuildContext context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        centerTitle: true,
                        title: Hero(
                            tag: 'title',
                            child: Text(
                              'Dominators',
                              style:
                                  TextStyle(fontFamily: 'Bungee', fontSize: 27),
                            )),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NotificationScreen()));
                              },
                              icon: Icon(Icons.notification_important),
                            ),
                          )
                        ],
                        bottom: TabBar(
                          controller: _controller,
                          tabs: [
                            Tab(
                              child: Text('Feed'),
                            ),
                            Tab(
                              child: Text('Chat'),
                            )
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _controller,
                    children: [
                      TabBar1(),
                      ChatScreen(),
                    ],
                  ),
                ),
                drawer: SideDrawer(),
              )
            : Scaffold(
                drawer: SideDrawer(),
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        floating: false,
                        pinned: true,
                        centerTitle: true,
                        title: Hero(
                            tag: 'title',
                            child: Text(
                              'Dominators',
                              style:
                                  TextStyle(fontFamily: 'Bungee', fontSize: 27),
                            )),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NotificationScreen()));
                              },
                              icon: Icon(Icons.notification_important),
                            ),
                          )
                        ],
                        bottom: TabBar(
                          unselectedLabelColor: Colors.white,
                          controller: _controller,
                          tabs: [
                            Tab(
                              child: Text('Feed'),
                            ),
                            Tab(
                              child: Text('Chat'),
                            )
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _controller,
                    children: [
                      TabBar1(),
                      Center(
                        child: ChatScreen(),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
