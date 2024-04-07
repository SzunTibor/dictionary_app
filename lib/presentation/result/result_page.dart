import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di_container.dart';
import '../widgets/word_list.dart';
import 'bloc/result_bloc.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<ResultBloc>(),
      child: SizedBox.expand(
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<ResultBloc, ResultState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      switch (state) {
                        InitialResultState() => const SizedBox(),
                        WordsResultState() => Expanded(
                            child: WordListView(
                                words: state.list, titleText: 'Total value:'),
                          ),
                      },
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              width: 48,
            ),
          ],
        ),
      ),
    );
  }
}
