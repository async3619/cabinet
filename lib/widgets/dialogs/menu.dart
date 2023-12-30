import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final VoidCallback? onTap;

  const MenuItem({
    required this.title,
    this.onTap,
  });
}

class MenuDialog extends StatefulWidget {
  const MenuDialog({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<MenuItem> items;

  @override
  State<MenuDialog> createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.items.map((item) {
                return ListTile(
                  title: Text(item.title),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (item.onTap != null) {
                      item.onTap!();
                    }
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
