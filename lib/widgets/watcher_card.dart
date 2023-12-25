import 'package:cabinet/database/watcher.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

Color? secondary(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall?.color;

class WatcherCard extends StatefulWidget {
  final Watcher watcher;
  final void Function(Watcher) onDelete;
  final void Function(Watcher) onEdit;
  final void Function(Watcher) onForceRun;

  const WatcherCard(
      {Key? key,
      required this.watcher,
      required this.onDelete,
      required this.onEdit,
      required this.onForceRun})
      : super(key: key);

  @override
  State<WatcherCard> createState() => _WatcherCardState();
}

class _WatcherCardState extends State<WatcherCard> {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: secondary(context),
      fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
    );

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: PopupMenuButton(
                splashRadius: 16,
                iconColor: secondary(context),
                itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const Text("Edit"),
                        onTap: () {
                          widget.onEdit(widget.watcher);
                        },
                      ),
                      PopupMenuItem(
                        child: const Text("Delete"),
                        onTap: () {
                          widget.onDelete(widget.watcher);
                        },
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        child: const Text("Force Run"),
                        onTap: () {
                          widget.onForceRun(widget.watcher);
                        },
                      ),
                    ]),
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    xs: 12,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Watcher #${widget.watcher.id}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                        ]),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: titleStyle,
                        ),
                        Text(
                          widget.watcher.name!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Boards",
                          style: titleStyle,
                        ),
                        Text(
                          widget.watcher.boards
                              .map((element) => "/${element.code}/")
                              .join(", "),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}
