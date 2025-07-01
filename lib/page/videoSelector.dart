import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freevideo/page/videoPlayer.dart';

class VideoSelector extends StatefulWidget {
  const VideoSelector({super.key, required this.site});
  final String site;

  @override
  State<VideoSelector> createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<VideoSelector> {
  late WebViewController _controller;
  late String _url;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final String desktopUserAgent =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36';

    switch (widget.site) {
      case "Douban":
        _url = "https://movie.douban.com";
        break;
      case "MGTV":
        _url = "https://www.mgtv.com";
        break;
      case "Bilibili":
        _url = "https://www.bilibili.com";
        break;
      case "YouKu":
        _url = "https://www.youku.com";
        break;
      default:
        throw ErrorDescription("Unknown site.");
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(desktopUserAgent)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _isLoading = progress < 100);
          },
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _forceFitToScreen();
          },
          onHttpError: (error) {},
          onWebResourceError: (error) {},
          onNavigationRequest: (request) {
            if (request.url.startsWith('https://') ||
                request.url.startsWith('http://')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  void _forceFitToScreen() async {
    await _controller.runJavaScript('''
      const meta = document.createElement('meta');
      meta.name = 'viewport';
      meta.content = 'width=1920, initial-scale=1.0';
      document.head.appendChild(meta);
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Video Selector'),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                final video = await _controller.currentUrl();
                if (video != null && await canLaunchUrl(Uri.parse(video))) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        url:
                            "lib/interface/src.html?url=${Uri.encodeComponent(video)}",
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invaild URL'),
                      );
                    },
                  );
                }
              },
              child: Text("Select"),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
            gestureRecognizers: {
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
            }.toSet(),
          ),

          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
