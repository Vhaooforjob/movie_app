import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String url;
  final String episodeName;
  final String episodeFilename;
  final List<dynamic> episodes;

  VideoPlayerPage({
    required this.url,
    required this.episodeName,
    required this.episodeFilename,
    required this.episodes,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;
  bool _hasError = false;
  bool _isPlaying = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture =
        _initializeVideoPlayer(Uri.parse(widget.url));
  }

  Future<void> _initializeVideoPlayer(Uri uri) async {
    _controller = VideoPlayerController.network(
      uri.toString(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    try {
      await _controller.initialize();
      setState(() {});
      // // Thiết lập thời gian phát video về 1:00
      // await _controller.seekTo(const Duration(seconds: 60));
      // setState(() {});
    } catch (error) {
      setState(() {
        _hasError = true;
      });
      print('Video initialization error: $error');
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 15);
    _controller.seekTo(newPosition);
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 15);
    _controller.seekTo(newPosition);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_controller.value.isPlaying;
    });
  }

  void _showEpisodesList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Danh sách tập phim'),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: widget.episodes.length,
              itemBuilder: (context, index) {
                final episode = widget.episodes[index];
                return ListTile(
                  title: Text(episode['name']),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          url: episode['link_m3u8'],
                          episodeName: episode['name'],
                          episodeFilename: episode['filename'],
                          episodes: widget.episodes,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _playPreviousEpisode() {
    final currentIndex = widget.episodes
        .indexWhere((episode) => episode['link_m3u8'] == widget.url);
    if (currentIndex > 0) {
      final previousEpisode = widget.episodes[currentIndex - 1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            url: previousEpisode['link_m3u8'],
            episodeName: previousEpisode['name'],
            episodeFilename: previousEpisode['filename'],
            episodes: widget.episodes,
          ),
        ),
      );
    }
  }

  void _playNextEpisode() {
    final currentIndex = widget.episodes
        .indexWhere((episode) => episode['link_m3u8'] == widget.url);
    if (currentIndex != -1 && currentIndex < widget.episodes.length - 1) {
      final nextEpisode = widget.episodes[currentIndex + 1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            url: nextEpisode['link_m3u8'],
            episodeName: nextEpisode['name'],
            episodeFilename: nextEpisode['filename'],
            episodes: widget.episodes,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.episodes
        .indexWhere((episode) => episode['link_m3u8'] == widget.url);
    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(title: Text('Xem Phim')),
      body: Container(
        color: _isFullScreen ? Colors.black : Colors.transparent,
        child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (_hasError) {
                  return Center(
                    child: Text(
                      'Không thể phát video. Vui lòng thử lại sau.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                            _isPlaying = !_controller.value.isPlaying;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_controller),
                            if (_isPlaying && _isFullScreen)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.replay_10,
                                        color: Colors.white),
                                    onPressed: _seekBackward,
                                  ),
                                  if (!_controller.value.isPlaying)
                                    Icon(Icons.play_arrow,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 100),
                                  IconButton(
                                    icon: Icon(Icons.forward_10,
                                        color: Colors.white),
                                    onPressed: _seekForward,
                                  ),
                                ],
                              ),
                            if (!_isFullScreen && _isPlaying)
                              Positioned(
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            if (!_isFullScreen)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Phim đang xem: ${widget.episodeFilename}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (currentIndex > 0 && (!_isFullScreen || _isPlaying))
            TextButton.icon(
              icon: Icon(
                Icons.skip_previous,
                color: _isFullScreen
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              label: Text(
                'Tập trước',
                style: TextStyle(
                  color: _isFullScreen
                      ? Colors.white
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              onPressed: _playPreviousEpisode,
            ),
          if (currentIndex < widget.episodes.length - 1 &&
              (!_isFullScreen || _isPlaying))
            TextButton.icon(
              icon: Icon(
                Icons.skip_next,
                color: _isFullScreen
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              label: Text(
                'Tập tiếp theo',
                style: TextStyle(
                  color: _isFullScreen
                      ? Colors.white
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              onPressed: _playNextEpisode,
            ),
          if (!_isFullScreen || _isPlaying)
            IconButton(
              icon: Icon(
                Icons.playlist_play,
                color: _isFullScreen
                    ? null
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              color:
                  _isFullScreen ? Colors.white : Colors.white.withOpacity(0.7),
              onPressed: _showEpisodesList,
            ),
          // if (!_isFullScreen)
          //   IconButton(
          //     icon: Icon(
          //       _isPlaying ? Icons.pause : Icons.play_arrow,
          //       color: Colors.white,
          //     ),
          //     onPressed: _togglePlayPause,
          //   ),
          if (!_isFullScreen || _isPlaying)
            IconButton(
              icon: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: _isFullScreen
                    ? null
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              color:
                  _isFullScreen ? Colors.white : Colors.white.withOpacity(0.7),
              onPressed: _toggleMute,
            ),
          // if (!_isFullScreen) SizedBox(width: 10),
          if (!_isFullScreen || _isPlaying)
            IconButton(
              onPressed: _toggleFullScreen,
              icon: Icon(
                _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: _isFullScreen
                    ? null
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              color:
                  _isFullScreen ? Colors.white : Colors.white.withOpacity(0.7),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: VideoPlayerPage(
      url: 'https://www.example.com/video.mp4',
      episodeName: 'Episode 1',
      episodeFilename: 'episode1.mp4',
      episodes: [],
    ),
  ));
}
