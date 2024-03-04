part of 'check_internet_connection_bloc.dart';

@immutable
abstract class CheckInternetConnectionState {}

class CheckInternetConnectionInitial extends CheckInternetConnectionState {}
class NoInternetConnectionState extends CheckInternetConnectionState {}
