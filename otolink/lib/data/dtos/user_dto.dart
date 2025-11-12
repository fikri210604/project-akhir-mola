import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class PenggunaDto {
  static Pengguna fromMap(Map<String, dynamic> map, {required String id}) {
    final dibuat = map['dibuatPada'];
    final dibuatPada = _toDateTime(dibuat);
    final ratingRaw = map['rating'];
    final double? rating = ratingRaw is num ? ratingRaw.toDouble() : null;
    return Pengguna(
      id: id,
      nama: (map['nama'] ?? '') as String,
      email: map['email'] as String?,
      telepon: map['telepon'] as String?,
      urlFoto: map['urlFoto'] as String?,
      kota: map['kota'] as String?,
      rating: rating,
      dibuatPada: dibuatPada ?? DateTime.now(),
      terverifikasi: (map['terverifikasi'] ?? false) as bool,
    );
  }

  static Map<String, dynamic> toMap(Pengguna model) {
    return {
      'nama': model.nama,
      'email': model.email,
      'telepon': model.telepon,
      'urlFoto': model.urlFoto,
      'kota': model.kota,
      'rating': model.rating,
      'dibuatPada': Timestamp.fromDate(model.dibuatPada),
      'terverifikasi': model.terverifikasi,
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
}
