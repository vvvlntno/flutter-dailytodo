import 'package:flutter/material.dart';

class TutorialWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ListTile(
              leading: Icon(Icons.note_add), 
              title: Text('Write your ToDos'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month), 
              title: Text('Look at your monthly completed ToDos'),
            ),
            ListTile(
              leading: Icon(Icons.keyboard_double_arrow_up), 
              title: Text('Track your progress in the monthly overview'),
            ),
            ListTile(
              leading: Icon(Icons.lock), 
              title: Text('Your Data gets only saved locally'),
            ),
            ListTile(
              leading: Icon(Icons.logo_dev), 
              title: Text('Made by vvvlntno@github'),
            ),
          ],
        ),
      );
  }
}