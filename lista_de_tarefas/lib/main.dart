import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

class PerfilUsuario extends StatelessWidget {
  const PerfilUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 148,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 50,
            foregroundImage: NetworkImage(
              'https://get.pxhere.com/photo/man-person-hair-white-profile-male-portrait-model-young-hairstyle-smile-beard-face-glasses-head-moustache-eyewear-photo-shoot-facial-hair-vision-care-451653.jpg',
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'João Silva',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Dev FullStack',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Compositor nas horas vagas',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
