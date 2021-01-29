import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/constants.dart';
import 'package:ultimate_task/misc/converts.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/service/database.dart';

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

class TaskListTile extends StatefulWidget {
  final Task task;
  final VoidCallback onTap;
  final BuildContext context;

  TaskListTile({Key key, this.task, this.onTap, this.context})
      : super(key: key);

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  DateTime selectedDate = DateTime.now();

  Future<void> _taskFlagDeleted(String uid) async {
    final database = Provider.of<Database>(context, listen: false);

    final taskNew = Task(
      color: widget.task.color,
      creationDate: widget.task.creationDate,
      doingDate: widget.task.doingDate,
      id: uid,
      isDeleted: true,
      lastEditDate: widget.task.lastEditDate,
      memo: widget.task.memo,
      outOfDate: widget.task.outOfDate,
    );

    print("flag: ${taskNew.isDeleted.toString()}");
    await database.createTask(taskNew);
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;

        final database = Provider.of<Database>(context, listen: false);

        final taskNew = Task(
          color: widget.task.color,
          creationDate: widget.task.creationDate,
          doingDate: Timestamp.fromDate(selectedDate),
          id: widget.task.id,
          isDeleted: false,
          lastEditDate: widget.task.lastEditDate,
          memo: widget.task.memo,
          outOfDate: widget.task.outOfDate,
        );

        print("newData: ${taskNew.doingDate.toString()}");
        database.createTask(taskNew);
      });

    print("/selectDate/\t selectedDate:\t $selectedDate");
    //widget.task.doingDate = Timestamp.fromDate(selectedDate);
    print(
        "/selectDate/\t task.doingDate:\t ${convertFromTimeStampToString(widget.task.doingDate)}");
  }

  @override
  Widget build(BuildContext context) {
    selectedDate = DateTime.fromMillisecondsSinceEpoch(
        widget.task.doingDate.millisecondsSinceEpoch * 1000);

    print(
        "/task_list/ task.doingDate = ${widget.task.doingDate}, selectedDate = $selectedDate");

    return Card(
      //margin: EdgeInsets.all(10),
      elevation: 6,
      color: Color(int.parse(widget.task.color)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/clock.svg',
                  color: Colors.black54,
                  height: 15,
                  width: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  convertFromTimeStampToString(widget.task.doingDate),
                  style: GoogleFonts.alice(
                    textStyle: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Spacer(),
                InkWell(
                  child: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    color: Colors.black54,
                    height: 20,
                    width: 20,
                  ),
                  onTap: () => selectDate(context),
                ),
                SizedBox(
                  width: 30,
                ),
                InkWell(
                  onTap: () => _taskFlagDeleted(widget.task.id),
                  // onTap: () => print("tapped"),
                  child: SvgPicture.asset(
                    'assets/icons/done.svg',
                    color: Colors.black54,
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                width: double.infinity,
                child: Text(
                  widget.task.memo,
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
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.only(left: 8, right: 8),
      //       child: Row(
      //         children: <Widget>[
      //           InkWell(
      //             child: Row(
      //               children: [
      //                 Icon(
      //                   Icons.timer,
      //                   size: 15,
      //                 ),
      //                 SizedBox(
      //                   width: 5,
      //                 ),
      //                 Text(
      //                   "21.12.2021",
      //                   style: GoogleFonts.alice(
      //                     textStyle:
      //                         TextStyle(color: Colors.black, fontSize: 14),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             onTap: onTap,
      //           ),
      //           Spacer(),
      //           IconButton(icon: Icon(Icons.done), onPressed: () {}),
      //           IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
      //         ],
      //       ),
      //     ),
      //     InkWell(
      //       onTap: onTap,
      //       child: Container(
      //         width: double.infinity,
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Text(
      //             task.memo,
      //             maxLines: 3,
      //             overflow: TextOverflow.fade,
      //             softWrap: true,
      //             style: GoogleFonts.alice(
      //               textStyle: TextStyle(color: Colors.black, fontSize: 18),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
    // return ListTile(
    //   title: Text(task.memo),
    //   trailing: Icon(Icons.chevron_right),
    //   onTap: onTap,
    // );
  }
}
