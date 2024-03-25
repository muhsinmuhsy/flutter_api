import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbums() async {
  final response =
      await http.get(Uri.parse('https://api.escuelajs.co/api/v1/categories'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable<dynamic> data = jsonDecode(response.body);
    return List<Album>.from(data.map((albumJson) => Album.fromJson(albumJson)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load albums');
  }
}

class Album {
  final int id;
  final String name;
  final String imageUrl;
  final String creationAt;
  final String updatedAt;

  const Album(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.creationAt,
      required this.updatedAt});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image'],
        creationAt: json['creationAt'],
        updatedAt: json['updatedAt']);
  }
}

void main() => runApp(const MyAppGet());

class MyAppGet extends StatefulWidget {
  const MyAppGet({Key? key}) : super(key: key);

  @override
  State<MyAppGet> createState() => _MyAppGetState();
}

class _MyAppGetState extends State<MyAppGet> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbums,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        snapshot.data![index].imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(snapshot.data![index].name),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                print({snapshot.error});
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
