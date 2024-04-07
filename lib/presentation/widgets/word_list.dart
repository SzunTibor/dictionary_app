import 'dart:math';

import 'package:dictionary_app_cont/domain/domain_api.dart';
import 'package:flutter/material.dart';

class WordListView extends StatelessWidget {
  final List<Word> words;
  final String titleText;
  final void Function(DismissDirection, Word)? onDismissed;
  final ScrollController? controller;

  const WordListView(
      {super.key,
      required this.words,
      required this.titleText,
      this.onDismissed,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverAppBar.medium(
          automaticallyImplyLeading: false,
          floating: true,
          stretch: true,
          backgroundColor: Colors.blueGrey.shade700,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      titleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      words
                          .where((word) => word.isAccepted)
                          .fold<int>(0, (a, c) => a + c.value)
                          .toString(),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];

            Widget child = Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Material(
                type: MaterialType.card,
                borderRadius: BorderRadius.circular(8),
                elevation: 4,
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              word.text,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 64,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: 3,
                                style: BorderStyle.solid,
                                color: switch (word.state) {
                                  WordState.pending => Colors.white,
                                  WordState.rejected => Colors.red,
                                  WordState.duplicate => Colors.orange,
                                  WordState.accepted => Colors.green,
                                },
                              )),
                          child: Center(
                            child: Text(
                              word.isPending ? '' : word.value.toString(),
                              maxLines: 1,
                              // textScaler: const TextScaler.linear(2),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            if (onDismissed != null) {
              child = Dismissible(
                key: Key('${word.text}-${word.state}'),
                onDismissed: (direction) => onDismissed!(direction, word),
                background: Container(
                  color: Colors.red.shade50,
                ),
                child: child,
              );
            }
            return child;
          },
        )
      ],
    );
  }
}
