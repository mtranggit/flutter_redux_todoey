import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback? onRemoveItem;
  final Function(bool?)? onToggleItemCheckbox;

  ItemTile({
    required this.title,
    this.completed = false,
    this.onToggleItemCheckbox,
    this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            decoration: completed ? TextDecoration.lineThrough : null),
      ),
      leading: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onRemoveItem,
      ),
      trailing: Checkbox(
        value: completed,
        onChanged: onToggleItemCheckbox,
      ),
    );
  }
}
