import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tawaran.dart';

class TawaranDto {
  static Tawaran fromMap(Map<String, dynamic> map, {required String id}) {
    return Tawaran(
      id: id,
      produkId: (map['produkId'] ?? '') as String,
      pembeliId: (map['pembeliId'] ?? '') as String,
      harga: (map['harga'] ?? 0) is num ? (map['harga'] as num).toInt() : 0,
      status: _statusFromString((map['status'] ?? 'menunggu') as String),
      dibuatPada: _toDateTime(map['dibuatPada']) ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(Tawaran model) {
    return {
      'produkId': model.produkId,
      'pembeliId': model.pembeliId,
      'harga': model.harga,
      'status': _statusToString(model.status),
      'dibuatPada': Timestamp.fromDate(model.dibuatPada),
    };
  }

  static StatusTawaran _statusFromString(String v) {
    switch (v) {
      case 'diterima':
        return StatusTawaran.diterima;
      case 'ditolak':
        return StatusTawaran.ditolak;
      case 'menunggu':
      default:
        return StatusTawaran.menunggu;
    }
  }

  static String _statusToString(StatusTawaran s) {
    switch (s) {
      case StatusTawaran.diterima:
        return 'diterima';
      case StatusTawaran.ditolak:
        return 'ditolak';
      case StatusTawaran.menunggu:
        return 'menunggu';
    }
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

