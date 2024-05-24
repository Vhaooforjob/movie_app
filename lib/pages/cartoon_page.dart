import 'package:flutter/material.dart';
import 'package:movie_app/configs/config.dart';
import 'package:movie_app/pages/movie_detail_page.dart';

class CartoonPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const CartoonPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _CartoonPageState createState() => _CartoonPageState();
}

class _CartoonPageState extends State<CartoonPage> {
  List<dynamic> movies = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMoreMovies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMovies() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Map<String, dynamic> responseData =
          await fetchAPI(configApi.APIcartoon, page: currentPage);
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

  Future<void> fetchMoreMovies() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });
    try {
      currentPage++;
      final Map<String, dynamic> responseData =
          await fetchAPI(configApi.APIcartoon, page: currentPage);
      setState(() {
        movies.addAll(responseData['data']['items']);
        isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        isLoadingMore = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phim Hoạt hình'),
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
          : movies.isEmpty
              ? Center(child: Text('Không tìm thấy phim nào'))
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoadingMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      fetchMoreMovies();
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: movies.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == movies.length) {
                        return Center(child: CircularProgressIndicator());
                      }
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
                              builder: (context) => MovieDetailPage(
                                  movieSlug: movies[index]['slug']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
