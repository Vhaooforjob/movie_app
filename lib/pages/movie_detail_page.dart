import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_player_page.dart';

class MovieDetailPage extends StatefulWidget {
  final String movieSlug;

  MovieDetailPage({required this.movieSlug});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Map<String, dynamic>? movieDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http
        .get(Uri.parse('https://phimapi.com/phim/${widget.movieSlug}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        movieDetails = responseData;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phim'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : movieDetails != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(movieDetails!['movie']['poster_url']),
                        SizedBox(height: 8),
                        Text(
                          movieDetails!['movie']['name'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Tên gốc: ${movieDetails!['movie']['origin_name']}'),
                        Text('Thời lượng: ${movieDetails!['movie']['time']}'),
                        Text('Tình trạng: ${movieDetails!['movie']['status']}'),
                        Text(
                            'Diễn viên: ${movieDetails!['movie']['actor'].join(', ')}'),
                        Text(
                            'Đạo diễn: ${movieDetails!['movie']['director'].join(', ')}'),
                        SizedBox(height: 16),
                        Text(
                          movieDetails!['movie']['content'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Danh sách tập phim',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            childAspectRatio: 3, // Aspect ratio for the items
                            crossAxisSpacing: 8.0, // Space between columns
                            mainAxisSpacing: 8.0, // Space between rows
                          ),
                          itemCount: movieDetails!['episodes'][0]['server_data']
                              .length,
                          itemBuilder: (context, index) {
                            final episode = movieDetails!['episodes'][0]
                                ['server_data'][index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerPage(
                                        url: episode['link_m3u8'],
                                        episodeName: episode['name'],
                                        episodeFilename: episode['filename'],
                                        episodes: movieDetails!['episodes'][0]
                                            ['server_data'],
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      episode['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('Không tìm thấy thông tin phim')),
    );
  }
}
