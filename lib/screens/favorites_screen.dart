import 'package:flutter/material.dart';
import '../models/favorite_joke.dart';
import '../services/firebase_service.dart';

class FavoritesScreen extends StatelessWidget {
  final FirebaseService firebaseService;

  const FavoritesScreen({
    super.key,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Jokes'),
      ),
      body: StreamBuilder<List<FavoriteJoke>>(
        stream: firebaseService.getFavoriteJokes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final jokes = snapshot.data ?? [];

          if (jokes.isEmpty) {
            return const Center(
              child: Text('No favorite jokes yet! Add some by tapping the heart icon.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jokes.length,
            itemBuilder: (context, index) {
              final joke = jokes[index];
              return Card(
                child: ListTile(
                  title: Text(joke.setup),
                  subtitle: Text(joke.punchline),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      firebaseService.removeFromFavorites(joke.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}