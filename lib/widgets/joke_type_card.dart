import 'package:flutter/material.dart';
import '../models/joke_type.dart';
import '../screens/joke_list_screen.dart';

class JokeTypeCard extends StatelessWidget {
  final JokeType jokeType;

  const JokeTypeCard({super.key, required this.jokeType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JokesListScreen(jokeType: jokeType.type),
            ),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              jokeType.type,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}