import 'package:flutter/material.dart';
import 'package:movie_app/pages/feature_film_page.dart';
import 'package:movie_app/pages/series_film_page.dart';
import 'package:movie_app/pages/search_page.dart';

class DashboardPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const DashboardPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        actions: [
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
      body: GridView.count(
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
                    toggleTheme: toggleTheme,
                    isDarkMode: isDarkMode,
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
                    toggleTheme: toggleTheme,
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
