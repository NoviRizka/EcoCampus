import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WasteProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text("Profil & Voucher"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.dashboard_rounded, color: Colors.white),
              label: const Text("Dashboard", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 55, color: Colors.green),
                  ),
                  const SizedBox(height: 15),
                  const Text("Eco Warrior Campus", 
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("${provider.totalPoin} Poin Tersedia", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(25, 30, 25, 15),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: Text("Tukar Voucher Kantin", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),

            _buildRedeemTile(context, provider, "Voucher Es Teh Manis", 300, Icons.local_drink, Colors.orange),
            _buildRedeemTile(context, provider, "Voucher Snack Ringan", 400, Icons.fastfood, Colors.orange),
            _buildRedeemTile(context, provider, "Voucher Ayam Geprek", 1000, Icons.flatware, Colors.orange),
            
            const Divider(height: 50, thickness: 1, indent: 20, endIndent: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft, 
                child: Text("Voucher Saya", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
            ),

            provider.riwayatTukar.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.confirmation_number_outlined, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Belum ada voucher. Yuk kumpulkan poin!", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.riwayatTukar.length,
                    itemBuilder: (context, index) {
                      final v = provider.riwayatTukar[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.confirmation_number, color: Colors.green, size: 35),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text("KODE: ${v['kode']}", 
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2)),
                                ],
                              ),
                            ),
                            const Column(
                              children: [
                                Text("READY", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                Icon(Icons.check_circle, color: Colors.green, size: 20),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemTile(BuildContext context, WasteProvider provider, String nama, int harga, IconData icon, Color color) {
    bool cukup = provider.totalPoin >= harga;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cukup ? color.withOpacity(0.3) : Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: cukup ? color.withOpacity(0.1) : Colors.grey.shade100,
          child: Icon(icon, color: cukup ? color : Colors.grey),
        ),
        title: Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$harga Poin", style: TextStyle(color: cukup ? Colors.green : Colors.grey, fontWeight: FontWeight.w600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cukup ? color : Colors.grey.shade400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          onPressed: cukup ? () {
            provider.tukarVoucher(nama, harga);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Berhasil menukar $nama!"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              )
            );
          } : null,
          child: const Text("Tukar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

}
