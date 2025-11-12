import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ulasan.dart';

class UlasanDto {
  static Ulasan fromMap(Map<String, dynamic> map, {required String id}) {
    return Ulasan(
      id: id,
      pemberiId: (map['pemberiId'] ?? '') as String,
      penerimaId: (map['penerimaId'] ?? '') as String,
      rating: (map['rating'] ?? 0) is num ? (map['rating'] as num).toDouble() : 0,
      komentar: map['komentar'] as String?,
      dibuatPada: _toDateTime(map['dibuatPada']) ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap(Ulasan model) {
    return {
      'pemberiId': model.pemberiId,
      'penerimaId': model.penerimaId,
      'rating': model.rating,
      'komentar': model.komentar,
      'dibuatPada': Timestamp.fromDate(model.dibuatPada),
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

