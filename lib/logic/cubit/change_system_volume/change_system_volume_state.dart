// ignore_for_file: must_be_immutable

part of 'change_system_volume_cubit.dart';


class ChangeSystemVolumeState extends Equatable {
  ChangeSystemVolumeState({required this.volume});
  double volume = 0.4;

  ChangeSystemVolumeState copyWith({volume}){
    return ChangeSystemVolumeState(volume: volume?? this.volume);
  }

  @override
  List<Object?> get props => [volume];
}
