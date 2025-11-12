enum StatusProduk { aktif, terjual, disembunyikan }

class Produk {
  const Produk({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.kategoriId,
    required this.harga,
    this.dapatNego = false,
    required this.pemilikId,
    this.foto = const <String>[],
    this.kota,
    required this.dibuatPada,
    this.diperbaruiPada,
    this.status = StatusProduk.aktif,
  });

  final String id;
  final String judul;
  final String deskripsi;
  final String kategoriId;
  final int harga;
  final bool dapatNego;
  final String pemilikId;
  final List<String> foto;
  final String? kota;
  final DateTime dibuatPada;
  final DateTime? diperbaruiPada;
  final StatusProduk status;

  Produk copyWith({
    String? id,
    String? judul,
    String? deskripsi,
    String? kategoriId,
    int? harga,
    bool? dapatNego,
    String? pemilikId,
    List<String>? foto,
    String? kota,
    DateTime? dibuatPada,
    DateTime? diperbaruiPada,
    StatusProduk? status,
  }) {
    return Produk(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      kategoriId: kategoriId ?? this.kategoriId,
      harga: harga ?? this.harga,
      dapatNego: dapatNego ?? this.dapatNego,
      pemilikId: pemilikId ?? this.pemilikId,
      foto: foto ?? this.foto,
      kota: kota ?? this.kota,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      status: status ?? this.status,
    );
  }
}
