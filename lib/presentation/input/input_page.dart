import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:dictionary_app_cont/presentation/input/bloc/input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di_container.dart';
import '../widgets/word_list.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _editingFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => di<InputBloc>(),
      child: Column(
        children: [
          BlocBuilder<InputBloc, InputState>(
            builder: (context, state) {
              return switch (state) {
                WordsInputState() => Expanded(
                    child: WordListView(
                      words: state.words,
                      titleText: 'Total new points:',
                      controller: _scrollController,
                      onDismissed: (DismissDirection direction, Word word) =>
                          context
                              .read<InputBloc>()
                              .add(DeleteWordsEvent(words: [word])),
                    ),
                  ),
              };
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Builder(builder: (context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextField(
                controller: _editingController,
                focusNode: _editingFocus,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1024),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z\s,\.]*'))
                ],
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onSubmitted: (String value) {
                  if (value.isEmpty) return;
                  context.read<InputBloc>().add(SubmitWordsEvent(text: value));
                  _editingController.text = '';
                  _editingFocus.requestFocus();
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease);
                  }
                },
              ),
            );
          }),
          const SizedBox(
            height: 16,
          ),
          Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () =>
                  context.read<InputBloc>().add(const SaveListEvent()),
              child: Text(
                'Save to Dictionary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
