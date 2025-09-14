import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/kriteria.dart';
import '../models/alternatif.dart';

class SpkProvider extends ChangeNotifier {
  // DATA APLIKASI
  List<Kriteria> _daftarKriteria = [];
  List<Alternatif> _daftarAlternatif = [];
  Map<String, Map<String, double>> _nilai = {};
  bool _apakahHasilTersedia = false;

  // STATE NAVIGASI
  int _selectedPageIndex = 0;

  SpkProvider() {
    loadData();
  }

  // Getters
  List<Kriteria> get daftarKriteria => _daftarKriteria;
  List<Alternatif> get daftarAlternatif => _daftarAlternatif;
  Map<String, Map<String, double>> get nilai => _nilai;
  bool get apakahHasilTersedia => _apakahHasilTersedia;
  int get selectedPageIndex => _selectedPageIndex;

  // Fungsi untuk Pindah Halaman
  void changePage(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }

  // --- SEMUA FUNGSI LAIN DI BAWAH INI ---

  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('kriteriaList',
          jsonEncode(_daftarKriteria.map((k) => k.toJson()).toList()));
      prefs.setString('alternatifList',
          jsonEncode(_daftarAlternatif.map((a) => a.toJson()).toList()));
      prefs.setString('nilaiMap', jsonEncode(_nilai));
      prefs.setBool('apakahHasilTersedia', _apakahHasilTersedia);
    } catch (e) {
      print('Gagal menyimpan data: $e');
    }
  }

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('kriteriaList')) {
        final List<dynamic> kriteriaJson =
            jsonDecode(prefs.getString('kriteriaList')!);
        _daftarKriteria =
            kriteriaJson.map((json) => Kriteria.fromJson(json)).toList();
      }
      if (prefs.containsKey('alternatifList')) {
        final List<dynamic> alternatifJson =
            jsonDecode(prefs.getString('alternatifList')!);
        _daftarAlternatif =
            alternatifJson.map((json) => Alternatif.fromJson(json)).toList();
      }
      if (prefs.containsKey('nilaiMap')) {
        final Map<String, dynamic> nilaiJson =
            jsonDecode(prefs.getString('nilaiMap')!);
        _nilai = nilaiJson.map((idAlternatif, mapKriteria) {
          final Map<String, double> kriteriaMap =
              (mapKriteria as Map<String, dynamic>).map(
            (idKriteria, nilai) =>
                MapEntry(idKriteria, (nilai as num).toDouble()),
          );
          return MapEntry(idAlternatif, kriteriaMap);
        });
      }
      if (prefs.containsKey('apakahHasilTersedia')) {
        _apakahHasilTersedia = prefs.getBool('apakahHasilTersedia') ?? false;
      }
    } catch (e) {
      print('Gagal memuat data: $e');
    } finally {
      notifyListeners();
    }
  }

  void addOrUpdateKriteria(
      {String? id,
      required String nama,
      required TipeKriteria tipe,
      required double bobot}) {
    if (id != null) {
      final index = _daftarKriteria.indexWhere((k) => k.id == id);
      if (index != -1) {
        _daftarKriteria[index].nama = nama;
        _daftarKriteria[index].tipe = tipe;
        _daftarKriteria[index].bobot = bobot;
      }
    } else {
      _daftarKriteria.add(Kriteria(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nama: nama,
          tipe: tipe,
          bobot: bobot));
    }
    _apakahHasilTersedia = false;
    notifyListeners();
    saveData();
  }

  void deleteKriteria(String id) {
    _daftarKriteria.removeWhere((k) => k.id == id);
    _nilai.forEach((idAlternatif, mapKriteria) => mapKriteria.remove(id));
    _apakahHasilTersedia = false;
    notifyListeners();
    saveData();
  }

  void addOrUpdateAlternatif({String? id, required String nama}) {
    if (id != null) {
      final index = _daftarAlternatif.indexWhere((a) => a.id == id);
      if (index != -1) {
        _daftarAlternatif[index].nama = nama;
      }
    } else {
      _daftarAlternatif.add(Alternatif(
          id: DateTime.now().millisecondsSinceEpoch.toString(), nama: nama));
    }
    _apakahHasilTersedia = false;
    notifyListeners();
    saveData();
  }

  void deleteAlternatif(String id) {
    _daftarAlternatif.removeWhere((a) => a.id == id);
    _nilai.remove(id);
    _apakahHasilTersedia = false;
    notifyListeners();
    saveData();
  }

  void submitNilai() {
    _apakahHasilTersedia = true;
    notifyListeners();
    saveData();
  }

  void updateNilai(String idAlternatif, String idKriteria, double nilaiInput) {
    if (!_nilai.containsKey(idAlternatif)) {
      _nilai[idAlternatif] = {};
    }
    _nilai[idAlternatif]![idKriteria] = nilaiInput;
  }

  double? getNilai(String idAlternatif, String idKriteria) =>
      _nilai[idAlternatif]?[idKriteria];

  Future<void> resetData() async {
    _daftarKriteria.clear();
    _daftarAlternatif.clear();
    _nilai.clear();
    _apakahHasilTersedia = false;
    notifyListeners();
    await saveData();
  }

  Future<void> clearAllNilai() async {
    _nilai.clear();
    _apakahHasilTersedia = false;
    notifyListeners();
    await saveData();
  }

  // ### FUNGSI BARU DITAMBAHKAN DI SINI ###
  Future<void> clearAllKriteria() async {
    _daftarKriteria.clear();
    _nilai.clear();
    _apakahHasilTersedia = false;
    print('Semua data kriteria dan nilai telah dihapus.');
    notifyListeners();
    await saveData();
  }

  Future<void> clearAllAlternatif() async {
    _daftarAlternatif.clear();
    _nilai.clear();
    _apakahHasilTersedia = false;
    print('Semua data alternatif dan nilai telah dihapus.');
    notifyListeners();
    await saveData();
  }
}
