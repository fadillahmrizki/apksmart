enum TipeKriteria { benefit, cost }

class Kriteria {
  final String id;
  String nama;
  TipeKriteria tipe;
  double bobot;

  Kriteria({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.bobot,
  });

  // Method untuk mengubah objek Kriteria ini menjadi format Map/JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'tipe': tipe.toString(),
        'bobot': bobot,
      };

  // Factory constructor untuk membuat objek Kriteria dari format Map/JSON
  factory Kriteria.fromJson(Map<String, dynamic> json) => Kriteria(
        id: json['id'],
        nama: json['nama'],
        tipe:
            TipeKriteria.values.firstWhere((e) => e.toString() == json['tipe']),
        bobot: (json['bobot'] as num).toDouble(), // Pastikan tipe data double
      );

  // Kolom tipe kriteria
  String get tipeToString => tipe == TipeKriteria.benefit ? 'Benefit' : 'Cost';
}
