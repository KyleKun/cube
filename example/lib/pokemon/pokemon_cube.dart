import 'package:cubes/cubes.dart';
import 'package:examplecube/pokemon/repository/model/pokemon.dart';
import 'package:examplecube/pokemon/repository/pokemon_repository.dart';

class PokemonCube extends Cube {
  static const LIMIT_PAGE = 20;
  final PokemonRepository repository;

  PokemonCube(this.repository);

  final list = ObservableList<Pokemon>(value: []);
  final progress = ObservableValue<bool>(value: false);

  @override
  void ready() {
    fetchPokemonList();
    super.ready();
  }

  void fetchPokemonList({bool isMore = false}) {
    if (progress.value) return;
    int page = 0;
    if (isMore) page = (list.length ~/ LIMIT_PAGE) + 1;
    progress.update(true);
    repository
        .getPokemonList(page: page, limit: LIMIT_PAGE)
        .then((value) {
          if (isMore) return list.addAll(value);
          list.update(value);
        })
        .catchError((error) => onAction(CubeErrorAction(text: error.toString())))
        .whenComplete(() => progress.update(false));
  }
}
