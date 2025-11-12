class Percakapan {
  const Percakapan({
    required this.id,
    required this.anggotaIds,
    required this.produkId,
    this.pesanTerakhir,
    required this.diperbaruiPada,
    this.jumlahBelumDibacaPerPengguna,
  });

  final String id;
  final List<String> anggotaIds;
  final String produkId;
  final String? pesanTerakhir;
  final DateTime diperbaruiPada;
  final Map<String, int>? jumlahBelumDibacaPerPengguna;

  Percakapan copyWith({
    String? id,
    List<String>? anggotaIds,
    String? produkId,
    String? pesanTerakhir,
    DateTime? diperbaruiPada,
    Map<String, int>? jumlahBelumDibacaPerPengguna,
  }) {
    return Percakapan(
      id: id ?? this.id,
      anggotaIds: anggotaIds ?? this.anggotaIds,
      produkId: produkId ?? this.produkId,
      pesanTerakhir: pesanTerakhir ?? this.pesanTerakhir,
      diperbaruiPada: diperbaruiPada ?? this.diperbaruiPada,
      jumlahBelumDibacaPerPengguna: jumlahBelumDibacaPerPengguna ?? this.jumlahBelumDibacaPerPengguna,
    );
  }
}
