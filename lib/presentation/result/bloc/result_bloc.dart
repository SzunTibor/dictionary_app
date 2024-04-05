import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain_api.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  ResultBloc() : super(const InitialResultState()) {
    on<ResultEvent>((event, emit) => switch (event) {
          FilterByEvent() => _onFilterBy(event),
        });
  }

  Future<void> _onFilterBy(FilterByEvent event) async {

  }
}
