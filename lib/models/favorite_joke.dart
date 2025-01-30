class FavoriteJoke {
  final String id;
  final String type;
  final String setup;
  final String punchline;
  final DateTime dateAdded;

  FavoriteJoke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'setup': setup,
      'punchline': punchline,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory FavoriteJoke.fromJson(Map<String, dynamic> json) {
    return FavoriteJoke(
      id: json['id'],
      type: json['type'],
      setup: json['setup'],
      punchline: json['punchline'],
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }
}