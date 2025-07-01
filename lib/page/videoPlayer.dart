import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.url});
  final String url;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    _loadVideoPlayer();
  }

  Future<void> _loadVideoPlayer() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => (),
          onPageStarted: (url) => (),
          onPageFinished: (url) => (),
          onHttpError: (error) => (),
          onWebResourceError: (error) => (),
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    if (widget.url.startsWith('lib/interface/')) {
      final videoUrl = widget.url.split('?url=')[1];
      final decodedVideoUrl = Uri.decodeComponent(videoUrl);
      await controller.loadFlutterAsset('lib/interface/src.html');
      await Future.delayed(const Duration(milliseconds: 1000));
      await controller.runJavaScript('''
        (function() {
          if (typeof initPlayer !== 'undefined') {
            initPlayer("$decodedVideoUrl");
          } else {
            setTimeout(function() {
              if (typeof initPlayer !== 'undefined') {
                initPlayer("$decodedVideoUrl");
              }
            }, 2000);
          }
        })();
      ''');
    } else {
      await controller.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: WebViewWidget(controller: controller),
    );
  }
}
