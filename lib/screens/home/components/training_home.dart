import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainingComp extends StatelessWidget {
  const TrainingComp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      height: 300,
      decoration: BoxDecoration(
        color: Color(0xFFEAEAEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [

          ],
        ),
      ),
    );
  }
}
