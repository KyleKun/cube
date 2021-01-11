import 'package:cubes/src/observable/observable_list.dart';
import 'package:flutter/widgets.dart';

enum TypeAnimationListEnum { add, remove }
typedef AnimatedListCubeItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  Animation<double> animation,
  TypeAnimationListEnum type,
);

class CAnimatedList<T> extends StatefulWidget {
  final AnimatedListCubeItemBuilder itemBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final ObservableList<T> observable;

  const CAnimatedList({
    Key key,
    @required this.observable,
    @required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : super(key: key);

  @override
  _AnimatedListState<T> createState() => _AnimatedListState<T>();
}

class _AnimatedListState<T> extends State<CAnimatedList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<T> itemList = List();

  @override
  void initState() {
    widget.observable.value.forEach((element) {
      itemList.add(element);
    });
    widget.observable.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.observable.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      itemBuilder: (context, index, animation) {
        return (widget as CAnimatedList<T>).itemBuilder(
          context,
          itemList[index],
          animation,
          TypeAnimationListEnum.add,
        );
      },
      padding: widget.padding,
      scrollDirection: widget.scrollDirection,
      shrinkWrap: widget.shrinkWrap,
      controller: widget.controller,
      physics: widget.physics,
      initialItemCount: widget.observable.length,
      primary: widget.primary,
      reverse: widget.reverse,
    );
  }

  void _listener() {
    if (itemList.length != widget.observable.length) {
      itemList.forEach((element) async {
        if (!widget.observable.value.contains(element)) {
          final index = itemList.indexOf(element);
          await _refresh();
          _listKey.currentState.removeItem(
            index,
            (context, animation) => (widget as CAnimatedList<T>).itemBuilder(
              context,
              element,
              animation,
              TypeAnimationListEnum.remove,
            ),
          );
        }
      });

      widget.observable.value.forEach((element) async {
        if (!itemList.contains(element)) {
          await _refresh();
          final index = widget.observable.value.indexOf(element);
          _listKey.currentState.insertItem(index);
        }
      });
    } else {
      _refresh();
    }
  }

  Future _refresh() async {
    await Future.delayed(Duration.zero);
    itemList.clear();
    widget.observable.value.forEach((element) {
      itemList.add(element);
    });
    setState(() {});
  }
}
