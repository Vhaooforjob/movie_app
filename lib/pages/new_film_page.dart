import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app/pages/movie_detail_page.dart';

class NewFilmPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  NewFilmPage({required this.toggleTheme, required this.isDarkMode});

  @override
  _NewFilmPageState createState() => _NewFilmPageState();
}

class _NewFilmPageState extends State<NewFilmPage> {
  List<dynamic> movies = [];
  int currentPage = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool isGridView = false; // Default to ListView

  @override
  void initState() {
    super.initState();
    fetchMovies(currentPage);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMovies(int page) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://phimapi.com/danh-sach/phim-moi-cap-nhat?page=$page'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        movies.addAll(responseData['items']);
        currentPage++;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchMovies(currentPage);
    }
  }

  void _toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phim Mới Cập Nhật'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleView,
          ),
          IconButton(
            icon: Icon(
                widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: movies.length + 1, // +1 for loading indicator
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return _buildLoadingIndicator();
        } else {
          final movie = movies[index];
          return ListTile(
            title: Text(movie['name']),
            subtitle: Text(movie['origin_name']),
            leading: Image.network(
              movie['poster_url'],
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieDetailPage(movieSlug: movie['slug']),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        mainAxisSpacing: 5, // Vertical spacing between items
        crossAxisSpacing: 5, // Horizontal spacing between items
        childAspectRatio: 0.7, // Aspect ratio for each item
      ),
      itemCount: movies.length + 1, // +1 for loading indicator
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return _buildLoadingIndicator();
        } else {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieDetailPage(movieSlug: movie['slug']),
                ),
              );
            },
            child: GridTile(
              child: Image.network(
                movie['poster_url'],
                fit: BoxFit.cover,
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(movie['name']),
                subtitle: Text(movie['origin_name']),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : const SizedBox.shrink(),
    );
  }
}
