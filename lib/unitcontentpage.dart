import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UnitContentPage extends StatefulWidget {
  final String unitTitle;
  final String unitDescription;
  final String pptUrl;
  final String videoUrl;

  UnitContentPage({
    required this.unitTitle,
    required this.unitDescription,
    required this.pptUrl,
    required this.videoUrl, required unitContent,
  });

  @override
  _UnitContentPageState createState() => _UnitContentPageState();
}

class _UnitContentPageState extends State<UnitContentPage> {
  bool isUnitCompleted = false;

  Future<void> _downloadPpt() async {
    if (await canLaunch(widget.pptUrl)) {
      await launch(widget.pptUrl);
    } else {
      // Handle the case where the file couldn't be opened.
      print('Could not launch the PPT file at ${widget.pptUrl}');
    }
  }

  Future<void> _playVideo() async {
    // Implement code to play the video tutorial
    // You can use video_player or other video playback packages.
    // Example code: launch(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.unitTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Unit Title: ${widget.unitTitle}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Description: ${widget.unitDescription}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Downloadable Files:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _downloadPpt,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.file_download,
                      size: 40,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Download PPT',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _playVideo,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.play_circle_filled,
                      size: 40,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Watch Video Tutorial',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isUnitCompleted,
                    onChanged: (value) {
                      setState(() {
                        isUnitCompleted = value!;
                      });
                    },
                  ),
                  Text(
                    'Mark as Completed',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
