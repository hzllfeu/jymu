import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jymu/Alexis/get_exercise.dart';
import 'package:jymu/Alexis/get_processed.dart';
import 'package:jymu/Alexis/page_zexo_detail.dart'; // Import de la page de détails

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  Map<String, dynamic>? exercises;
  List<dynamic> exoClassement = [];
  List<dynamic> poidsClassement = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
    loadData();
  }

  void _loadExercises() {
    setState(() {
      exercises = ExerciseDataService.instance.getExercises();
      isLoading = false;
    });
  }

  void loadData() async {
    await ProcessedDataService.instance.fetchProcessedData();
    Map<String, dynamic>? processedData = ProcessedDataService.instance.getProcessedData();

    if (processedData != null) {
      setState(() {
        exoClassement = processedData['exo_classement'];
        poidsClassement = processedData['nouvelle_liste'];
      });
    }
  }

  Future<String> _getImageUrl(String id) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('exos_images_videos/$id.jpeg');
      return await storageRef.getDownloadURL();
    } catch (e) {
      return 'https://via.placeholder.com/150';
    }
  }

  Future<String> _getVideoUrl(String id) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('exos_images_videos/$id.mp4');
      return await storageRef.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || exoClassement.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Page'),
        ),
        body: const Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    if (exercises == null || exercises!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Page'),
        ),
        body: const Center(
          child: Text('Aucun exercice trouvé', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: exoClassement.length,
        itemBuilder: (context, index) {
          var id = exoClassement[index].toString();
          var exercise = exercises![id];

          return FutureBuilder<String>(
            future: _getImageUrl(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              String imageUrl = snapshot.data ?? 'https://via.placeholder.com/150';

              return GestureDetector(
                onTap: () async {
                  String videoUrl = await _getVideoUrl(id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailPage(
                        id: id,
                        name: exercise[0] ?? 'Exercice sans nom',
                        muscles: exercise[1] ?? 'Non spécifié',
                        weight: exercise[2] as num? ?? 0,
                        duration: exercise[3] as num? ?? 0,
                        type: exercise[4] ?? 'Non spécifié',
                        muscleRate: exercise[5] as num? ?? 0,
                        description: exercise[6] ?? 'Pas de description',
                        imageUrl: imageUrl,
                        videoUrl: videoUrl,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.withOpacity(0.8),
                            Colors.pinkAccent.withOpacity(0.8),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Aligner le pourcentage à droite
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${(poidsClassement[index] * 100).toStringAsFixed(1)}%', // Conversion en pourcentage avec deux décimales
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise[0] ?? 'Exercice sans nom',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/emoji_cible.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${exercise[1] ?? 'Non spécifié'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Intensité', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: (exercise[2] as num?)?.toDouble() ?? 0.0,
                                      minHeight: 10,
                                      backgroundColor: Colors.grey[100],
                                      color: Colors.green.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Difficulté', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: (exercise[3] as num?)?.toDouble() ?? 0.0,
                                      minHeight: 10,
                                      backgroundColor: Colors.grey[100],
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
