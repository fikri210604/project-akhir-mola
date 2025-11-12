enum JenisPesan { teks, gambar, tawaran }

class Pesan {
  const Pesan({
    required this.id,
    required this.percakapanId,
    required this.pengirimId,
    this.teks,
    this.urlGambar,
    required this.dibuatPada,
    this.jenis = JenisPesan.teks,
    this.hargaTawaran,
    this.dibacaOleh,
  });

  final String id;
  final String percakapanId;
  final String pengirimId;
  final String? teks;
  final String? urlGambar;
  final DateTime dibuatPada;
  final JenisPesan jenis;
  final int? hargaTawaran;
  final List<String>? dibacaOleh;

  Pesan copyWith({
    String? id,
    String? percakapanId,
    String? pengirimId,
    String? teks,
    String? urlGambar,
    DateTime? dibuatPada,
    JenisPesan? jenis,
    int? hargaTawaran,
    List<String>? dibacaOleh,
  }) {
    return Pesan(
      id: id ?? this.id,
      percakapanId: percakapanId ?? this.percakapanId,
      pengirimId: pengirimId ?? this.pengirimId,
      teks: teks ?? this.teks,
      urlGambar: urlGambar ?? this.urlGambar,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      jenis: jenis ?? this.jenis,
      hargaTawaran: hargaTawaran ?? this.hargaTawaran,
      dibacaOleh: dibacaOleh ?? this.dibacaOleh,
    );
  }
}
