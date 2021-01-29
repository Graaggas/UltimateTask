import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_task/misc/constants.dart';
import 'package:ultimate_task/misc/converts.dart';
import 'package:ultimate_task/screens/home_screen/models/task.dart';
import 'package:ultimate_task/service/database.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  final Database database;

  const AddTaskPage({Key key, this.database}) : super(key: key);

  //* контекст берется из taskPage, потому как show запускается именно оттуда.
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String uid = '';
  bool isColorCirclesVisible = false;
  Color currentColor = Colors.white;

  Timestamp doingDate = Timestamp.fromDate(DateTime.now());
  Timestamp creationDate = Timestamp.fromDate(DateTime.now());
  Timestamp lastEditDate = Timestamp.fromDate(DateTime.now());

  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  String _memo;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(String uid) async {
    if (_validateAndSaveForm()) {
      final task = Task(
        color: convertColorToString(currentColor),
        creationDate: Timestamp.fromDate(DateTime.now()),
        doingDate: selectedDate == DateTime.now()
            ? Timestamp.fromDate(DateTime.now())
            : Timestamp.fromDate(selectedDate),
        id: uid,
        isDeleted: false,
        lastEditDate: Timestamp.fromDate(DateTime.now()),
        memo: _memo,
        outOfDate: false,
      );

      print(
          "saving doingDate:\t ${convertFromTimeStampToString(task.doingDate)}");
      await widget.database.createTask(task);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    uid = Uuid().v4();
    // selectedDate = convertFromTimeStampToString(doingDate);

    super.initState();
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
        print("==> selectedDate = $selectedDate");
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(myBackgroundColor),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: Color(myBackgroundColor),
        title: Text(
          "Новая задача",
          style: GoogleFonts.alice(
            textStyle: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () => selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.save, color: Colors.black),
            onPressed: () => _submit(uid),
          ),
        ],
      ),
      body: _buildContest(),
    );
  }

  Widget _buildContest() {
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
            children: [],
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
