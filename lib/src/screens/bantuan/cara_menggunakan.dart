import 'package:flutter/material.dart';

class PanduanLangkah {
  final String judul;
  final String pathGambar;
  final List<String> deskripsi;

  const PanduanLangkah({
    required this.judul,
    required this.pathGambar,
    required this.deskripsi,
  });
}

class CaraPenggunaanPage extends StatelessWidget {
  const CaraPenggunaanPage({super.key});

  final List<PanduanLangkah> daftarLangkah = const [
    // ============================================================ Kriteria ============================================================
    PanduanLangkah(
      judul: '1. Input Aspek Penilaian (Kriteria)',
      pathGambar: 'assets/images/langkah_1_kriteria.png',
      deskripsi: [
        'Untuk memasukkan data pertama kita bisa melakukannya dari Aksi Cepat (Input Nilai) [1] atau Navbar Bawah (Aspek) [2].',
      ],
    ),
    PanduanLangkah(
      judul: '   Input Aspek Penilaian',
      pathGambar: 'assets/images/langkah_2_kriteria.png',
      deskripsi: [
        'Setelah masuk dari Input Nilai (Aksi Cepat) kita akan melihat halaman Input Nilai yang kosong dan ada tombol Pergi ke Halaman Aspek Penilaian. "Klik itu" ',
      ],
    ),
    PanduanLangkah(
      judul: '   Input Aspek Penilaian',
      pathGambar: 'assets/images/langkah_3_kriteria.png',
      deskripsi: [
        'Setelah diklik kita akan masuk kehalaman Aspek, dan siap memasukkan nilai pertama kita. "Klik ini".',
      ],
    ),
    PanduanLangkah(
      judul: '   Input Aspek Penilaian',
      pathGambar: 'assets/images/langkah_4_kriteria.png',
      deskripsi: [
        ' Form baru akan muncul, dan',
        ' [1]. Masukkan "Nama, pilih jenis aspeknya (bisa Benefit/Cost), dan Nilai dari (Jenis)." ',
        ' Untuk Nilai sendiri dia hanya bisa dari 0-1 (0.9, 0.8, 0.70, 0.45, 0.2, 0.1). ',
        ' [2]. Klik Tambah, jika sudah selesai. ',
        'note: untuk Jenis & Nilai Anda bebas memilih sesuai kebutuhan.',
      ],
    ),
    PanduanLangkah(
      judul: '   Input Aspek Penilaian',
      pathGambar: 'assets/images/langkah_5_kriteria.png',
      deskripsi: [
        '1. + Tambah Baru : Untuk menambah Aspek Penilaian lain. ',
        '2. Hapus Semua : Untuk menghapus SELURUH data yang ada dihalaman ini (pastikan sudah yakin untuk menghapusnya). ',
        '3. Hapus : Tombol untuk menghapus data (1 saja). ',
        '4. Edit : Tombol untuk mengedit/ubah data (1 saja), jika salah input. ',
        '5. Daftar data : Daftar Aspek yang sudah ditambahkan.',
      ],
    ),

    // ============================================================ Alternatif ============================================================

    PanduanLangkah(
      judul: '2. Input Pilihan (Alternatif)',
      pathGambar: 'assets/images/langkah_1_alternatif.png',
      deskripsi: [
        'Setelah memasukkan nilai dihalaman Aspek Penilaian',
        'selanjutnya kita kehalaman Pilihan (Alternatif), dan klik "+ Tambah Pilihan Pertama" ',
      ],
    ),
    PanduanLangkah(
      judul: '   Input Pilihan (Alternatif)',
      pathGambar: 'assets/images/langkah_2_alternatif.png',
      deskripsi: [
        'Masukkan Nama Pilihan untuk Pilihan pertama Anda. (tidak boleh kosong namanya).',
        'Jika sudah klik Tambah. (Klik Batal jika belum mau)',
      ],
    ),
    PanduanLangkah(
      judul: '   Input Pilihan (Alternatif)',
      pathGambar: 'assets/images/langkah_3_alternatif.png',
      deskripsi: [
        'Tampilan setelah mengisi Pilihan Anda.',
        'Untuk fitur-fitur setelah Anda memasukkan data itu tidak ada berubah dan tetap sama seperti pasca mengisi Aspek Penilaian. Ada fitur “tambah, hapus (seluruh data/salah satu data), edit”. ',
      ],
    ),

    // ============================================================ Input Nilai ============================================================

    PanduanLangkah(
      judul: '3. Input Nilai',
      pathGambar: 'assets/images/langkah_1_nilai.png',
      deskripsi: [
        'Hapus Semua Nilai: Digunakan untuk menghapus SELURUH nilai yang ada didalam tabel (pastikan sudah yakin untuk menghapusnya). ',
        'Tabel Nilai: Untuk memasukkan Nilai yang sesuai dari tiap-tiap pilihan berdasarkan aspek penilaian, yang kemudian dihitung berdasarkan Jenis Aspek Penilaian. ',
        'Simpan Nilai: Menyimpan nilai yang dimasukkan ke penyimpanan perangkat. ',
      ],
    ),

    // ============================================================ Input Nilai ============================================================

    PanduanLangkah(
      judul: '4. Hasil Perhitungan',
      pathGambar: 'assets/images/langkah_1_hasil.png',
      deskripsi: [
        'Ringkasan Penilaian: Tabel untuk menunjukkan inputan nilai pada table yang kita masukkan pada halaman Input Nilai.',
      ],
    ),
    PanduanLangkah(
      judul: '   Hasil Perhitungan',
      pathGambar: 'assets/images/langkah_2_hasil.png',
      deskripsi: [
        'Adu Nilai: Tabel untuk menyetarakan semua skor nilai agar adil saat dibandingkan tidak peduli apa satuan asli dari nilai itu.',
      ],
    ),
    PanduanLangkah(
      judul: '   Hasil Perhitungan',
      pathGambar: 'assets/images/langkah_3_hasil.png',
      deskripsi: [
        'Hasil Ranking: Tabel untuk menunjukkan urutan hasil nilai perhitungan tertinggi yang akan dipertimbangkan untuk diprioritaskan.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cara Menggunakan Aplikasi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: daftarLangkah.length,
        itemBuilder: (context, index) {
          final langkah = daftarLangkah[index];
          // Panggil widget bantuan untuk membangun setiap kartu langkah
          return _buildStepCard(context, langkah: langkah);
        },
      ),
    );
  }

  // Widget bantuan untuk membuat setiap kartu tutorial
  Widget _buildStepCard(BuildContext context,
      {required PanduanLangkah langkah}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Agar gambar mengikuti bentuk card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Judul
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              langkah.judul,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          // Gambar Screenshot
          Image.asset(
            langkah.pathGambar,
            fit: BoxFit.cover,
            width: double.infinity,
            // Pengaman jika gambar tidak ditemukan
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey.shade200,
                child: const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey, size: 40),
                    SizedBox(height: 8),
                    Text('Gambar tidak ditemukan'),
                  ],
                )),
              );
            },
          ),
          // Bagian Penjelasan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Langkah-langkah/Penjelasan:',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Gunakan Column untuk menampilkan daftar deskripsi
                ...langkah.deskripsi.asMap().entries.map((entry) {
                  int idx = entry.key + 1;
                  String desc = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$idx. ',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                            child: Text(desc,
                                style: const TextStyle(height: 1.4))),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
