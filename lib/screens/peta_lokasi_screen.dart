import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class PetaLokasiScreen extends StatefulWidget {
  final String berat;
  final String jenis;
  final int poin;

  const PetaLokasiScreen({super.key, required this.berat, required this.jenis, required this.poin});

  @override
  State<PetaLokasiScreen> createState() => _PetaLokasiScreenState();
}

class _PetaLokasiScreenState extends State<PetaLokasiScreen> {
  // MENAMBAHKAN BEBERAPA TITIK LOKASI BARU
  final List<Map<String, dynamic>> daftarLokasi = [
    {'nama': 'Bank Sampah Gedung A', 'jarak': '200m', 'lat': 0.25, 'long': 0.2, 'wa': '628123456789'},
    {'nama': 'Eco Point Gedung C', 'jarak': '450m', 'lat': 0.5, 'long': 0.7, 'wa': '628987654321'},
    {'nama': 'Pusat Daur Ulang FT', 'jarak': '1.2km', 'lat': 0.15, 'long': 0.5, 'wa': '628112233445'},
    {'nama': 'Dropbox Sampah Perpus', 'jarak': '800m', 'lat': 0.35, 'long': 0.45, 'wa': '628121111222'},
    {'nama': 'Eco Center Asrama', 'jarak': '1.5km', 'lat': 0.6, 'long': 0.3, 'wa': '628133344455'},
  ];

  late Map<String, dynamic> lokasiTerpilih;

  @override
  void initState() {
    super.initState();
    lokasiTerpilih = daftarLokasi[0];
  }

  // Perbaikan Fungsi WhatsApp agar tidak error
  Future<void> _hubungiPetugas(String nomor) async {
    final msg = "Halo Petugas ${lokasiTerpilih['nama']}, saya ingin setor ${widget.jenis} seberat ${widget.berat}kg.";
    final Uri url = Uri.parse("https://wa.me/$nomor?text=${Uri.encodeComponent(msg)}");
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuka WhatsApp. Pastikan aplikasi terpasang."))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi Setor"), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Stack(
        children: [
          Container(color: Colors.green.shade50), // Simulasi Map

          // Menampilkan semua titik lokasi
          ...daftarLokasi.map((lokasi) {
            bool isSelected = lokasi['nama'] == lokasiTerpilih['nama'];
            return Positioned(
              left: MediaQuery.of(context).size.width * lokasi['long'],
              top: MediaQuery.of(context).size.height * lokasi['lat'],
              child: GestureDetector(
                onTap: () => setState(() => lokasiTerpilih = lokasi),
                child: Column(
                  children: [
                    Icon(Icons.location_on, size: isSelected ? 50 : 40, color: isSelected ? Colors.green : Colors.redAccent),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: Text(lokasi['nama'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            );
          }),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lokasiTerpilih['nama'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("📍 Jarak: ${lokasiTerpilih['jarak']}", style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _hubungiPetugas(lokasiTerpilih['wa']),
                          icon: const Icon(Icons.chat_bubble_outline, color: Colors.green), // Ikon diperbaiki
                          label: const Text("Chat Petugas"),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.green)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<WasteProvider>(context, listen: false).tambahSetoran(widget.jenis, widget.berat, widget.poin);
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          child: const Text("Konfirmasi"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}