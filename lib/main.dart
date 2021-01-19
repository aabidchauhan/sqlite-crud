import 'package:flutter/material.dart';
import 'package:sqlite_crud/models/contact.dart';
import 'package:sqlite_crud/utils/database_helper.dart';

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
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

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

  _refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContact();
    setState(() {
      _contacts = x;
    });
  }

  //Button function
  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      await _dbHelper.insertContact(_contact);
      _refreshContactList();
      form.reset();
    }
  }

  //List function
  _list() => Expanded(
          child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blueGrey,
                    size: 40.0,
                  ),
                  title: Text(
                    _contacts[index].name,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _contacts[index].mobile,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Divider(
                  height: 5,
                ),
              ],
            );
          },
          itemCount: _contacts.length,
        ),
      ));
}
