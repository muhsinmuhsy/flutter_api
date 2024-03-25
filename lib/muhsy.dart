import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String name) async {
  final response = await http.post(
    Uri.parse('http://custompythonapi.pythonanywhere.com/category/add'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String name;

  const Album({required this.id, required this.name});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CreateDataPage(),
      routes: {
        '/get': (context) => GetDataPage(),
      },
    );
  }
}

class CreateDataPage extends StatefulWidget {
  const CreateDataPage({Key? key}) : super(key: key);

  @override
  _CreateDataPageState createState() => _CreateDataPageState();
}

class _CreateDataPageState extends State<CreateDataPage> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Data Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter Title'),
          ),
          ElevatedButton(
            onPressed: () async {
              final futureAlbum = createAlbum(_controller.text);
              setState(() {
                _futureAlbum = futureAlbum;
              });
              final album = await futureAlbum;
              if (album != null) {
                Navigator.pushNamed(context, '/get');
              }
            },
            child: const Text('Create Data'),
          ),
        ],
      ),
    );
  }
}

class GetDataPage extends StatelessWidget {
  const GetDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Data Page'),
      ),
      body: Center(
        child: const Text('This is the Get Data Page'),
      ),
    );
  }
}
