import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'get.dart';

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
    return switch (json) {
      {
        'id': int id,
        'name': String name,
      } =>
        Album(
          id: id,
          name: name,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
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
              onPressed: () {
                setState(() {
                  _futureAlbum = createAlbum(_controller.text);
                });
                _futureAlbum!.then((album) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAppGet()),
                  );
                }).catchError((error) {
                  // Handle error if necessary
                  print('Error creating album: $error');
                });
              },
              child: const Text('Create Data'),
            ),
          ],
        ),
      ),
    );
  }
}
