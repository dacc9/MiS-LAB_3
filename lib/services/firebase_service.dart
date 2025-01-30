import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_joke.dart';
import '../models/joke.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId; // You'll need to implement authentication to get this

  FirebaseService({required this.userId});

  // Add joke to favorites
  Future<void> addToFavorites(Joke joke) async {
    final favoriteJoke = FavoriteJoke(
      id: joke.id.toString(),
      type: joke.type,
      setup: joke.setup,
      punchline: joke.punchline,
      dateAdded: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(favoriteJoke.id)
        .set(favoriteJoke.toJson());
  }

  // Remove joke from favorites
  Future<void> removeFromFavorites(String jokeId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(jokeId)
        .delete();
  }

  // Get all favorite jokes
  Stream<List<FavoriteJoke>> getFavoriteJokes() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FavoriteJoke.fromJson(doc.data()))
        .toList());
  }

  // Check if a joke is favorited
  Future<bool> isJokeFavorited(String jokeId) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(jokeId)
        .get();

    return docSnapshot.exists;
  }
}