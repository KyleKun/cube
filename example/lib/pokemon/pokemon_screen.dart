import 'package:cubes/cubes.dart';
import 'package:examplecube/pokemon/pokemon_cube.dart';
import 'package:examplecube/pokemon/repository/model/pokemon.dart';
import 'package:examplecube/pokemon/widgets/pokemon_item_widget.dart';
import 'package:flutter/material.dart';

class PokemonScreen extends CubeWidget<PokemonCube> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget buildView(BuildContext context, PokemonCube cube) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Pokemons with CubeWidget'),
      ),
      body: Stack(
        children: <Widget>[
          cube.list.build<List<Pokemon>>(
            (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  if (index >= data.length - 3) {
                    cube.fetchPokemonList(isMore: true);
                  }
                  return PokemonItemWidget(
                    item: data[index],
                    onClick: (item) {},
                  );
                },
              );
            },
          ),
          cube.progress.build<bool>(
            (value) {
              return value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink();
            },
            animate: true,
          ),
        ],
      ),
    );
  }

  @override
  void onAction(BuildContext context, PokemonCube cube, CubeAction action) {
    if (action is CubeErrorAction) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(content: Text(action.text)));
    }
    super.onAction(context, cube, action);
  }
}
