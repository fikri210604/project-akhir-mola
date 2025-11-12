class Pengguna {
  const Pengguna({
    required this.id,
    required this.nama,
    this.email,
    this.telepon,
    this.urlFoto,
    this.kota,
    this.rating,
    required this.dibuatPada,
    this.terverifikasi = false,
  });

  final String id;
  final String nama;
  final String? email;
  final String? telepon;
  final String? urlFoto;
  final String? kota;
  final double? rating;
  final DateTime dibuatPada;
  final bool terverifikasi;

  Pengguna copyWith({
    String? id,
    String? nama,
    String? email,
    String? telepon,
    String? urlFoto,
    String? kota,
    double? rating,
    DateTime? dibuatPada,
    bool? terverifikasi,
  }) {
    return Pengguna(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      urlFoto: urlFoto ?? this.urlFoto,
      kota: kota ?? this.kota,
      rating: rating ?? this.rating,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      terverifikasi: terverifikasi ?? this.terverifikasi,
    );
  }
}
