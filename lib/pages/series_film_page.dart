import 'package:flutter/material.dart';
import 'package:movie_app/configs/config.dart';
import 'package:movie_app/pages/movie_detail_page.dart';

class SeriesFilmPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  SeriesFilmPage({required this.toggleTheme, required this.isDarkMode});

  @override
  _SeriesFilmPageState createState() => _SeriesFilmPageState();
}

class _SeriesFilmPageState extends State<SeriesFilmPage> {
  List<dynamic> movies = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Map<String, dynamic> responseData =
          await fetchAPI(configApi.APItelevisionSeries);
      setState(() {
        movies = responseData['data']['items'];
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phim Bộ'),
        actions: [
          // IconButton(
          //   icon: Icon(
          //       widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
          //   onPressed: widget.toggleTheme,
          // ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(movies[index]['name']),
                  subtitle: Text(movies[index]['origin_name']),
                  leading: Image.network(
                    configApi.APIImageFilm + movies[index]['poster_url'],
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(movieSlug: movies[index]['slug']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
