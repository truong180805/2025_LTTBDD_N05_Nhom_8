import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; //thu vien co hieu ung phao hoa
import 'package:mini_habit_challenge/l10n/app_localizations.dart';

class CompletionScreen extends StatefulWidget {
  final String habitName;
  const CompletionScreen({super.key, required this.habitName});

  @override
  _CompletionScreenState createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play(); 
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, 
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),

          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("🎉", style: TextStyle(fontSize: 100)),
                Text(l10n.congratulations, style: TextStyle(fontSize: 32)),
                Text(l10n.challengeComplete, style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text(widget.habitName, style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text(l10n.createNewChallenge),
                  onPressed: () {
                    
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}