import 'dart:convert';
import 'package:flutter_redux_todoey/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_todoey/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> appStateMiddleware([
  AppState state = const AppState(items: []),
]) {
  final loadItems = _loadFromPrefs(state);
  final saveItems = _saveToPrefs(state);

  return [
    TypedMiddleware<AppState, AddItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemsAction>(saveItems),
    TypedMiddleware<AppState, GetItemsAction>(loadItems),
  ];
}

Middleware<AppState> _saveToPrefs(AppState state) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);
    saveToPrefs(store.state);
  };
}

Middleware<AppState> _loadFromPrefs(AppState state) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);
    loadFromPrefs()
        .then((state) => store.dispatch(LoadedItemsAction(state.items)));
  };
}

void saveToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = json.encode(state.toJson());
  await preferences.setString('itemState', string);
}

Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = preferences.getString('itemState');
  if (string != null) {
    Map map = json.decode(string);
    return AppState.fromJson(map);
  }

  return AppState.initialState();
}

/* 
void appStateMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) async {
  next(action);

  if (action is AddItemAction ||
      action is RemoveItemAction ||
      action is RemoveItemsAction) {
    saveToPrefs(store.state);
  }

  if (action is GetItemsAction) {
    await loadFromPrefs()
        .then((state) => store.dispatch(LoadedItemsAction(state.items)));
  }
}

*/
