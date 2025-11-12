import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_conversation.dart';

class PercakapanDto {
  static Percakapan fromMap(Map<String, dynamic> map, {required String id}) {
    final List<String> anggota = (map['anggotaIds'] as List?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];

    final Map<String, int>? unread = (map['jumlahBelumDibacaPerPengguna'] as Map?)
        ?.map((key, value) => MapEntry(key.toString(), (value as num).toInt()));

    return Percakapan(
      id: id,
      anggotaIds: anggota,
      produkId: (map['produkId'] ?? '') as String,
      pesanTerakhir: map['pesanTerakhir'] as String?,
      diperbaruiPada: _toDateTime(map['diperbaruiPada']) ?? DateTime.now(),
      jumlahBelumDibacaPerPengguna: unread,
    );
  }

  static Map<String, dynamic> toMap(Percakapan model) {
    return {
      'anggotaIds': model.anggotaIds,
      'produkId': model.produkId,
      'pesanTerakhir': model.pesanTerakhir,
      'diperbaruiPada': Timestamp.fromDate(model.diperbaruiPada),
      'jumlahBelumDibacaPerPengguna': model.jumlahBelumDibacaPerPengguna,
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

