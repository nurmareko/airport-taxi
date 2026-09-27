part of 'get_customer_bloc.dart';

@immutable
sealed class GetCustomerEvent {}

class LoadGetCustomer extends GetCustomerEvent {}