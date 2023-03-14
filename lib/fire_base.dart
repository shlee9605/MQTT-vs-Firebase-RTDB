import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyFirebasePage extends StatefulWidget {
  const MyFirebasePage({super.key, required this.title});

  final String title;

  @override
  State<MyFirebasePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyFirebasePage> {
  late DatabaseReference _databaseReference;
  int starttime = 0;
  int currenttime = 0;
  List<String> firebasedata = [];
  Map<String, dynamic>? jsonString;

  void deleteData() {
    _databaseReference = FirebaseDatabase.instance.ref();
    _databaseReference.remove();
  }

  Future<void> firebase() async {
    _databaseReference =
        FirebaseDatabase.instance.ref().child('TEST_Xarm6').child('data');

    // _databaseReference.once().then((event) {
    //   setState(() {
    //     DataSnapshot snapshot = event.snapshot;
    //     if (snapshot.value != null) {
    //       // add a null check
    //       _firebasedata = (snapshot.value as Map<dynamic, dynamic>)
    //           .values
    //           .map((data) => (data.toString()))
    //           .toList();
    //     }
    //   });
    // });

    _databaseReference.onValue.listen((event) {
      setState(() {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          jsonString = snapshot.value as Map<String, dynamic>;
          double time = double.parse(jsonString!.values.first['timestamp']);
          print(time);

          starttime = (time * 1000000).toInt();

          DateTime now = DateTime.now();
          currenttime = now.microsecondsSinceEpoch;

          print('start time : $starttime, current time : $currenttime');
          firebasedata[0] = (starttime - currenttime).toString();
          // jsonString = jsonDecode(hello);
          // print(jsonString!['timestamp']);

          // add a null check
          // _firebasedata = (snapshot.value as Map<String, dynamic>)
          //     .values
          //     .map((data) => (data as Map<String, dynamic>))
          //     .toList();
          // firebasedata[0] = jsonString!['timestamp'] as String;
        }
      });
    });
  }

  @override
  void initState() {
    firebasedata.add('start');
    firebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: firebasedata.map((data) {
          return ListTile(
            title: Text(data),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          deleteData();
        },
        tooltip: 'Delete',
        child: const Icon(Icons.delete),
      ),
    );
  }
}
