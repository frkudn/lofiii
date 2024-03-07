import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'repeat_music_state.dart';

class RepeatMusicCubit extends Cubit<RepeatMusicState> {
  RepeatMusicCubit() : super(const RepeatMusicState(repeatAll: true));


  repeatAll(){
    emit(state.copyWith(repeatAll: state.repeatAll?false:true));
  }
}
