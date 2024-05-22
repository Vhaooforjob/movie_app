import 'package:flutter/material.dart';
import 'package:movie_app/pages/dashboard_page.dart';
import 'package:movie_app/pages/feature_film_page.dart';
import 'package:movie_app/pages/new_film_page.dart';
import 'package:movie_app/pages/profile_page.dart';
import 'package:movie_app/pages/search_page.dart';
import 'package:movie_app/pages/series_film_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
          isDarkMode: _isDarkMode), //bottom bar - page 1
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
              icon: Icon(Icons.home),
              title: Text("Trang chủ"),
              selectedColor: Colors.purple,
            ),
            // SalomonBottomBarItem(
            //   icon: Icon(Icons.movie_creation_sharp),
            //   title: Text("Phim lẻ"),
            //   selectedColor: Colors.pink,
            // ),
            SalomonBottomBarItem(
              icon: Icon(Icons.movie_creation_outlined),
              title: Text("Phim mới cập nhật"),
              selectedColor: Colors.pink,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Icon(Icons.dashboard_outlined),
              title: Text("Danh mục"),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Tài khoản"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomePage({required this.toggleTheme, required this.isDarkMode});

  void pushSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchBarApp(
          toggleTheme: toggleTheme,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  void pushProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          toggleTheme: toggleTheme,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => pushSearch(context),
          ),
          // IconButton(
          //     icon: const Icon(Icons.person),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ProfilePage(
          //             toggleTheme: toggleTheme,
          //             isDarkMode: isDarkMode,
          //           ),
          //         ),
          //       );
          //     }),
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewFilmPage(
                      toggleTheme: toggleTheme,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
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
    );
  }
}
