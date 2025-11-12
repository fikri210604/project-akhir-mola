import '../models/kategori.dart';

class KategoriDto {
  static Kategori fromMap(Map<String, dynamic> map, {required String id}) {
    return Kategori(
      id: id,
      nama: (map['nama'] ?? '') as String,
      ikon: map['ikon'] as String?,
      indukId: map['indukId'] as String?,
    );
  }

  static Map<String, dynamic> toMap(Kategori model) {
    return {
      'nama': model.nama,
      'ikon': model.ikon,
      'indukId': model.indukId,
    }..removeWhere((key, value) => value == null);
  }
}
