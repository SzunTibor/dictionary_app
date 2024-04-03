import '../../domain/domain_api.dart';

enum WordPresentationState {
  pending,
  rejected,
  accepted,
}

class WordPresentation extends Word {
  final WordPresentationState state;

  const WordPresentation(
      {required super.text, required super.value, required this.state});
}
