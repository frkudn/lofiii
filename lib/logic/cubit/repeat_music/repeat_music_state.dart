part of 'repeat_music_cubit.dart';

@immutable
 class RepeatMusicState extends Equatable{

  const RepeatMusicState({required this.repeatAll});
final bool repeatAll;

  RepeatMusicState copyWith({repeatAll}){
    return RepeatMusicState(repeatAll: repeatAll??this.repeatAll);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [repeatAll];



}

