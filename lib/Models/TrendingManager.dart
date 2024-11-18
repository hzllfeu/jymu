import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> checkAndUpdateStack(String id) async {
  final DocumentReference<Map<String, dynamic>> stacksDoc =
      FirebaseFirestore.instance.collection('trending').doc('stacks');

  final docSnapshot = await stacksDoc.get();

  if (!docSnapshot.exists) {
    print('Le document "stacks" n\'existe pas.');
    return;
  }

  Map<String, dynamic>? data = docSnapshot.data();
  final List<String> stackNames = ['stack1', 'stack2', 'stack3', 'stack4'];
  final DateTime currentTime = DateTime.now();

  bool idFound = false;

  for (var stackName in stackNames) {
    Map<String, dynamic>? stack = data?[stackName];
    if (stack != null && stack.containsKey(id)) {
      idFound = true;
      // Récupérer le timestamp actuel associé à l'ID
      final Timestamp lastTimestamp = stack[id];
      final DateTime lastTime = lastTimestamp.toDate();

      // Calcul de la différence en heures entre les deux timestamps
      final differenceInHours = currentTime.difference(lastTime).inHours;

      // Si la différence est entre 5 et 6 heures, mettre à jour le timestamp
      if (differenceInHours >= 5 && differenceInHours < 6) {
        stack[id] = Timestamp.fromDate(currentTime);
        await stacksDoc.update({stackName: stack});
        print('Timestamp mis à jour pour $id dans $stackName.');
      } else {
        print('$id est déjà présent dans $stackName mais ne nécessite pas de mise à jour.');
      }
      break;
    }
  }

  // Si l'ID n'a été trouvé dans aucune stack, l'ajouter à une stack aléatoire
  if (!idFound) {
    final random = Random();
    final randomStackName = stackNames[random.nextInt(stackNames.length)];
    final Map<String, dynamic> newStack = data?[randomStackName] ?? {};

    // Ajouter l'ID avec le timestamp actuel
    newStack[id] = Timestamp.fromDate(currentTime);
    await stacksDoc.update({randomStackName: newStack});
    print('$id ajouté à $randomStackName avec le timestamp actuel.');
  }
}