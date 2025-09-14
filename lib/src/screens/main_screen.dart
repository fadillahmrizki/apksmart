import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/spk_provider.dart';
import 'bantuan/bantuan_page.dart';
import 'home/home_page.dart';
import 'kriteria/kriteria_page.dart';
import 'alternatif/alternatif_page.dart';
import 'nilai/nilai_page.dart';
import 'analisis/analisis_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const <Widget>[
    HomePage(),
    KriteriaPage(),
    AlternatifPage(),
    NilaiPage(),
    AnalisisPage(),
  ];

  final List<String> _pageTitles = const <String>[
    'Dashboard',
    'Aspek Penilaian',
    'Pilihan',
    'Input Nilai',
    'Hasil Perhitungan',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SpkProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;

            if (provider.selectedPageIndex != 0) {
              provider.changePage(0);
            } else {
              // Konfirmasi keluar app
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Konfirmasi Keluar'),
                  content: const Text(
                      'Apakah Anda yakin ingin keluar dari aplikasi?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text('Keluar',
                          style: TextStyle(color: Colors.red.shade700)),
                    ),
                  ],
                ),
              );
            }
          },

          // Button help center
          child: Scaffold(
            appBar: AppBar(
              title: Text(_pageTitles[provider.selectedPageIndex]),
              actions: provider.selectedPageIndex == 0
                  ? [
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        tooltip: 'Pusat Bantuan',
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BantuanPage())),
                      ),
                    ]
                  : null,
              backgroundColor: Colors.blue.shade500,
              foregroundColor: Colors.white,
            ),

            // Button Nav Bawah
            body: _pages[provider.selectedPageIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Beranda'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt_outlined),
                    activeIcon: Icon(Icons.list_alt),
                    label: 'Aspek'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_outlined),
                    activeIcon: Icon(Icons.people_alt),
                    label: 'Pilihan'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calculate_outlined),
                    activeIcon: Icon(Icons.calculate),
                    label: 'Nilai'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined),
                    activeIcon: Icon(Icons.analytics),
                    label: 'Hasil'),
              ],
              currentIndex: provider.selectedPageIndex,
              onTap: (index) => provider.changePage(index),
              selectedItemColor: Colors.blue.shade500,
              unselectedItemColor: Colors.grey.shade600,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
    );
  }
}
