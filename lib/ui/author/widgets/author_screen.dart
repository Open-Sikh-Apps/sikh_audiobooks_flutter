import 'package:duck_router/duck_router.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/routing/router.dart';
import 'package:sikh_audiobooks_flutter/ui/author/viewmodels/author_view_model.dart';

class AuthorScreen extends StatelessWidget {
  AuthorScreen({super.key, required this.viewModel});
  final _log = Logger();
  final AuthorViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Author:$viewModel"),
                FilledButton(
                  onPressed: () {
                    DuckRouter.of(
                      context,
                    ).navigate(to: AudiobookLocation("test_id"));
                  },
                  child: Text("Book 1"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
