import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app/configs/config.dart';
import 'package:movie_app/pages/dashboard_page.dart';
import 'package:movie_app/pages/feature_film_page.dart';
import 'package:movie_app/pages/new_film_page.dart';
import 'package:movie_app/pages/profile_page.dart';
import 'package:movie_app/pages/search_page.dart';
import 'package:movie_app/pages/series_film_page.dart';
import 'package:movie_app/pages/movie_detail_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  int _currentIndex = 0;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode,
          token: ''), //bottom bar - page 1
      // FeatureFilmPage(
      //     toggleTheme: _toggleTheme,
      //     isDarkMode: _isDarkMode), //bottom bar - page
      NewFilmPage(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode), //bottom bar - page 2
      DashboardPage(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode), //bottom bar - page 3
      ProfilePage(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode), //bottom bar - page 4
    ];
    return MaterialApp(
      title: 'Phim Mới Cập Nhật',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        hintColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        // appBar: AppBar(
        //     // title: Text('Trang Chủ'),
        //     // actions: [
        //     //   IconButton(
        //     //     icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
        //     //     onPressed: _toggleTheme,
        //     //   ),
        //     // ],
        //     ),
        body: _pages[_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Trang chủ"),
              selectedColor: Colors.purple,
            ),
            // SalomonBottomBarItem(
            //   icon: Icon(Icons.movie_creation_sharp),
            //   title: Text("Phim lẻ"),
            //   selectedColor: Colors.pink,
            // ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.movie_creation_outlined),
              title: const Text("Phim mới cập nhật"),
              selectedColor: Colors.pink,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              title: const Text("Danh mục"),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Tài khoản"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomePage(
      {required this.toggleTheme, required this.isDarkMode, required token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> _movies = [];
  late List<dynamic> _moviesSeries = [];
  late List<dynamic> _featureSeries = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
    _fetchMoviesSeries();
    _fetchMoviesFeature();
  }

  Future<void> _fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(configApi.APINewFilm));
      if (response.statusCode == 200) {
        setState(() {
          _movies = json.decode(response.body)['items'];
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchMoviesSeries() async {
    try {
      final Map<String, dynamic> responseData =
          await fetchAPI(configApi.APItelevisionSeries);
      setState(() {
        _moviesSeries = responseData['data']['items'];
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  Future<void> _fetchMoviesFeature() async {
    try {
      final Map<String, dynamic> responseData =
          await fetchAPI(configApi.APIfeatureFilm);
      setState(() {
        _featureSeries = responseData['data']['items'];
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  // void pushSearch(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SearchBarApp(
  //         toggleTheme: toggleTheme,
  //         isDarkMode: isDarkMode,
  //       ),
  //     ),
  //   );
  // }

  // void pushProfile(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ProfilePage(
  //         toggleTheme: toggleTheme,
  //         isDarkMode: isDarkMode,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trang Chủ'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchBarApp(
                    toggleTheme: widget.toggleTheme,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      toggleTheme: widget.toggleTheme,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
              },
            ),

            // IconButton(
            //   icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            //   onPressed: toggleTheme,
            // ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          carousel_slider.CarouselSlider.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final movie = _movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                        movieSlug: movie['slug'],
                      ),
                    ),
                  );
                },
                child: Container(
                  child: Stack(
                    children: [
                      Image.network(
                        movie['poster_url'],
                        width: 400,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: carousel_slider.CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewFilmPage(
                    toggleTheme: widget.toggleTheme,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Xem Danh Sách Phim Mới',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Phim Bộ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeriesFilmPage(
                              toggleTheme: widget.toggleTheme,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 180,
                  child: _moviesSeries.isEmpty
                      ? const Center(
                          child: Text('No TV series available'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _moviesSeries.length,
                          itemBuilder: (BuildContext context, int index) {
                            final moviesSeries = _moviesSeries[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movieSlug: moviesSeries['slug'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        configApi.APIImageFilm +
                                            moviesSeries['poster_url'],
                                        width: 100,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        moviesSeries['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Phim Lẻ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeatureFilmPage(
                              toggleTheme: widget.toggleTheme,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 180,
                  child: _moviesSeries.isEmpty
                      ? const Center(
                          child: Text('No video available'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _moviesSeries.length,
                          itemBuilder: (BuildContext context, int index) {
                            final featureSeries = _featureSeries[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movieSlug: featureSeries['slug'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        configApi.APIImageFilm +
                                            featureSeries['poster_url'],
                                        width: 100,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        featureSeries['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                ),
              ],
            ),
          ),
          // floatingActionButton: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     FloatingActionButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => FeatureFilmPage(
          //               toggleTheme: toggleTheme,
          //               isDarkMode: isDarkMode,
          //             ),
          //           ),
          //         );
          //       },
          //       tooltip: 'Phim Lẻ',
          //       child: Icon(Icons.movie),
          //     ),
          //     FloatingActionButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => SeriesFilmPage(
          //               toggleTheme: toggleTheme,
          //               isDarkMode: isDarkMode,
          //             ),
          //           ),
          //         );
          //       },
          //       tooltip: 'Phim Bộ',
          //       child: Icon(Icons.movie),
          //     )
          //   ],
          // ),
        ])));
  }
}
