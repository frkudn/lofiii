part of 'greeting_cubit.dart';

@immutable
 class GreetingState extends Equatable{
  final String greeting;

  const GreetingState({required this.greeting});
  GreetingState copyWith({greeting}){
    return GreetingState(greeting: greeting??this.greeting);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [greeting];
}


