import 'package:flutter/material.dart';
import 'package:movie_app/pages/cartoon_page.dart';
import 'package:movie_app/pages/feature_film_page.dart';
import 'package:movie_app/pages/series_film_page.dart';
import 'package:movie_app/pages/search_page.dart';
import 'package:movie_app/pages/tvshows_page.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const DashboardPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isGridView = true;

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: toggleView,
          ),
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SearchBarApp(
          //           toggleTheme: toggleTheme,
          //           isDarkMode: isDarkMode,
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: isGridView ? buildGridView(context) : buildListView(context),
      // body: GridView.count(
      //   crossAxisCount: 2,
      //   children: [
      //     _buildCategoryButton(
      //       context,
      //       Icons.movie_creation_sharp,
      //       'Phim lẻ',
      //       () {
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
      //     ),
      //     _buildCategoryButton(
      //       context,
      //       Icons.movie_creation_outlined,
      //       'Phim bộ',
      //       () {
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
      //     ),
      //     _buildCategoryButton(
      //       context,
      //       Icons.movie_creation_outlined,
      //       'Phim TV',
      //       () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => TVShowPage(
      //               toggleTheme: toggleTheme,
      //               isDarkMode: isDarkMode,
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //     _buildCategoryButton(
      //       context,
      //       Icons.movie_creation_outlined,
      //       'Phim Hoạt hình',
      //       () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => CartoonPage(
      //               toggleTheme: toggleTheme,
      //               isDarkMode: isDarkMode,
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget buildGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        _buildCategoryButton(
          context,
          Icons.movie_creation_sharp,
          'Phim lẻ',
          () {
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
        _buildCategoryButton(
          context,
          Icons.movie_creation_outlined,
          'Phim bộ',
          () {
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
        _buildCategoryButton(
          context,
          Icons.movie_creation_outlined,
          'Phim TV',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TVShowPage(
                  toggleTheme: widget.toggleTheme,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            );
          },
        ),
        _buildCategoryButton(
          context,
          Icons.movie_creation_outlined,
          'Phim Hoạt hình',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartoonPage(
                  toggleTheme: widget.toggleTheme,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView(
      children: [
        _buildCategoryButton(
          context,
          Icons.movie_creation_sharp,
          'Phim lẻ',
          () {
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
        _buildCategoryButton(
          context,
          Icons.movie_creation_outlined,
          'Phim bộ',
          () {
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
        _buildCategoryButton(
          context,
          Icons.movie_creation_outlined,
          'Phim TV',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TVShowPage(
                  toggleTheme: widget.toggleTheme,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            );
          },
        ),
        _buildCategoryButton(
          context,
          Icons.movie_creation_outlined,
          'Phim Hoạt hình',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartoonPage(
                  toggleTheme: widget.toggleTheme,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, IconData icon, String label, Function() onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
