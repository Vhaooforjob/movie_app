import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String url;
  final String episodeName;
  final String episodeFilename;

  VideoPlayerPage({
    required this.url,
    required this.episodeName,
    required this.episodeFilename,
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

  @override
  Widget build(BuildContext context) {
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
        children: [
          if (!_isFullScreen)
            // IconButton(
            //   onPressed: () {
            //     setState(() {
            //       if (_controller.value.isPlaying) {
            //         _controller.pause();
            //       } else {
            //         _controller.play();
            //       }
            //       _isPlaying = !_controller.value.isPlaying;
            //     });
            //   },
            //   icon: Icon(
            //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            //   ),
            //   color: Colors.black,
            // ),
            if (!_isFullScreen) SizedBox(width: 10),
          IconButton(
              onPressed: _toggleFullScreen,
              icon: Icon(
                _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: _isFullScreen ? null : Colors.black,
              ),
              color:
                  _isFullScreen ? Colors.white : Colors.white.withOpacity(0.7)),
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
    ),
  ));
}
