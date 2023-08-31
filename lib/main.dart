import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: Scaffold(body: Text('Olá, mundo!'))));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Iniciando MyApp");  // <--- Adicione esta linha
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final picker = ImagePicker();
  final databaseRef = FirebaseDatabase.instance.reference();
  
  Future<void> uploadPicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String filePath = 'images/${DateTime.now().toIso8601String()}.png';
      await FirebaseStorage.instance.ref(filePath).putFile(image);
      databaseRef.child(filePath).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enviar Foto')),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadPicture,
          child: Text('Tirar Foto e Enviar'),
        ),
      ),
    );
  }
}

