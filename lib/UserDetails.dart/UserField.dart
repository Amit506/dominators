import 'package:flutter/material.dart';


class UserField extends StatelessWidget {
  final text;
  final Function(String) onChanging;
  final IconData icon;
  UserField({this.text, this.onChanging,this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: TextField(
            
        onChanged: (value) {
          onChanging(value);
        },
        style: TextStyle(
          color: Colors.black,
        ),
        autocorrect: true,
        decoration: InputDecoration(
        
                  labelText: text,
        prefixIcon: Icon(icon),
          labelStyle: TextStyle(
            color: Colors.black38,
          ),
          hintText: text,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          filled: true,
          fillColor: Colors.white30,
          hintStyle: TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          )
        ),
      ),
    );
  }
}
