import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  bool isColorCirclesVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2.0,
        title: Text("Новая задача"),
      ),
      body: _buildContest(),
    );
  }

  Widget _buildContest() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.red,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          hintText: 'Текст новой задачи',
        ),
      ),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
      ),
      _buildExpandableColorCircleField(),
    ];
  }

  Column _buildExpandableColorCircleField() {
    return Column(
      children: <Widget>[
        buildColorCircles(),
      ],
    );
  }

  Widget buildColorCircles() {
    return !isColorCirclesVisible
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
        onTap: () => print("~~~> color ${myColor.toString()} tapped"),
        customBorder: CircleBorder(),
        child: Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: myColor,
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}
