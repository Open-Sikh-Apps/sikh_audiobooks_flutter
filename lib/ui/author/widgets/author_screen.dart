import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sikh_audiobooks_flutter/routing/routes.dart';

class AuthorScreen extends StatelessWidget {
  const AuthorScreen({super.key, required this.id});
  final String id;
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
                Text("Author:$id"),
                FilledButton(
                  onPressed: () {
                    context.push(Routes.audiobookWithId("1"));
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
