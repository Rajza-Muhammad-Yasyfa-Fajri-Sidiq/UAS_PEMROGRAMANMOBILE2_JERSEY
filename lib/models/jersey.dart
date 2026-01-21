class Jersey {
  final String id;
  final String name;
  final String team;
  final String league;
  final String season;
  final int price;
  final double rating;
  final String imageUrl;
  final String description;

  const Jersey({
    required this.id,
    required this.name,
    required this.team,
    required this.league,
    required this.season,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });

  factory Jersey.fromJson(Map<String, dynamic> j) => Jersey(
    id: (j['id'] ?? '').toString(),
    name: (j['name'] ?? '').toString(),
    team: (j['team'] ?? '').toString(),
    league: (j['league'] ?? '').toString(),
    season: (j['season'] ?? '').toString(),

    // ✅ terima int / double / string
    price: (j['price'] is num)
        ? (j['price'] as num).round()
        : (double.tryParse(j['price'].toString())?.round() ?? 0),

    // ✅ terima num / string
    rating: (j['rating'] is num)
        ? (j['rating'] as num).toDouble()
        : (double.tryParse(j['rating'].toString()) ?? 0.0),

    imageUrl: (j['imageUrl'] ?? '').toString(),
    description: (j['description'] ?? '').toString(),
  );
}
