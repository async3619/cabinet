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
  final void Function(Watcher) onResetStatus;

  const WatcherCard(
      {Key? key,
      required this.watcher,
      required this.onDelete,
      required this.onEdit,
      required this.onResetStatus})
      : super(key: key);

  @override
  State<WatcherCard> createState() => _WatcherCardState();
}

class _WatcherCardState extends State<WatcherCard> {
  buildItem(String title, String content, TextStyle? style, int? xs) {
    final titleStyle = TextStyle(
      color: secondary(context),
      fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
    );

    xs ??= 12;
    style ??= Theme.of(context).textTheme.bodyLarge;

    return ResponsiveGridCol(
      xs: xs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Text(
            content,
            style: style,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        child: const Text('Edit'),
                      ),
                      PopupMenuItem(
                        enabled:
                            widget.watcher.currentStatus == WatcherStatus.idle,
                        onTap: () {
                          widget.onDelete(widget.watcher);
                        },
                        child: const Text('Delete'),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        onTap: () {
                          widget.onResetStatus(widget.watcher);
                        },
                        child: const Text('Reset Status'),
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
                            'Watcher #${widget.watcher.id}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                        ]),
                  ),
                  buildItem('Name', widget.watcher.name!, null, 6),
                  buildItem(
                      'Boards',
                      widget.watcher.boards
                          .map((element) => '/${element.code}/')
                          .join(', '),
                      null,
                      6),
                  ResponsiveGridCol(
                    xs: 12,
                    child: const SizedBox(
                      height: 16,
                    ),
                  ),
                  buildItem(
                    'Status',
                    widget.watcher.currentStatus == WatcherStatus.idle
                        ? 'Idle'
                        : 'Running',
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              widget.watcher.currentStatus == WatcherStatus.idle
                                  ? null
                                  : Theme.of(context).colorScheme.primary,
                        ),
                    6,
                  ),
                  buildItem(
                    'Last Run',
                    widget.watcher.lastRun == null
                        ? '(never)'
                        : DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(widget.watcher.lastRun!),
                    null,
                    6,
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}
