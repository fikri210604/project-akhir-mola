enum StatusTawaran { menunggu, diterima, ditolak }

class Tawaran {
  const Tawaran({
    required this.id,
    required this.produkId,
    required this.pembeliId,
    required this.harga,
    this.status = StatusTawaran.menunggu,
    required this.dibuatPada,
  });

  final String id;
  final String produkId;
  final String pembeliId;
  final int harga;
  final StatusTawaran status;
  final DateTime dibuatPada;

  Tawaran copyWith({
    String? id,
    String? produkId,
    String? pembeliId,
    int? harga,
    StatusTawaran? status,
    DateTime? dibuatPada,
  }) {
    return Tawaran(
      id: id ?? this.id,
      produkId: produkId ?? this.produkId,
      pembeliId: pembeliId ?? this.pembeliId,
      harga: harga ?? this.harga,
      status: status ?? this.status,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}

