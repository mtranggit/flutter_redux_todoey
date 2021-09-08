import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_todoey/redux/middleware.dart';
import 'package:flutter_redux_todoey/widgets/item_tile.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux_todoey/redux/reducers.dart';
import 'package:flutter_redux_todoey/redux/actions.dart';
import 'package:flutter_redux_todoey/model/model.dart';
// import 'package:redux_remote_devtools/redux_remote_devtools.dart';

// 1. Follow instructions to download and run https://github.com/reduxjs/redux-devtools/tree/main/packages/redux-devtools-cli
//
// 2. Find out your current local ip address: 192.168.68.121
//
// 3. Start up with command
// redux-devtools --port=8000
// 4. Launch your Chrome and go to this address: http://192.168.68.121:8000/, go to Settings and change Connection Settings to
// use local(custom) server: hostname: localhost, port: 8000
// 5. Start up the app
//
void main() {
// void main() async {
  // var remoteDevTools = RemoteDevToolsMiddleware('192.168.68.121:8000');
  final store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initialState(),
    middleware: appStateMiddleware(),
    // middleware: [appStateMiddleware, remoteDevTools],
  );
  // remoteDevTools.store = store;
  // await remoteDevTools.connect();
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Redux Todoey',
        theme: ThemeData.dark(),
        home: StoreBuilder(
            onInit: (store) => store.dispatch(GetItemsAction()),
            builder: (context, Store<AppState> store) => MyHomePage(store)),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Store<AppState> store;

  const MyHomePage(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo items'),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Column(
          children: [
            AddItemWidget(viewModel),
            Expanded(child: ItemListWidget(viewModel)),
            RemoveItemsButton(viewModel),
          ],
        ),
      ),
    );
  }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  const RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => model.onRemoveItems(),
      child: Text('Delete all items'),
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;

  const ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items
          .map(
            (Item item) => ItemTile(
              title: item.body,
              completed: item.completed,
              onRemoveItem: () => model.onRemoveItem(item),
              onToggleItemCheckbox: (value) => model.onCompletedItem(item),
            ),
          )
          .toList(),
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  AddItemWidget(this.model);

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Add an todo item',
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
      onSubmitted: (String s) {
        widget.model.onAddItem(s);
        controller.text = '';
      },
    );
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;
  final Function(Item) onCompletedItem;

  _ViewModel({
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onRemoveItems,
    required this.onCompletedItem,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    _onCompletedItem(Item item) {
      store.dispatch(ItemCompletedAction(item));
    }

    return _ViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
      onCompletedItem: _onCompletedItem,
    );
  }
}
