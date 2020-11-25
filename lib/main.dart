import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  Future<List<Joke>> _getJokes() async {
    var data =
        await http.get("https://api.chucknorris.io/jokes/search?query=cats");

    var jsonData = json.decode(data.body);

    List<Joke> jokes = [];

    for (var joke in jsonData["result"]) {
      Joke newJoke = Joke(joke["created_at"], joke["icon_url"], joke["id"],
          joke["url"], joke["value"]);
      jokes.add(newJoke);
    }

    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getJokes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].iconUrl
                        ),
                      ),
                      title: Text(snapshot.data[index].createdAt),
                      subtitle: Text(snapshot.data[index].value),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class Joke {
  final String createdAt;
  final String iconUrl;
  final String id;
  final String url;
  final String value;

  Joke(this.createdAt, this.iconUrl, this.id, this.url, this.value);
}
