import 'package:flutter/material.dart';

class AudiobookScreen extends StatelessWidget {
  const AudiobookScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(child: Center(child: Text("Audiobook:$id"))),
      ),
    );
  }
}
