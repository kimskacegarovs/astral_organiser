import 'dart:convert';

class QuantifiedCategory {
  final int id;
  final String title;
  bool active;

  QuantifiedCategory({
    required this.title,
    bool? active,
    int? id,
  })  : active = active ?? true,
        id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory QuantifiedCategory.fromMap(Map<String, dynamic> map) {
    return QuantifiedCategory(title: map["title"], active: map["active"]);
  }

  Map<String, dynamic> toMap() => {"title": title, "active": active};

  String toJson() => json.encode(toMap());

  factory QuantifiedCategory.fromJson(String source) => QuantifiedCategory.fromMap(json.decode(source));
}

class Quantified {
  final QuantifiedCategory category;
  final int amount;
  DateTime createdAt;

  Quantified({
    required this.category,
    required this.amount,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() =>
      {"category": category.toMap(), "amount": amount, "createdAt": createdAt.toIso8601String()};

  String toJson() => json.encode(toMap());

  factory Quantified.fromMap(Map<String, dynamic> map) {
    return Quantified(
      category: QuantifiedCategory.fromMap(map["category"]),
      amount: map["amount"],
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }
}
