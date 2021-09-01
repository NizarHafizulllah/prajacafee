import 'package:auto_size_text/auto_size_text.dart';
import 'package:cafeapp/page/halaman_meja.dart';
import 'package:flutter/material.dart';
import 'package:cafeapp/page/halaman_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HalamanBerandaBaru extends StatefulWidget {
  HalamanBerandaBaru({Key? key}) : super(key: key);

  @override
  _HalamanBerandaBaruState createState() => _HalamanBerandaBaruState();
}

class _HalamanBerandaBaruState extends State<HalamanBerandaBaru> {
  var f = NumberFormat.currency(symbol: 'Rp. ', decimalDigits: 0);
  String totalHarga = "0";

  _getData() async {
    // num total = 0;
    num totalGet = await FirebaseFirestore.instance
        .collection('total')
        .doc('penjualan')
        .get()
        .then((documentSnapshot) {
      return documentSnapshot['total_jual'];
    });

    totalHarga = f.format(totalGet).toString();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  totalHarga,
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                IconButton(
                    onPressed: () async {
                      _getData();
                      setState(() {});
                    },
                    icon: Icon(Icons.replay)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HalamanMenu()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          colors: [Color(0xFFDE6161), Color(0xFF2657EB)])),
                  height: _height * 0.2,
                  child: Center(
                    child: AutoSizeText(
                      "Daftar Menu",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HalamanMeja()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          colors: [Color(0xFFDE6161), Color(0xFF2657EB)])),
                  height: _height * 0.2,
                  child: Center(
                    child: AutoSizeText(
                      "Pesanan",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
