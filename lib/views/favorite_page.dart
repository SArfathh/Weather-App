import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> _favoriteLocations = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavoriteLocations();
  }

  Future<void> _loadFavoriteLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteLocations = prefs.getStringList('favoriteLocations') ?? [];
    });
  }

  Future<void> _saveFavoriteLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteLocations', _favoriteLocations);
  }

  Future<void> _addFavoriteLocation(String location) async {
    if (!_favoriteLocations.contains(location)) {
      setState(() {
        _favoriteLocations.add(location);
      });
      await _saveFavoriteLocations();
    }
  }

  Future<void> _removeFavoriteLocation(String location) async {
    setState(() {
      _favoriteLocations.remove(location);
    });
    await _saveFavoriteLocations();
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _favoriteLocations.removeAt(oldIndex);
      _favoriteLocations.insert(newIndex, item);
    });
    _saveFavoriteLocations();
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a New Location'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "Enter location"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _textController.clear();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _addFavoriteLocation(_textController.text);
                  _textController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Locations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _showAddLocationDialog,
              child:
                  const Text('+ Add Location', style: TextStyle(fontSize: 20)),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: _onReorder,
              children: _favoriteLocations.map((location) {
                return ListTile(
                  key: ValueKey(location),
                  title: Text(location),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeFavoriteLocation(location),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
