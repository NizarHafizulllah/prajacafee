import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafeapp/api/firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:dropdown_search/dropdown_search.dart';

class TambahMenu extends StatefulWidget {
  TambahMenu({Key? key}) : super(key: key);

  @override
  _TambahMenuState createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  TextEditingController _nama = TextEditingController();
  var _harga = MoneyMaskedTextController(leftSymbol: 'Rp. ');

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UploadTask? task;
  File? file;

  @override
  void dispose() {
    _harga.dispose();
    _nama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    String? _pilihKategori;
    // _harga.updateValue(0.00);
    Widget _fileData = file != null
        ? Image.file(
            File(file!.path),
            fit: BoxFit.cover,
            width: double.infinity,
          )
        : Image.network(
            'https://image.freepik.com/free-vector/hand-drawn-delicious-food-background_52683-16136.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );

    double _size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Tambah Menu"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              Container(
                width: _size * .5,
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: selectFile,
                    child: _fileData,
                  ),
                ),
              ),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  items: ["Makanan", "Minuman", "Cemilan"],
                  label: "Kategori",
                  hint: "Kategori",
                  onChanged: (text) {
                    _pilihKategori = text;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              _textNama("Nama Menu", _nama),
              _textHarga("Harga", _harga),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                child: ElevatedButton(
                  onPressed: () {
                    var _stringNama = _nama.text;
                    var _angkaHarga = _harga.numberValue;
                    var _kategori = _pilihKategori;
                    simpan(_stringNama, _angkaHarga, _kategori);
                  },
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      Size(_size, 65),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Padding _textNama(String _fieldName, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      child: TextField(
        keyboardType: TextInputType.name,
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: _fieldName,
        ),
      ),
    );
  }

  Padding _textHarga(String _fieldName, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: _fieldName,
        ),
      ),
    );
  }

  Future simpan(String nama, double harga, String? kategori) async {
    if (file == null) return;

    var uuid = Uuid();
    var idString = uuid.v1();

    final fileName = basename(file!.path);
    final destination = 'files/$idString$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    CollectionReference _foodRef = firestore.collection('product');

//   var addYourDoc = firestore.collection('tasks').add({
//   'food_name': nama,
//       'food_price': harga,
//       'food_category': kategori,
//       'food_image': urlDownload,
// }).then(task => {
//   console.log('document ID: ', ref.id);
// });

    DocumentReference newPostRef = await _foodRef.add({
      'name': nama,
      'price': harga.toInt(),
      'sell_price': harga.toInt(),
      'image': urlDownload,
    });

    file = null;

    _harga.updateValue(0.00);
    _nama.clear();
    var postId = newPostRef.id;

    setState(() {});
    print(postId);
  }
}
