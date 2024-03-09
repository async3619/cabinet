import 'package:cabinet/database/repository/holder.dart';
import 'package:cabinet/widgets/image_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  Widget build(BuildContext context) {
    final repositoryHolder = Provider.of<RepositoryHolder>(context);

    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Favorites'),
        ),
        Expanded(
          child: FutureBuilder(
            future: repositoryHolder.image.findAllFavorites(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No favorites'),
                );
              }

              return ImageGrid(images: snapshot.data!);
            },
          ),
        )
      ],
    );
  }
}
