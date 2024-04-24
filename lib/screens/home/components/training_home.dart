import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingComp extends StatelessWidget {
  TrainingComp({
    super.key,
  });

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
        enableHapticFeedback: true,
        previewBuilder: (context, animation, child) => SizedBox(width: 600, child: child,),
        actions: const [
        CupertinoContextMenuAction(child: Text("Nouvel entrainement"), trailingIcon: CupertinoIcons.refresh_bold,)
        ],
      child: Container(
          width: 600,
          margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          height: 430,
          decoration: BoxDecoration(
            color: Color(0xFFEAEAEB),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFEAEAEB), Color(0xffEFB5A2)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Couleur de l'ombre
                spreadRadius: 5, // Rayon de diffusion
                blurRadius: 7, // Flou de l'ombre
                offset: Offset(0, 3), // Décalage de l'ombre
              ),
            ],
          ),
      )
    );
  }
}
