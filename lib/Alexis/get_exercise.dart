import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseDataService {
  // Attribut statique pour stocker les exercices en cache (local)
  static Map<String, dynamic>? _cachedExercises;

  // Singleton pour s'assurer qu'une seule instance existe
  static final ExerciseDataService _instance = ExerciseDataService._internal();

  // Constructeur singleton
  factory ExerciseDataService() => _instance;
  ExerciseDataService._internal();

  // Fonction pour récupérer les données depuis Firestore et les stocker en local (cache)
  Future<void> fetchExercises() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('exos') // Nom de la collection
          .doc('tab_exo') // Document avec les exercices
          .get();

      if (snapshot.exists) {
        // Stocker les données récupérées dans le cache
        _cachedExercises = snapshot.data() as Map<String, dynamic>?;
        print("Exercices récupérés et stockés en local.");
      } else {
        print("Aucun exercice trouvé.");
        _resetExercises();
      }
    } catch (e) {
      print("Erreur lors de la récupération des exercices : $e");
      _resetExercises();
    }
  }

  // Fonction pour obtenir les exercices déjà stockés en local (cache)
  Map<String, dynamic>? getExercises() {
    return _cachedExercises;
  }

  // Fonction pour réinitialiser les exercices stockés en local (vider le cache)
  void _resetExercises() {
    _cachedExercises = {};
  }

  // Méthode pour obtenir l'instance actuelle du service (singleton)
  static ExerciseDataService get instance => _instance;
}
