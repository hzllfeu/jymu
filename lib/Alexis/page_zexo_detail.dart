import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String muscles;
  final num weight;
  final num duration;
  final String type;
  final num muscleRate;
  final String description;
  final String imageUrl;
  final String videoUrl;

  const ExerciseDetailPage({
    Key? key,
    required this.id,
    required this.name,
    required this.muscles,
    required this.weight,
    required this.duration,
    required this.type,
    required this.muscleRate,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late VideoPlayerController _videoController;
  bool _isVideoPlaying = true;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _onVideoTap() {
    setState(() {
      if (_isVideoPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                children: [
                  // Video Player
                  GestureDetector(
                    onTap: _onVideoTap,
                    child: _videoController.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  // Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        widget.imageUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Muscles travaillés: ${widget.muscles}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Poids utilisé: ${widget.weight} kg',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Durée de l\'exercice: ${widget.duration} secondes',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Type d\'exercice: ${widget.type}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Taux de musculation: ${widget.muscleRate}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Description: ${widget.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
