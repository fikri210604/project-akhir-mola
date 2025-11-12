class Ulasan {
  const Ulasan({
    required this.id,
    required this.pemberiId,
    required this.penerimaId,
    required this.rating,
    this.komentar,
    required this.dibuatPada,
  });

  final String id;
  final String pemberiId;
  final String penerimaId;
  final double rating;
  final String? komentar;
  final DateTime dibuatPada;

  Ulasan copyWith({
    String? id,
    String? pemberiId,
    String? penerimaId,
    double? rating,
    String? komentar,
    DateTime? dibuatPada,
  }) {
    return Ulasan(
      id: id ?? this.id,
      pemberiId: pemberiId ?? this.pemberiId,
      penerimaId: penerimaId ?? this.penerimaId,
      rating: rating ?? this.rating,
      komentar: komentar ?? this.komentar,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}

