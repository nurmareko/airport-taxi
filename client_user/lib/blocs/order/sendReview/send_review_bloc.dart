import 'package:client_user/data/dataSources/send_review_api_data.dart';
import 'package:client_user/data/models/request/send_review_request_model.dart';
import 'package:client_user/data/models/response/send_review_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'send_review_event.dart';
part 'send_review_state.dart';

class SendReviewBloc extends Bloc<SendReviewEvent, SendReviewState> {
  final SendReviewAPIData datasource;
  SendReviewBloc(this.datasource)
      : super(
          SendReviewInitial(),
        ) {
    on<LoadSendReviewEvent>((event, emit) async {
      emit(SendReviewLoading());
      try {
        final result = await datasource.sendReview(event.request);
        emit(SendReviewSuccess(model: result));
      } catch (e) {
        if (e is NewException) {
          print(e.errorMessage);
          emit(SendReviewFailure(
              errorMessage: e.errorMessage, email: e.additionalData));
        } else {
          print(e.toString());
          emit(SendReviewFailure(errorMessage: e.toString()));
        }
      }
    });
  }
}
