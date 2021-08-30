import 'package:flutter/material.dart';
import 'package:cafeapp/page/tambah_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'dart:html';

class HalamanMenu extends StatefulWidget {
  HalamanMenu({Key? key}) : super(key: key);

  @override
  _HalamanMenuState createState() => _HalamanMenuState();
}

class _HalamanMenuState extends State<HalamanMenu> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _widht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('product').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snap.hasData && !snap.hasError) {
              return ListView.builder(
                itemCount: snap.data!.docs.length % 2 == 0
                    ? snap.data!.docs.length ~/ 2
                    : snap.data!.docs.length ~/ 2 + 1,
                itemBuilder: (context, index) {
                  // print(item[index]);
                  var f =
                      NumberFormat.currency(symbol: 'Rp. ', decimalDigits: 0);
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Container(
                            child: Card(
                              color: Color(0xFFecf0f1),
                              elevation: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: _widht * 0.4,
                                      height: 200,
                                      child: Image.network(
                                        snap.data!.docs[index * 2]['image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: Text(
                                      snap.data!.docs[index * 2]['name'],
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    child: Text(
                                      f
                                          .format(snap.data!.docs[index * 2]
                                              ['sell_price'])
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (index * 2 + 1 + 1 <= snap.data!.docs.length)
                          InkWell(
                            onTap: () {},
                            child: Container(
                              child: Card(
                                color: Color(0xFFecf0f1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: _widht * 0.4,
                                        height: 200,
                                        child: Image.network(
                                          snap.data!.docs[index * 2 + 1]
                                              ['image'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Text(
                                        snap.data!.docs[index * 2 + 1]['name'],
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Text(
                                        f
                                            .format(
                                                snap.data!.docs[index * 2 + 1]
                                                    ['sell_price'])
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("Data tidak ada"));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TambahMenu()));
        },
        tooltip: 'Tambah Menu',
        child: Icon(Icons.add),
      ),
    );
  }
}
