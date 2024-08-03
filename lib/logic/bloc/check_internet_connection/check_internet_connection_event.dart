part of 'check_internet_connection_bloc.dart';

@immutable
abstract class CheckInternetConnectionEvent {}


class NoInternetConnectionEvent extends CheckInternetConnectionEvent{}
class InternetConnectionRestoredEvent extends CheckInternetConnectionEvent{}
