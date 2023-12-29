import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/notifications/manager.dart';
import 'package:cabinet/works/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'posts.dart';
import 'watchers.dart';

import '../create_watcher.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    final repositoryHolder =
        Provider.of<RepositoryHolder>(context, listen: false);

    NotificationManager().ensurePermission().then((granted) {
      WorkManager().initialize(repositoryHolder.objectBox);
    });
  }

  void handleAddNewWatcherClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWatcherRoute(title: 'Create Watcher'),
      ),
    );
  }

  void handleSelectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    Widget? fab;
    String title;
    switch (_selectedIndex) {
      case 0:
        title = WatchersTab.title;
        body = const WatchersTab();
        fab = FloatingActionButton(
          onPressed: handleAddNewWatcherClick,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        );
        break;
      case 1:
        title = PostsTab.title;
        body = const PostsTab();
        break;

      default:
        throw Exception('Invalid tab index');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: body,
      floatingActionButton: fab,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'Watchers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: 'Posts',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: handleSelectTab,
      ),
    );
  }
}
