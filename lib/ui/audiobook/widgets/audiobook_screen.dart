import 'package:flutter/material.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/audiobook_view_model.dart';

class AudiobookScreen extends StatelessWidget {
  const AudiobookScreen({super.key, required this.viewModel});
  final AudiobookViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(child: Center(child: Text("Audiobook:$viewModel"))),
      ),
    );
  }
}
