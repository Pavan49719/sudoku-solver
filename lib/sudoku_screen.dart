import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? imageFile;
  TextEditingController? url = TextEditingController();
  String? result;
  bool loading = false;
  List solved = [];
  List unsolved = [];
  var location;

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPic() async {
    //Create a reference to the location you want to upload to in firebase
    Reference reference = _storage.ref().child("images/");

    UploadTask uploadTask = reference.putFile(imageFile!);

    location = await (await uploadTask).ref.getDownloadURL();
    print("LOCATION: $location");
    solveSudoku();
    return location;
  }

  Future<void> solveSudoku() async {
    setState(() {
      loading = true;
      result = null;
      solved = [];
      unsolved = [];
      solvednumlist = [];
      unsolvednumlist = [];
    });
    print("URL: ${url!.text}");
    String temp = url?.text ?? location;
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://trf-sudokusolver.herokuapp.com/sudokusolver/${temp}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var temp = await response.stream.bytesToString();
      // print("TEMP: $temp");
      setState(() {
        result = temp;
      });
      Map valueMap = json.decode(result!);
      setState(() {
        solved = json.decode(valueMap['solved']);
        unsolved = json.decode(valueMap['unsolved']);
      });
      print("SOLVED: ${solved.runtimeType}\n$solved");
      print("UNSOLVED: ${unsolved.runtimeType}\n$unsolved");
      tablecreator();
      setState(() {
        loading = false;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid URL')));
      setState(() {
        loading = false;
      });
      print(response.reasonPhrase);
    }
  }

  List<number> unsolvednumlist = [];
  List<number> solvednumlist = [];

  tablecreator() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        unsolvednumlist.add(number(num: unsolved[i][j].toString()));
        solvednumlist.add(number(num: solved[i][j].toString()));
      }
    }
  }

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Firebase.initializeApp().whenComplete(() {
  //     print("completed");
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Container(
                  width: 250,
                  child: TextFormField(
                    controller: url,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Paste jpeg url here',
                    ),
                    cursorRadius: Radius.circular(15),
                  ),
                ),
              ),
              ElevatedButton(onPressed: solveSudoku, child: Icon(Icons.search))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: _getFromCamera, child: Text('From Camera')),
              ElevatedButton(
                  onPressed: _getFromGallery, child: Text('From Gallery')),
              imageFile != null
                  ? ElevatedButton(
                      onPressed: uploadPic,
                      child: Text(
                        'Upload',
                      ))
                  : Container(),
            ],
          ),
          result != null
              ? Column(
                  children: [
                    Text(
                      'Unsolved Sudoku',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(58, 4, 58, 4),
                        child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 9,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2),
                          children: unsolvednumlist,
                        ),
                      ),
                    ),
                    Text(
                      'Solved Sudoku',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(58, 4, 58, 4),
                        child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 9,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2),
                          children: solvednumlist,
                        ),
                      ),
                    ),
                  ],
                )
              : loading == true
                  ? CircularProgressIndicator()
                  : Container(),
        ]),
      ),
    );
  }
}

class number extends StatelessWidget {
  String num;
  number({required this.num});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(num)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
    );
  }
}
