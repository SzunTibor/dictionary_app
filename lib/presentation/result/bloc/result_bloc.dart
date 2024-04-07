import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain_api.dart';
import '../../snackbar/SnackBarService.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final DictionaryService _dservice;
  final SnackBarService _snackBarService;

  DictionaryInfo get dictionaryInfo => _dservice.dictionaryInfo;

  ResultBloc(this._dservice, this._snackBarService)
      : super(const WordsResultState(list: [])) {
    on<ResultEvent>((event, emit) => switch (event) {
          FilterByEvent() => _onFilterBy(event, emit),
        });

    add(FilterByEvent(dictionaryInfo.joker));
  }

  Future<void> _onFilterBy(
      FilterByEvent event, Emitter<ResultState> emit) async {
    try {
      final result = await _dservice.filterBy(event.prefix);
      switch (result.type) {
        case ResponseType.error:
        case ResponseType.warning:
          emit(ErrorResultState(message: result.message, list: []));
          _snackBarService.showSnackBar(
              ErrorSnackBarRequest('An error occured during filtering.'));
          break;
        case ResponseType.success:
          emit(WordsResultState(list: result.value));
      }
    } catch (error) {
      emit(ErrorResultState(message: error.toString(), list: []));
      emit(const WordsResultState(list: []));
      _snackBarService.showSnackBar(
          ErrorSnackBarRequest('An error occured during filtering.'));
    }
  }
}
