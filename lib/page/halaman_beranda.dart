import 'package:cafeapp/page/halaman_menu.dart';
import 'package:cafeapp/page/halaman_pesan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    num _total_jual = 0;

    get_data() async {
      await FirebaseFirestore.instance
          .collection('total')
          .doc('penjualan')
          .get()
          .then((DocumentSnapshot) {
        num _total_jual = DocumentSnapshot['total_jual'];
        // setState(() {});
        // print(_total_jual);
      });
    }

    @override
    void initState() {
      // TODO: implement initState
      get_data();
      // super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
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
