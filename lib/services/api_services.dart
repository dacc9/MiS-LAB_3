import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke.dart';
import '../models/joke_type.dart';

class ApiServices {
  static const String baseUrl = 'https://official-joke-api.appspot.com';

  // Fetch joke types
  Future<List<JokeType>> getJokeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((type) => JokeType.fromJson(type)).toList();
    } else {
      throw Exception('Failed to load joke types');
    }
  }

  // Fetch jokes by type
  Future<List<Joke>> getJokesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/jokes/$type/ten'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((joke) => Joke.fromJson(joke)).toList();
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  // Fetch random joke
  Future<Joke> getRandomJoke() async {
    final response = await http.get(Uri.parse('$baseUrl/random_joke'));

    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load random joke');
    }
  }
}