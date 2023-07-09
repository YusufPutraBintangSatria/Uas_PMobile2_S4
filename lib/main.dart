import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String apiUrl = 'http://dev.farizdotid.com/api/daerahindonesia/provinsi';

  Future<List<dynamic>> fetchData() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> provinsi = data['provinsi'];
      return provinsi;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Nama Provinsi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false, // Hapus tulisan "debug"
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Provinsi Di Indonesia',
            style: TextStyle(
              color: Colors.white, // Ubah warna teks menjadi putih
              fontSize: 20.0, // Ukuran teks judul
              fontWeight: FontWeight.bold, // Ketebalan teks judul
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var provinsi = snapshot.data![index];
                    var nomorProvinsi = index + 1;

                    return Card(
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(
                          '$nomorProvinsi. ${provinsi['nama']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
