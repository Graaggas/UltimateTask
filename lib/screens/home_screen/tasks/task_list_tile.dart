import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultimate_task/misc/constants.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class TaskListTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListTile({Key key, this.task, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "/task_list/ task.memo = ${task.memo}, task.color = ${(task.color).toString()}");
    return Card(
      elevation: 6,
      color: Color(int.parse(task.color)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Text(
                    "Срок выполнения: 21.12.2021",
                    style: GoogleFonts.alice(
                      textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  onTap: onTap,
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.done), onPressed: () {}),
                IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  task.memo,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: GoogleFonts.alice(
                    textStyle: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return ListTile(
    //   title: Text(task.memo),
    //   trailing: Icon(Icons.chevron_right),
    //   onTap: onTap,
    // );
  }
}
