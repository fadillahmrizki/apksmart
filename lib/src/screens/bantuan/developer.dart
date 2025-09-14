import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TentangPengembangPage extends StatelessWidget {
  const TentangPengembangPage({super.key});

// Membuka URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          _buildHeaderBanner(Colors.blue),
          // Tombol Kembali
          SafeArea(
            child: BackButton(color: Colors.white),
          ),

          // Konten Utama
          Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/poto.png'),
                  // ignore: deprecated_member_use
                  backgroundColor: primaryColor.withOpacity(0.1),
                ),
                const SizedBox(height: 15),

                Text(
                  'Mhd. Rizky Fadillah',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '230180082 | Sistem Informasi',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 50),

                // Isi Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    elevation: 0,
                    color: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Halo, saya adalah mahasiswa Sistem Informasi Universitas Malikussaleh dan sedang ada di semester 4. Tujuan pembuatan aplikasi ini adalah untuk memenuhi tugas akhir mata kuliah "Sistem Pendukung Keputusan" juga untuk mempelajari dunia Mobile Development. Jika ingin lebih mengenal saya silahkan klik link dibawah ini',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Wrap(
                  spacing: 16,
                  children: [
                    _buildSocialIcon(
                      Icons.public,
                      () => _launchURL(
                          'https://www.instagram.com/rizkyfadilah645/'),
                    ),
                    _buildSocialIcon(
                      Icons.code,
                      () => _launchURL('https://github.com/fadillahmrizki'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Membuat banner di header
  Widget _buildHeaderBanner(Color color) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 30),
      onPressed: onPressed,
      color: Colors.blue.shade700,
    );
  }
}
