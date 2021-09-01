import 'package:auto_size_text/auto_size_text.dart';
import 'package:cafeapp/page/halaman_pesan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HalamanMeja extends StatefulWidget {
  HalamanMeja({Key? key}) : super(key: key);

  @override
  _HalamanMejaState createState() => _HalamanMejaState();
}

class _HalamanMejaState extends State<HalamanMeja> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesanan"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              db.collection('cart').where("status", isEqualTo: 0).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List meja = [
              {"meja": 1, "total": 0},
              {"meja": 2, "total": 0},
              {"meja": 3, "total": 0},
              {"meja": 4, "total": 0},
              {"meja": 5, "total": 0}
            ];
            List dataPesanan = snapshot.data!.docs.toList();
            dataPesanan.asMap().forEach((index, obj) async {
              meja[obj['table'] - 1]['total'] =
                  meja[obj['table'] - 1]['total'] + obj['total_price'];

              print(obj['table'].toString());
            });

            return ListView.builder(
              itemCount: meja.length,
              itemBuilder: (context, index) {
                var f = NumberFormat.currency(
                  symbol: 'Rp. ',
                  decimalDigits: 0,
                );
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HalamanPesan(noMeja: meja[index]['meja'])));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(colors: [
                                Color(0xFFDE6161),
                                Color(0xFF2657EB)
                              ])),
                          width: _width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 8, 0),
                                child: AutoSizeText(
                                  "Meja " + meja[index]['meja'].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                width: _width * 0.4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: AutoSizeText(
                                    "Total " + f.format(meja[index]['total']),
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
