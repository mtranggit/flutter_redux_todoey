import 'package:flutter_redux_todoey/model/model.dart';
import 'package:flutter_redux_todoey/redux/actions.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    items: itemReducer(state.items, action),
  );
}

List<Item> itemReducer(List<Item> state, dynamic action) {
  if (action is AddItemAction) {
    return []
      ..addAll(state)
      ..add(Item(id: action.id, body: action.item));
  }

  if (action is RemoveItemAction) {
    return List.unmodifiable(List.from(state)..remove(action.item));
  }

  if (action is RemoveItemsAction) {
    return List.unmodifiable([]);
  }

  if (action is LoadedItemsAction) {
    return action.items;
  }

  return state;
}
