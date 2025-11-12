import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produk.dart';

class ProdukDto {
  static Produk fromMap(Map<String, dynamic> map, {required String id}) {
    final dibuatPada = _toDateTime(map['dibuatPada']) ?? DateTime.now();
    final diperbaruiPada = _toDateTime(map['diperbaruiPada']);
    final List<String> foto = (map['foto'] as List?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];
    final statusStr = (map['status'] ?? 'aktif') as String;
    return Produk(
      id: id,
      judul: (map['judul'] ?? '') as String,
      deskripsi: (map['deskripsi'] ?? '') as String,
      kategoriId: (map['kategoriId'] ?? '') as String,
      harga: (map['harga'] ?? 0) is num ? (map['harga'] as num).toInt() : 0,
      dapatNego: (map['dapatNego'] ?? false) as bool,
      pemilikId: (map['pemilikId'] ?? '') as String,
      foto: foto,
      kota: map['kota'] as String?,
      dibuatPada: dibuatPada,
      diperbaruiPada: diperbaruiPada,
      status: _statusFromString(statusStr),
    );
  }

  static Map<String, dynamic> toMap(Produk model) {
    return {
      'judul': model.judul,
      'deskripsi': model.deskripsi,
      'kategoriId': model.kategoriId,
      'harga': model.harga,
      'dapatNego': model.dapatNego,
      'pemilikId': model.pemilikId,
      'foto': model.foto,
      'kota': model.kota,
      'dibuatPada': Timestamp.fromDate(model.dibuatPada),
      'diperbaruiPada': model.diperbaruiPada != null ? Timestamp.fromDate(model.diperbaruiPada!) : null,
      'status': _statusToString(model.status),
    }..removeWhere((key, value) => value == null);
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static StatusProduk _statusFromString(String v) {
    switch (v) {
      case 'terjual':
        return StatusProduk.terjual;
      case 'disembunyikan':
        return StatusProduk.disembunyikan;
      case 'aktif':
      default:
        return StatusProduk.aktif;
    }
  }

  static String _statusToString(StatusProduk s) {
    switch (s) {
      case StatusProduk.terjual:
        return 'terjual';
      case StatusProduk.disembunyikan:
        return 'disembunyikan';
      case StatusProduk.aktif:
        return 'aktif';
    }
  }
}
