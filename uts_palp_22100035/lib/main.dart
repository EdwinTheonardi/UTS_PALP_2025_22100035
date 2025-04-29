import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_palp_22100035/firebase_option.dart';
import 'add_note_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('code', 22100035);
  await prefs.setString('name', 'Edwin');
  }
  
  saveData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daftar Penerimaan Barang",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotesPage(),
    );
  }
}

class _MyAppState extends State {
  int code = 0;
  String name = "";

  @override
  Widget build(BuildContext context) {
    void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      code = prefs.getInt("code")!;
      name = prefs.getString("name")!;
    });
    }
  getFromSharedPreferences();
  }
}

class NotesPage extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;
  final snapshot = firestore.collection('purchaseGoodsReceipts').get()

  NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Penerimaan Barang"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              tooltip: "Tambah Daftar",
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => AddNotePage())
                );
              },
            )
          ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notes.orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Belum ada catatan."));
          }

          final docs = snapshot.data!.docs;

          // final filteredDocs = docs.where((doc) {
          //   final data = doc.data() as Map<String, dynamic>;
          //   return data['author'] == 'Edwin';
          // }).toList();

          // if (filteredDocs.isEmpty) {
          //   return Center(child: Text("Belum ada catatan."));
          // }

          return ListView(
            children: docs.map((DocumentSnapshot document) {
              final data = document.data()! as Map <String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['no_form'] ?? '-'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Created At: ${data['created_at'] ?? '-'}",
                      ),
                      Text(
                        "Grand Total: ${data['grand-total'] ?? '-'}",
                      ),
                    
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: "Hapus Catatan",
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, document.id);
                        },
                      ),
                      // data['synced'] == true
                      //   ? Icon(Icons.cloud_done, color: Colors.green)
                      //   : Icon(Icons.cloud_off, color: Colors.grey),
                    ],
                  ),
                  ),
                );
            }).toList(),
          );
        },
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah kamu yakin ingin menghapus catatan ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteNote(context, documentId);
              Navigator.of(context).pop();
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteNote(BuildContext context, String documentId) async {
  try {
    await FirebaseFirestore.instance.collection('notes').doc(documentId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan berhasil dihapus')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menghapus catatan')),
    );
  }
}