import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/firebase_service.dart';

class JokeCard extends StatefulWidget {
  final Joke joke;

  const JokeCard({super.key, required this.joke});

  @override
  _JokeCardState createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> {
  bool _showPunchline = false;
  bool _isFavorite = false;
  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Service - in a real app, you'd get the user ID from authentication
    _firebaseService = FirebaseService(userId: 'default_user');
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final isFavorite = await _firebaseService.isJokeFavorited(widget.joke.id.toString());
      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
        });
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      setState(() {
        _isFavorite = !_isFavorite;  // Optimistic update
      });

      if (_isFavorite) {
        await _firebaseService.addToFavorites(widget.joke);
      } else {
        await _firebaseService.removeFromFavorites(widget.joke.id.toString());
      }
    } catch (e) {
      // Revert the optimistic update if there's an error
      setState(() {
        _isFavorite = !_isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorite status: $e')),
      );
    }
  }

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
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : null,
                    ),
                    onPressed: _toggleFavorite,
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