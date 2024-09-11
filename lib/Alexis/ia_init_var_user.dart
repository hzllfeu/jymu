

class GlobalListManager {
  // Instance singleton
  static final GlobalListManager _instance = GlobalListManager._internal();

  // Liste partagée
  List<double> dynamicList = List<double>.filled(9, 0.0);

  // Constructeur privé
  GlobalListManager._internal();

  // Méthode factory pour retourner la même instance
  factory GlobalListManager() {
    return _instance;
  }
}



