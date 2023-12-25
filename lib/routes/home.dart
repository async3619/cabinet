import 'dart:async';

import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/database/watcher.dart';
import 'package:cabinet/widgets/watcher_card.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/src/native/query/query.dart';
import 'package:provider/provider.dart';

import 'create_watcher.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key, required this.title});

  final String title;

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
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

  void handleAddNewWatcherClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWatcherRoute(title: 'Create Watcher'),
      ),
    );
  }

  void handleDeleteWatcher(Watcher watcher) async {
    final holder = Provider.of<RepositoryHolder>(context, listen: false);
    await holder.watcher.delete(watcher);
  }

  void handleEditWatcher(Watcher watcher) {}

  void handleWatcherChanged(Query<Watcher> event) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final holder = Provider.of<RepositoryHolder>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Watcher>>(
          future: holder.watcher.getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final watchers = snapshot.data!;

              return ListView.builder(
                itemCount: watchers.length,
                itemBuilder: (context, index) {
                  final watcher = watchers[index];

                  return WatcherCard(
                    watcher: watcher,
                    onDelete: handleDeleteWatcher,
                    onEdit: handleEditWatcher,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleAddNewWatcherClick,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
