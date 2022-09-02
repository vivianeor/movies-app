import 'package:films/data/poster_request.data.dart';
import 'package:films/model/poster.model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PosterRequest _posterRequest = PosterRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Poster>(
          future: _posterRequest.getPosterPath(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              Poster? film = snapshot.data;
              return GridView.builder(
                  itemCount: film?.results?.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index){
                    var imageUrl = film?.results?[index].posterPath;
                    return SizedBox(
                        height: 140,
                        width: 220,
                        child:
                        imageUrl == null ? Container() :
                        Image(
                          fit: BoxFit.cover, image: NetworkImage('https://image.tmdb.org/t/p/original/$imageUrl'),
                        )
                    );
                  },
              );
            } else if (snapshot.hasError){
              return const Icon(Icons.refresh);
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            );
          },
        ),
      ),
    );
  }
}
