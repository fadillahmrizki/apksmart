class Alternatif {
  final String id;
  String nama;

  Alternatif({
    required this.id,
    required this.nama,
  });

  // Method untuk mengubah objek Alternatif ini menjadi format Map/JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
      };

  // Factory constructor untuk membuat objek Alternatif dari format Map/JSON
  factory Alternatif.fromJson(Map<String, dynamic> json) => Alternatif(
        id: json['id'],
        nama: json['nama'],
      );
}
