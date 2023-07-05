import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animator.dart';

//Ejecución MyApp (3.Crear proyecto) 
void main() {
  WidgetsApp.debugAllowBannerOverride = false;
  runApp(MyApp());
}

//Widget principal (3.Crear proyecto)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//Estado de la app (3.Crear proyecto) 
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  //Reasignar a current (4.Agrega boton)
  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite(){
    if(favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  /* var image = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.star, color: Colors.green[500],),
      Icon(Icons.star, color: Colors.green[300],),
      Icon(Icons.star, color: Colors.green[100],),
      Icon(Icons.star, color: Colors.green,)
    ],
  );

  void toggleIcon(){
    image = Row
  } */
}

class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build (BuildContext context){
    
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = Settings();
        break;
      case 3:
        page = HomePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home), 
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings), 
                      label: Text('Settings'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.archive), 
                      label: Text('Animator')),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ]
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if(appState.favorites.contains(pair)){
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
  
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('A random idea:'),
          BigCard(pair: pair),

          SizedBox(height: 10,),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: (){
                  appState.toggleFavorite();
                }, 
                icon: Icon(icon),
                label: Text('Like'),
              ),

              SizedBox(width: 10,),
              //4. Agrega un botón
              ElevatedButton(
                onPressed: (){
                  appState.getNext();   //<=Lllamar metodo getNext
              }, child: Text('Next')),
            ],
          )
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}


class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: 25),
              Padding(padding: const EdgeInsets.all(20)),
              Text('AJUSTES'),
              SizedBox(height: 75),
              
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
              onPressed: (){
                    Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context)=> MyHomePage())
                    );
              }, 
              icon: Icon(Icons.settings),
              label: Text('Ajustes'),
              ),

              SizedBox(width: 15),

              ElevatedButton.icon(
                onPressed: (){

                }, 
                icon: Icon(Icons.app_registration),
                label: Text('Personalización')
                ),
            ],
          )
        ], 
      )
    );
  }
}

