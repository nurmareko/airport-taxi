import 'package:airport_taxi_sharing_user_client/data/dataSources/send_Review_api_data.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/send_review_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/send_Review_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
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
