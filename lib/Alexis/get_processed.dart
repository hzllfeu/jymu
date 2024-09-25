import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jymu/Models/UserModel.dart';

class ProcessedDataService {
  // Attribut statique pour stocker les données en cache (local)
  static Map<String, dynamic>? _cachedProcessedData;

  // Singleton pour s'assurer qu'une seule instance existe
  static final ProcessedDataService _instance = ProcessedDataService._internal();

  // Constructeur singleton
  factory ProcessedDataService() => _instance;
  ProcessedDataService._internal();

  // Fonction pour récupérer les données depuis Firestore et les stocker en local (cache)
  Future<void> fetchProcessedData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('processed') // Nom de la collection
          .doc(UserModel.currentUser().id!) // Document spécifique (à remplacer si nécessaire)
          .get();

      if (snapshot.exists) {
        // Stocker les données récupérées dans le cache
        _cachedProcessedData = snapshot.data() as Map<String, dynamic>?;
        print("Données de 'processed' récupérées et stockées en local.");
      } else {
        print("Aucune donnée trouvée.");
        _resetProcessedData();
      }
    } catch (e) {
      print("Erreur lors de la récupération des données : $e");
      _resetProcessedData();
    }
  }

  // Fonction pour obtenir les données déjà stockées en local (cache)
  Map<String, dynamic>? getProcessedData() {
    return _cachedProcessedData;
  }

  // Fonction pour réinitialiser les données stockées en local (vider le cache)
  void _resetProcessedData() {
    _cachedProcessedData = {};
  }

  // Méthode pour obtenir l'instance actuelle du service (singleton)
  static ProcessedDataService get instance => _instance;
}
