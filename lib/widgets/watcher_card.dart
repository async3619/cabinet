import 'package:cabinet/database/repository/watcher.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                        enabled:
                            widget.watcher.currentStatus == WatcherStatus.idle,
                        onTap: () {
                          widget.onEdit(widget.watcher);
                        },
                        child: const Text("Edit"),
                      ),
                      PopupMenuItem(
                        enabled:
                            widget.watcher.currentStatus == WatcherStatus.idle,
                        onTap: () {
                          widget.onDelete(widget.watcher);
                        },
                        child: const Text("Delete"),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        enabled:
                            widget.watcher.currentStatus == WatcherStatus.idle,
                        onTap: () {
                          widget.onForceRun(widget.watcher);
                        },
                        child: const Text("Force Run"),
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
                  ResponsiveGridCol(
                    xs: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Status",
                          style: titleStyle,
                        ),
                        Text(
                            widget.watcher.currentStatus == WatcherStatus.idle
                                ? "Idle"
                                : "Running",
                            style: TextStyle(
                              color: widget.watcher.currentStatus ==
                                      WatcherStatus.idle
                                  ? null
                                  : Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                            )),
                      ],
                    ),
                  ),
                  ResponsiveGridCol(
                    xs: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Last Run",
                          style: titleStyle,
                        ),
                        Text(
                          widget.watcher.lastRun == null
                              ? "(never)"
                              : DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(widget.watcher.lastRun!),
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
