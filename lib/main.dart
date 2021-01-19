import 'package:flutter/material.dart';
import 'package:sqlite_crud/models/contact.dart';

const yellowColor = Color(0xff486579);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite CRUD',
      theme: ThemeData(
        primaryColor: yellowColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SQLite CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Contact _contact = Contact();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          widget.title,
          style: TextStyle(color: Colors.blueGrey),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),
            _list(),
          ],
        ),
      ),
    );
  }

  //form function
  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                onSaved: (val) => setState(() => _contact.name = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile'),
                onSaved: (val) => setState(() => _contact.mobile = val),
                validator: (val) =>
                    (val.length < 10 ? 'Atleast 10 digits required' : null),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () => _onSubmit(),
                  child: Text('Submit'),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  //Button function
  _onSubmit() {
    var form = _formKey.currentState;
    if (form.validate()) {
      //validation call
      form.save();
      print(_contact.name);
    }
  }

  //List function
  _list() => Container();
}
