import 'package:flutter/material.dart';


class  WallpaperChanger with ChangeNotifier{                                                                                        

Color _color;
WallpaperChanger(){
   _color=  Colors.white;
}

void setWallpaper(Color color){
  _color = color;
  notifyListeners();
}
Color get color=>_color;

}