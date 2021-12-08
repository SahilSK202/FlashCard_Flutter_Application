import 'package:flashcard_app/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flashcard_app/topictile_view.dart';
import 'package:flashcard_app/questions_screen.dart';
import 'package:flashcard_app/aboutus_page.dart';
import 'package:flashcard_app/settings_page.dart';
import 'package:flashcard_app/exit_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/questions': (context) => QuestionScreen()},
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Choose Topic"),
            elevation: 0.00,
            backgroundColor: Colors.pink,
            actions: [
              PopupMenuButton<MenuItem>(
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                        ...MenuItems.itemsone.map(buildItem).toList(),
                      ])
            ],
          ),
          body: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 15.0,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              TopicTileView(
                  icon: Icons.settings_suggest_rounded,
                  heading: "Python",
                  color: Colors.deepPurple),
              TopicTileView(
                  icon: Icons.code, heading: "Java", color: Colors.red),
              TopicTileView(
                  icon: Icons.stacked_bar_chart,
                  heading: "Data Structures",
                  color: Colors.green),
              TopicTileView(
                  icon: Icons.computer,
                  heading: "Operating System",
                  color: Colors.pink),
              TopicTileView(
                  icon: Icons.graphic_eq,
                  heading: "Dummy",
                  color: Colors.purple),
              TopicTileView(
                  icon: Icons.graphic_eq,
                  heading: "Dummy",
                  color: Colors.orange)
            ],
            staggeredTiles: [
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon, color: Colors.black, size: 20),
            const SizedBox(width: 12),
            Text(item.text),
          ],
        ),
      );

  void onSelected(contenx, MenuItem item) {
    switch (item) {
      case MenuItems.itemAbout:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AboutUsPage()),
        );

        break;

      case MenuItems.itemSettings:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );

        break;
      default:
    }
  }
}
