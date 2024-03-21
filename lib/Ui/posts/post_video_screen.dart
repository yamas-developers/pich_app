import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostVideoScreen extends StatefulWidget {
  static const routeName = '/post_video_screen';

  @override
  State<PostVideoScreen> createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  String url = '';

  @override
  void didChangeDependencies() {
    String link = ModalRoute.of(context)!.settings.arguments as String;

    setState(() {
      url = link;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/icons/back-arrow.png",
              scale:2.8,
              color: Colors.white,
            )),
        title: const Text('Video'),
        backgroundColor: kprimaryColor,
      ),
      body: (url != '' || url != null)
          ? _VideoSpace(url: url)
          : Center(
              child: Text('No video found!'),
            ),
    );
  }
}


class _VideoSpace extends StatefulWidget {
  _VideoSpace({required this.url});

  final String url;

  @override
  _VideoSpaceState createState() => _VideoSpaceState();
}

class _VideoSpaceState extends State<_VideoSpace> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(false);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('url: ${widget.url}');
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  // VideoProgressIndicator(_controller, allowScrubbing: true,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
  ];

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    print('here: ${widget.controller.value.position.inMilliseconds}');
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? widget.controller.value.isBuffering
                  ? Center(
                      child: ColorCircularProgressIndicator(
                        showMessage: false,
                        height: 40,
                        width: 40,
                        stroke: 4,
                      ),
                    )
                  : const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: widget.controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              widget.controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed
                    in _ControlsOverlay._examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    '${widget.controller.value.playbackSpeed}x',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 38.0, left: 8),
            child: Text(
              '${getTime(widget.controller.value.position)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 38.0, right: 8),
            child: Text(
              '${getTime(widget.controller.value.duration)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (widget.controller.value.duration.inMilliseconds > 0)
          Positioned(
              bottom: 0,
              child: SizedBox(
                width: getWidth(context),
                child: Slider(
                  activeColor: kprimaryColor,
                  value: widget.controller.value.position.inMilliseconds
                      .toDouble(),
                  max: widget.controller.value.duration.inMilliseconds
                      .toDouble(),
                  // divisions: 5,
                  label: (widget.controller.value.position.inMilliseconds /
                          widget.controller.value.duration.inMilliseconds)
                      .round()
                      .toString(),
                  onChanged: (double value) {
                    widget.controller
                        .seekTo(Duration(milliseconds: value.toInt()));
                  },
                ),
              )),
      ],
    );
  }

  getTime(Duration duration) {
    String nowTime = [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
    return nowTime;
  }
}
