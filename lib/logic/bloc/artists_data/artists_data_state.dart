
import 'package:equatable/equatable.dart';

import '../../../data/models/artist_model.dart';

abstract class ArtistsDataState extends Equatable {}

class ArtistsDataInitialState extends ArtistsDataState {
  @override
  List<Object?> get props => [];
}


class ArtistsDataLoadingState extends ArtistsDataState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ArtistsDataSuccessState extends ArtistsDataState{


  final List<ArtistModel> artistList;

  ArtistsDataSuccessState({required this.artistList});

  @override
  // TODO: implement props
  List<Object?> get props => [artistList];
}


class ArtistsDataFailureState extends ArtistsDataState{


  final String errorMessage;

  ArtistsDataFailureState({required this.errorMessage});
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
