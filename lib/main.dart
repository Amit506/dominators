import 'package:dominators/Authentication.dart/Register.dart';
import 'package:dominators/Authentication.dart/Signin.dart';
import 'package:dominators/HomePage.dart';
import 'package:dominators/UserDetails.dart/GetUserInfo.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'Authentication.dart/AuthService.dart';
import 'Authentication.dart/User.dart';
import 'Authentication.dart/AuthChecker.dart';
import 'homePageRealted.dart/Profile.dart';
import 'TabBar2.dart/WallpaperChanger.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.manageExternalStorage.request();

  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  await Permission.accessMediaLocation.request();
  await Permission.storage.request();
  await Permission.photosAddOnly.request();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Userr>.value(
      initialData: null,
      value: AuthService().user,
      child: ChangeNotifierProvider(
        create: (BuildContext context) => WallpaperChanger(),
        child: ThemeProvider(
          saveThemesOnChange: true,
          defaultThemeId: 'dark',
          themes: [
            AppTheme.light(id: 'light'),
            AppTheme.dark(id: 'dark'),
          ],
          child: ThemeConsumer(
            child: Builder(
              builder: (themeContext) => MaterialApp(
                theme: ThemeProvider.themeOf(themeContext).data,
                title: 'dominators',
                debugShowCheckedModeBanner: false,
                initialRoute: AuthChecker.id,
                routes: {
                  AuthChecker.id: (context) => AuthChecker(),
                  Signin.id: (context) => Signin(),
                  Register.id: (context) => Register(),
                  HomePage.id: (context) => HomePage(),
                  GetUserInfo.idd: (context) => GetUserInfo(),
                  Profile.id: (context) => Profile(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
