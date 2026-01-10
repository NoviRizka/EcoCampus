import 'package:flutter/material.dart';
import 'peta_lokasi_screen.dart';

class InputSampahScreen extends StatefulWidget {
  const InputSampahScreen({super.key});

  @override
  State<InputSampahScreen> createState() => _InputSampahScreenState();
}

class _InputSampahScreenState extends State<InputSampahScreen> {
  final TextEditingController beratController = TextEditingController();
  String? jenisTerpilih;
  int estimasi = 0;

  // Daftar kategori sampah yang umum di kampus
  final List<String> daftarJenis = [
    "Plastik (Botol/Gelas)",
    "Kertas/Karton",
    "Kaleng/Logam",
  ];

  // FUNGSI PERHITUNGAN: 1 KG = 100 POIN
  void updatePoin(String value) {
    setState(() {
      double berat = double.tryParse(value) ?? 0;
      // Rumus: Berat x 100
      estimasi = (berat * 100).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setor Sampah"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Jenis Sampah",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 15),

            // Choice Chips untuk pilihan jenis (Modern)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: daftarJenis.map((jenis) {
                return ChoiceChip(
                  label: Text(jenis),
                  selected: jenisTerpilih == jenis,
                  onSelected: (selected) {
                    setState(() {
                      jenisTerpilih = selected ? jenis : null;
                    });
                  },
                  selectedColor: Colors.green.shade100,
                  checkmarkColor: Colors.green,
                  labelStyle: TextStyle(
                    color: jenisTerpilih == jenis ? Colors.green.shade900 : Colors.black87,
                    fontWeight: jenisTerpilih == jenis ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),
            const Text(
              "Berat Sampah (kg)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            
            // Input Berat
            TextField(
              controller: beratController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: updatePoin,
              decoration: InputDecoration(
                hintText: "Contoh: 1.5",
                suffixText: "Kg",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.scale_rounded, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.green.shade100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.green.shade100),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // CARD ESTIMASI POIN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade700, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "ESTIMASI POIN ANDA",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$estimasi",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Rate: 1 Kg = 100 Poin",
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tombol ke Peta
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (jenisTerpilih == null || estimasi == 0)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetaLokasiScreen(
                              berat: beratController.text,
                              jenis: jenisTerpilih!,
                              poin: estimasi,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text(
                  "CARI TITIK SETOR TERDEKAT",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}