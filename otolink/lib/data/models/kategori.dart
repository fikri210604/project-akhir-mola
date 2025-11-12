class Kategori {
  const Kategori({
    required this.id,
    required this.nama,
    this.ikon,
    this.indukId,
  });

  final String id;
  final String nama;
  final String? ikon;
  final String? indukId;

  Kategori copyWith({
    String? id,
    String? nama,
    String? ikon,
    String? indukId,
  }) {
    return Kategori(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      ikon: ikon ?? this.ikon,
      indukId: indukId ?? this.indukId,
    );
  }
}
