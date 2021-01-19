import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/constants.dart';
import 'package:ultimate_task/misc/converts.dart';
import 'package:ultimate_task/misc/show_exception_dialog.dart';
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

class EditTaskPage extends StatefulWidget {
  final Database database;
  final Task task;

  const EditTaskPage({Key key, this.database, this.task}) : super(key: key);

  static Future<void> show(BuildContext context, {Task task}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskPage(database: database, task: task),
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
  Timestamp doingDate = Timestamp.fromDate(DateTime.now());
  Timestamp creationDate = Timestamp.fromDate(DateTime.now());

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      uid = widget.task.id;
      _memo = widget.task.memo;
      print("==>MEMO = ${widget.task.memo}");
      doingDate = widget.task.doingDate;
      creationDate = widget.task.creationDate;
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

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final tasks = await widget.database.tasksStream().first;
        final allUids = tasks.map((task) => task.id).toList();
        if (widget.task != null) {
          allUids.remove(widget.task.id);
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
          widget.task == null ? "Новая задача" : "Редактирование задачи",
          style: GoogleFonts.alice(
            textStyle: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: () => _submit(),
          ),
        ],
      ),
      body: buildContest(),
    );
  }

  Widget buildContest() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              _buildCardForMemo(),
              _buildContainerWithColorCircles()
            ],
          ),
        ),
      ),
    );
  }

  Container _buildContainerWithColorCircles() {
    return !isColorCirclesVisible
        ? Container()
        : Container(
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
          );
  }

  Card _buildCardForMemo() {
    return Card(
      elevation: 8,
      color: currentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      _buildTextFieldForMemo(),
      _buildArrowForExpanding(),
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

  Container _buildArrowForExpanding() {
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
          !isColorCirclesVisible
              ? IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      isColorCirclesVisible = !isColorCirclesVisible;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    setState(() {
                      isColorCirclesVisible = !isColorCirclesVisible;
                    });
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
