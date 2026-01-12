import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  // Kita ambil status login-nya
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => WasteProvider()
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // Tambahkan ini
  const MyApp({super.key, required this.isLoggedIn}); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoCampus',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashScreen(), 
    );
  }
}

class WasteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _dataSampah = [];
  List<Map<String, dynamic>> _riwayatTukar = [];
  int _totalPoin = 0;

  List<Map<String, dynamic>> get dataSampah => _dataSampah;
  List<Map<String, dynamic>> get riwayatTukar => _riwayatTukar;
  int get totalPoin => _totalPoin;

  void tambahSetoran(String jenis, String berat, int poin) {
    _dataSampah.add({
      'jenis': jenis,
      'berat': berat,
      'poin': poin,
      'tanggal': DateTime.now().toString().split(' ')[0],
    });
    _hitungTotalPoin();
    notifyListeners();
  }

  void updateSetoran(int index, String jenis, String berat, int poin) {
    if (index >= 0 && index < _dataSampah.length) {
      _dataSampah[index] = {
        'jenis': jenis,
        'berat': berat,
        'poin': poin,
        'tanggal': _dataSampah[index]['tanggal'],
      };
      _hitungTotalPoin();
      notifyListeners();
    }
  }

  void hapusSetoran(int index) {
    _dataSampah.removeAt(index);
    _hitungTotalPoin();
    notifyListeners();
  }

  void tukarVoucher(String nama, int harga) {
    if (_totalPoin >= harga) {
      _totalPoin -= harga;
      _riwayatTukar.add({
        'nama': nama,
        'kode': 'ECO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'tanggal': DateTime.now().toString().split(' ')[0],
      });
      notifyListeners();
    }
  }

  void _hitungTotalPoin() {
    _totalPoin = _dataSampah.fold(0, (sum, item) => sum + (item['poin'] as int));
  }

}
