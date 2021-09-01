import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HalamanPesan extends StatefulWidget {
  final num noMeja;
  HalamanPesan({Key? key, required this.noMeja}) : super(key: key);

  @override
  _HalamanPesanState createState() => _HalamanPesanState();
}

class _HalamanPesanState extends State<HalamanPesan> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double _widht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pesanan Meja ${widget.noMeja.toString()}"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('cart')
              .where("status", isEqualTo: 0)
              .where("table", isEqualTo: widget.noMeja)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasData && !snap.hasError) {
              return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  var f = NumberFormat.currency(
                    symbol: 'Rp. ',
                    decimalDigits: 0,
                  );
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        child: Card(
                          color: Color(0xFFecf0f1),
                          elevation: 5,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: _widht * 0.9,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: _widht * 0.3,
                                        child: Image.network(
                                          snap.data!.docs[index]['image'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 0),
                                          child: AutoSizeText(
                                            "Meja " +
                                                snap.data!.docs[index]['table']
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          width: _widht * 0.4,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: AutoSizeText(
                                              snap.data!.docs[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w700),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: AutoSizeText(
                                            snap.data!.docs[index]['qty']
                                                    .toString() +
                                                " x " +
                                                f
                                                    .format(
                                                        snap.data!.docs[index]
                                                            ['sell_price'])
                                                    .toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: AutoSizeText(
                                            f
                                                .format(snap.data!.docs[index]
                                                    ['total_price'])
                                                .toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.check),
                                      iconSize: 35,
                                      color: Colors.green,
                                      onPressed: () async {
                                        await snap.data!.docs[index].reference
                                            .update({"status": 1});
                                        num _totalJumlah = 0;
                                        await FirebaseFirestore.instance
                                            .collection('total')
                                            .doc('penjualan')
                                            .get()
                                            .then((documentSnapshot) {
                                          _totalJumlah =
                                              documentSnapshot['total_jual'];
                                          var _tambahan = snap.data!.docs[index]
                                              ['total_price'];
                                          _totalJumlah =
                                              _totalJumlah + _tambahan;
                                          documentSnapshot.reference.update(
                                              {"total_jual": _totalJumlah});
                                          // print(_total_jual);
                                        });
                                        // print(_total_jual.toString());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No Data'),
              );
            }
          },
        ),
      ),
    );
  }
}
