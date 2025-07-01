import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freevideo/page/videoPlayer.dart';
import 'package:freevideo/page/videoSelector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  bool _showPlatformButtons = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'e.g. https://website.com/video?v=123456',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(_controller.text))) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        url:
                            "lib/interface/src.html?url=${Uri.encodeComponent(_controller.text)}",
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Invalid URL'),
                      );
                    },
                  );
                }
              },
              child: const Text('Play'),
            ),
            const Spacer(flex: 3),

            if (_showPlatformButtons)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildPlatformButton(context, "Douban"),
                    _buildPlatformButton(context, "MGTV"),
                    _buildPlatformButton(context, "Bilibili"),
                    _buildPlatformButton(context, "YouKu"),
                  ],
                ),
              ),
            const Spacer(flex: 1),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showPlatformButtons = !_showPlatformButtons;
          });
        },
        tooltip: 'Show Platforms',
        child: Icon(_showPlatformButtons ? Icons.close : Icons.video_library),
      ),
    );
  }

  Widget _buildPlatformButton(BuildContext context, String site) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _showPlatformButtons = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoSelector(site: site)),
        );
      },
      child: Text(site),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
