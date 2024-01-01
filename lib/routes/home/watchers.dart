import 'dart:async';

import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/repository/watcher.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:cabinet/routes/execution_logs.dart';
import 'package:cabinet/tasks/watcher.dart';
import 'package:cabinet/widgets/watcher_card.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';

import '../create_watcher.dart';

class WatchersTab extends StatefulWidget {
  const WatchersTab({super.key});

  @override
  State<WatchersTab> createState() => _WatchersTabState();
}

class _WatchersTabState extends State<WatchersTab> {
  late final StreamSubscription<Query<Watcher>> watcherSubscription;

  @override
  void initState() {
    super.initState();

    final holder = Provider.of<RepositoryHolder>(context, listen: false);
    watcherSubscription = holder.watcher.watch().listen(handleWatcherChanged);
  }

  @override
  void dispose() {
    watcherSubscription.cancel();
    super.dispose();
  }

  void handleDeleteWatcher(Watcher watcher) async {
    final holder = Provider.of<RepositoryHolder>(context, listen: false);
    await holder.watcher.delete(watcher);
  }

  void handleEditWatcher(Watcher watcher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWatcherRoute(
          title: 'Edit Watcher',
          watcher: watcher,
        ),
      ),
    );
  }

  void handleForceRunWatcher(Watcher watcher) {
    final holder = Provider.of<RepositoryHolder>(context, listen: false);
    final task = WatcherTask(
      repositoryHolder: holder,
      watcher: watcher,
      onError: (error) {
        holder.watcher.setWatcherStatus(watcher, WatcherStatus.idle);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task \'${watcher.name}\' failed: $error'),
          ),
        );
      },
      onStart: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task \'${watcher.name}\' started'),
          ),
        );
      },
      onComplete: () {
        holder.watcher.setWatcherStatus(watcher, WatcherStatus.idle);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task \'${watcher.name}\' completed'),
          ),
        );
      },
    );

    task.run();
  }

  void handleWatcherChanged(Query<Watcher> event) {
    setState(() {});
  }

  void handleExecutionLogPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExecutionLogsRoute(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final holder = Provider.of<RepositoryHolder>(context);

    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Watchers'),
          actions: [
            IconButton(
              icon: const Icon(Icons.receipt_long),
              onPressed: handleExecutionLogPressed,
            )
          ],
        ),
        Expanded(
          child: FutureBuilder<List<Watcher>>(
            future: holder.watcher.findAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final watchers = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: watchers.length,
                  itemBuilder: (context, index) {
                    final watcher = watchers[index];

                    return WatcherCard(
                      watcher: watcher,
                      onDelete: handleDeleteWatcher,
                      onEdit: handleEditWatcher,
                      onForceRun: handleForceRunWatcher,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }
}
