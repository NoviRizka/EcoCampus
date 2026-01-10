import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'login_screen.dart';
import 'input_sampah_screen.dart';
import 'account_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WasteProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8FAF8),
      appBar: AppBar(
        title: Text("EcoCampus", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.green, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 220,
                  constraints: BoxConstraints(maxWidth: 800),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selamat Datang,", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(
                      "Eco Warrior! 👋",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // KARTU POIN
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade400],
                ),
              ),
              child: Column(
                children: [
                  Text("TOTAL ECO-POIN",
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    "${provider.totalPoin}",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text("Poin Aktif", style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(25, 25, 25, 10), 
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Riwayat Setoran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            provider.dataSampah.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text("Belum ada riwayat setoran.", style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: provider.dataSampah.length,
                    itemBuilder: (context, index) {
                      final item = provider.dataSampah[index];
                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade50,
                            child: Icon(Icons.recycling, color: Colors.green),
                          ),
                          title: Text("${item['jenis']} (${item['berat']} kg)", 
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item['tanggal']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_note, color: Colors.blue),
                                onPressed: () => _showEditDialog(context, index, item),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => provider.hapusSetoran(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InputSampahScreen()),
          );
        },
        label: Text("SETOR SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: Icon(Icons.add),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, Map data) {
    TextEditingController controller = TextEditingController(text: data['berat'].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Edit Berat (${data['jenis']})"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "Berat baru (kg)", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
          ElevatedButton(
            onPressed: () {
              double berat = double.tryParse(controller.text) ?? 0;
              int poinBaru = (berat * 100).toInt();
              Provider.of<WasteProvider>(context, listen: false)
                  .updateSetoran(index, data['jenis'], controller.text, poinBaru);
              Navigator.pop(context);
            },
            child: Text("Simpan"),
          )
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Logout"),
          content: Text("Yakin ingin keluar?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pop(dialogContext);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: Text("Keluar"),
            ),
          ],
        );
      },
    );
  }
}