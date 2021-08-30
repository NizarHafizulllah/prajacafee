import 'package:flutter/material.dart';
import 'package:cafeapp/page/halaman_menu.dart';
import 'package:cafeapp/page/halaman_pesan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HalamanBerandaBaru extends StatefulWidget {
  HalamanBerandaBaru({Key? key}) : super(key: key);

  @override
  _HalamanBerandaBaruState createState() => _HalamanBerandaBaruState();
}

class _HalamanBerandaBaruState extends State<HalamanBerandaBaru> {
  var f = NumberFormat.currency(symbol: 'Rp. ', decimalDigits: 0);
  String total_harga = "0";

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    @override
    void initState() {
      // TODO: implement initState
      // get_data();
      super.initState();
    }

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
                  total_harga,
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                IconButton(
                    onPressed: () async {
                      num total = 12;
                      await FirebaseFirestore.instance
                          .collection('total')
                          .doc('penjualan')
                          .get()
                          .then((DocumentSnapshot) {
                        total = DocumentSnapshot['total_jual'];
                        print(total);
                      });

                      total_harga = f.format(total).toString();

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
                elevation: 10,
                child: Container(
                  height: _height * 0.2,
                  child: Center(
                    child: Text(
                      "Daftar Menu",
                      style: TextStyle(fontSize: 30),
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
                    MaterialPageRoute(builder: (context) => HalamanPesan()));
              },
              child: Card(
                elevation: 10,
                child: Container(
                  height: _height * 0.2,
                  child: Center(
                    child: Text(
                      "Pesanan",
                      style: TextStyle(fontSize: 30),
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
