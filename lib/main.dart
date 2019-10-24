import 'package:flutter/material.dart';
import 'package:flutter_movies/Movies.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp(movie : getJson()));
class MyApp extends StatelessWidget {
  final Future<Movies> movie;


  MyApp({Key key, this.movie }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
        ),
        body: FutureBuilder<Movies>(
          future: movie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return ListView.builder(
                itemCount: snapshot.data.results.length,
                itemBuilder: (context, pos){

                  return _buildRow(context,snapshot.data.results[pos],snapshot.data.results[pos].posterPath);
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            else{
              return CircularProgressIndicator();
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Widget _buildRow(BuildContext context, Result r , String s) {
  return new
  GestureDetector(
    onTap: () {

      // setState(() { _lights = true; });
      Navigator.push(context, MaterialPageRoute(builder: (context) => Details(result: r)));
    },

    child: Card(
      child: Row(

        children: <Widget>[
          Hero(
            tag: r,
            child: new Container(
              width:100.0,
              height:100.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage("http://image.tmdb.org/t/p/w185"+ s),

                ),
              ),
            ),
          ),
          Flexible (child: Center(child: Text(r.title))
          )

        ],
      ),
    ),
  );
}

class Details extends StatelessWidget {
  final Result result;
  Details({Key key, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detaiils Screen"),
      ),
      body: Center (
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: result,
                child: new Container(
                  width:300.0,
                  height:200.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage("http://image.tmdb.org/t/p/w185"+ result.posterPath),

                    ),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Center(child: Text(result.overview))
            ),


          ],
        ),
      ),
    );
  }
}

Future <Movies> getJson() async {
  final response = await http.get('http://api.themoviedb.org/3/discover/movie?sort_by=popularity.%20desc&api_key=01ac78788949fdb1f45c9eaf54e189e6');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return moviesFromJson(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

