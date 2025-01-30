import 'package:flutter/material.dart';
import '../models/favorite_joke.dart';

class FavoriteJokeCard extends StatefulWidget {
  final FavoriteJoke joke;
  final VoidCallback onRemove;

  const FavoriteJokeCard({
    super.key,
    required this.joke,
    required this.onRemove,
  });

  @override
  _FavoriteJokeCardState createState() => _FavoriteJokeCardState();
}

class _FavoriteJokeCardState extends State<FavoriteJokeCard> {
  bool _showPunchline = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            _showPunchline = !_showPunchline;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.joke.setup,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
                ],
              ),
              if (_showPunchline) ...[
                const SizedBox(height: 8),
                Text(
                  widget.joke.punchline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}