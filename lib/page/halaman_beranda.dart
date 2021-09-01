import 'package:cafeapp/page/halaman_meja.dart';
import 'package:cafeapp/page/halaman_menu.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({Key? key}) : super(key: key);

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
          Container(
            padding: EdgeInsets.all(20),
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HalamanMenu()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
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
                    MaterialPageRoute(builder: (context) => HalamanMeja()));
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
