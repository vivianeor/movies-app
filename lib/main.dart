import 'package:films/data/poster_request.data.dart';
import 'package:films/model/movies_and_series.model.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Filmes e séries teste'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              // metodo para mostrar o search bar
              showSearch(
                  context: context,
                  delegate: Search()
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                      var title = film?.results?[index].title;
                      return Column(
                        children: [
                          SizedBox(
                              height: 140,
                              width: 220,
                              child:
                              imageUrl == null ? Container() :
                              Image(
                                fit: BoxFit.cover, image: NetworkImage('https://image.tmdb.org/t/p/original/$imageUrl'),
                              )
                          ),
                          Text(
                            //se vier nulo da api não mostra nada
                            title ?? '',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      );
                    },
                );
              } else if (snapshot.hasError){
                return const Center(child: Icon(Icons.refresh));
              }
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Search extends SearchDelegate {

  //limpa a busca
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // fecha o search quando clica no icone x
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // mostra os resultados da busca
  @override
  Widget buildResults(BuildContext context) {
    final PosterRequest _posterRequest = PosterRequest();
    return  FutureBuilder<MoviesAndSeriesModel>(
      future: _posterRequest.getSearchMoviesAndSeries(query),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          MoviesAndSeriesModel? film = snapshot.data;
          return Container(
            color: Colors.black,
            child: GridView.builder(
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
            ),
          );
        } else if (snapshot.hasError){
          return const Center(child: Icon(Icons.refresh));
        }
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 5,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text('pesquise algum filme ou série!', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
