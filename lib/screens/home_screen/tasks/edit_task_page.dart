import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/constants.dart';
import 'package:ultimate_task/misc/converts.dart';
import 'package:ultimate_task/misc/show_exception_dialog.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/screens/home_screen/tasks/color_circle_bloc.dart';
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

class EditTaskPage extends StatefulWidget {
  final Database database;
  final Task task;
  final ColorCircleBloc bloc;

  const EditTaskPage({Key key, this.database, this.task, this.bloc})
      : super(key: key);

  static Future<void> show(BuildContext context, {Task task}) async {
    final database = Provider.of<Database>(context, listen: false);
    final bloc = Provider.of<ColorCircleBloc>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EditTaskPage(database: database, task: task, bloc: bloc),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String uid = '';
  bool isColorCirclesVisible = false;
  Color currentColor = Colors.white;
  String _memo = "";
  bool isDeleted = false;
  bool outOfDate = false;
  Timestamp doingDate = Timestamp.fromDate(DateTime.now());
  Timestamp creationDate = Timestamp.fromDate(DateTime.now());
  Timestamp lastEditDate = Timestamp.fromDate(DateTime.now());

  @override
  void dispose() {
    _textController.dispose();
    //widget.bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      uid = widget.task.id;
      currentColor = Color(int.parse(widget.task.color));
      print("==> initState /edit_task/ currentColor = $currentColor");
      _memo = widget.task.memo;
      print("==>MEMO = ${widget.task.memo}");
      doingDate = widget.task.doingDate;
      creationDate = widget.task.creationDate;
      isDeleted = widget.task.isDeleted;
      currentColor = widget.task.color.toColor();
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(Color currentColor) async {
    if (_validateAndSaveForm()) {
      try {
        final tasks = await widget.database.tasksStream().first;
        final allUids = tasks.map((task) => task.id).toList();
        if (widget.task != null) {
          allUids.remove(widget.task.id);
          print(
              "==> _submit /edit_task/ currentColor = ${currentColor.toString()}");
          final newTask = Task(
            color: convertColorToString(currentColor),
            creationDate: creationDate,
            doingDate: doingDate,
            id: uid,
            isDeleted: isDeleted,
            lastEditDate: Timestamp.fromDate(DateTime.now()),
            memo: _memo,
            outOfDate: outOfDate,
          );
          print("==> _submit /edit_task/ newTask.color = ${newTask.color}");

          await widget.database.setTask(newTask);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("==> /edit_task/build");
    currentColor = Color(int.parse(widget.task.color));
    print("==> /edit_task/build currentColor = ${currentColor.toString()}");
    _textController.text = widget.task.memo;
    return Scaffold(
      backgroundColor: Color(myBackgroundColor),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: Color(myBackgroundColor),
        title: Text(
          widget.task == null ? "Новая задача" : "Редактирование",
          style: GoogleFonts.alice(
            textStyle: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: () => _submit(currentColor),
          ),
        ],
      ),
      body: buildContest(),
    );
  }

  StreamBuilder buildContest() {
    return StreamBuilder(
        initialData: false,
        stream: widget.bloc.colorCircleStream,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    _buildCardForMemo(snapshot.data),
                    _buildContainerWithColorCircles(snapshot.data),
                  ],
                ),
              ),
            ),
          );
        });
    // return SingleChildScrollView(
    //   child: Container(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8),
    //       child: Column(
    //         children: <Widget>[
    //           _buildCardForMemo(),
    //           _buildContainerWithColorCircles()
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Container _buildContainerWithColorCircles(bool flag) {
    print('==> flag is $flag');
    // return StreamBuilder(
    //     initialData: false,
    //     stream: widget.bloc.colorCircleStream,
    //     builder: (context, snapshot) {
    //       return snapshot.data == true
    //           ? Container(
    //               child: Card(
    //                 child: Text("11"),
    //               ),
    //             )
    //           : Container();
    //     });

    return flag
        ? Container(
            child: Card(
              elevation: 4,
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildExpandableColorCircleField(),
              ),
            ),
          )
        : Container();

    // !isColorCirclesVisible
    //     ? Container()
    //     : Container(
    //         child: Card(
    //           elevation: 4,
    //           color: Colors.white.withOpacity(0.9),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(16.0),
    //             child: _buildExpandableColorCircleField(),
    //           ),
    //         ),
    //       )
  }

  Card _buildCardForMemo(bool flag) {
    return Card(
      elevation: 8,
      color: Color(int.parse(widget.task.color)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
        child: _buildForm(flag),
      ),
    );
  }

  Widget _buildForm(bool flag) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(flag),
      ),
    );
  }

  List<Widget> _buildFormChildren(bool flag) {
    return [
      Row(
        children: [
          Icon(
            Icons.timer,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "21.12.2021",
            style: GoogleFonts.alice(
              textStyle: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      _buildTextFieldForMemo(),
      _buildArrowForExpanding(flag),
      // _buildExpandableColorCircleField(),
    ];
  }

  TextFormField _buildTextFieldForMemo() {
    return TextFormField(
      controller: _textController,
      keyboardType: TextInputType.multiline,
      validator: (value) => value.isNotEmpty ? null : 'Введите текст задачи...',
      maxLines: null,
      cursorColor: Colors.red,
      textAlign: TextAlign.justify,
      onSaved: (value) => _memo = value,
      decoration: InputDecoration.collapsed(
        hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        hintText: 'Текст новой задачи...',
      ),
    );
  }

  Container _buildArrowForExpanding(bool flag) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Создано: ${convertFromTimeStampToString(creationDate)}",
                style: GoogleFonts.alice(
                  textStyle: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              Text(
                "Изменено: ${convertFromTimeStampToString(doingDate)}",
                style: GoogleFonts.alice(
                  textStyle: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
          !flag
              ? IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    print("==> try to sink .visible");
                    widget.bloc.eventColorCircleSink
                        .add(ColorCircleEvent.visible);
                    // setState(() {
                    //   isColorCirclesVisible = !isColorCirclesVisible;
                    // });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    print("==> try to sink .invisible");
                    widget.bloc.eventColorCircleSink
                        .add(ColorCircleEvent.invisible);
                    // setState(() {
                    //   isColorCirclesVisible = !isColorCirclesVisible;
                    // });
                  },
                ),
        ],
      ),
    );
  }

  Column _buildExpandableColorCircleField() {
    return Column(
      children: <Widget>[
        buildColorCircles(),
      ],
    );
  }

  Widget buildColorCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        buildExpandedCircleColor(Colors.red[200]),
        buildExpandedCircleColor(Colors.amber[200]),
        buildExpandedCircleColor(Colors.blue[200]),
        buildExpandedCircleColor(Colors.cyan[200]),
        buildExpandedCircleColor(Colors.grey),
        buildExpandedCircleColor(Colors.white),
      ],
    );
  }

  Expanded buildExpandedCircleColor(Color myColor) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentColor = myColor;
            widget.task.color = convertColorToString(currentColor);
          });
        },
        customBorder: CircleBorder(),
        child: Container(
          height: 30,
          width: 50,
          //margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              color: myColor,
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}
