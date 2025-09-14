import 'package:flutter/material.dart';
import 'cara_menggunakan.dart';
import 'developer.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          _buildHelpMenuItem(
            context,
            icon: Icons.rule,
            title: 'Cara Penggunaan',
            subtitle: 'Panduan penggunaan aplikasi',
            destinationPage: const CaraPenggunaanPage(),
          ),
          _buildHelpMenuItem(
            context,
            icon: Icons.person,
            title: 'Tentang Developer',
            subtitle: 'Informasi tentang pembuat aplikasi',
            destinationPage: const TentangPengembangPage(),
          ),
        ],
      ),
    );
  }

  // Widget bantuan menu rapi
  Widget _buildHelpMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      Widget? destinationPage,
      VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.blue.shade500),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap ??
          () {
            if (destinationPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destinationPage),
              );
            }
          },
    );
  }
}
