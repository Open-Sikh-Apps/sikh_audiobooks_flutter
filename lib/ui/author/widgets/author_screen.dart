import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sikh_audiobooks_flutter/main.dart';
import 'package:sikh_audiobooks_flutter/routing/router.gr.dart';
import 'package:sikh_audiobooks_flutter/ui/audiobook/viewmodels/audiobook_view_model.dart';
import 'package:sikh_audiobooks_flutter/ui/author/viewmodels/author_view_model.dart';

@RoutePage()
class AuthorScreen extends StatelessWidget {
  AuthorScreen({super.key, required this.viewModel}) {
    final log = Logger();
    log.d("AuthorScreen called with viewmode:$viewModel");
  }
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
                    // context.push(Routes.audiobookWithId("1"));
                    context.navigateTo(
                      AudiobookRoute(
                        viewModel: AudiobookViewModel(
                          audiobooksRepository: getIt(),
                          id: "test_id",
                        ),
                      ),
                    );
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
