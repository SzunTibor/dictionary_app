import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:dictionary_app_cont/presentation/input/bloc/input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di_container.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<InputBloc>(),
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 72, top: 16, left: 16, right: 16),
        child: Column(
          children: [
            BlocBuilder<InputBloc, InputState>(
              builder: (context, state) {
                return switch (state) {
                  InitialInputState() => const SizedBox.expand(),
                  WordsInputState() =>
                    Expanded(child: WordList(words: state.words)),
                };
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Builder(builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (String value) => context
                      .read<InputBloc>()
                      .add(SubmitWordsEvent(text: value)),
                ),
              );
            }),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('save'),
            ),
          ],
        ),
      ),
    );
  }
}

class WordList extends StatelessWidget {
  final List<Word> words;

  const WordList({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    final maxValue = context.read<InputBloc>().dictionaryInfo.maxWordLength / 3;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar.medium(
          automaticallyImplyLeading: false,
          floating: true,
          stretch: true,
          backgroundColor: Colors.blueAccent,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Total new points:'),
                  Text(words.fold<int>(0, (a, c) => a + c.value).toString()),
                ],
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                key: Key('${word.text}-${word.state}'),
                color: word.isPending
                    ? Colors.white
                    : Colors.green.withOpacity(word.value / maxValue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(word.text),
                      Text(
                        word.isPending ? '' : word.value.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
