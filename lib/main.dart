import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraphQL Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> characters = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loading ?
          const CircularProgressIndicator() :
          characters.isEmpty ?
              Center(
                child: ElevatedButton(
                  child: const Text("Fetch Data"),
                  onPressed: (){
                    fetchData();
                  },
                ),
              ): Padding(padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    leading: Image(
                      image: NetworkImage(
                        characters[index]['image'],
                      ),
                    ),
                    title: Text(
                      characters[index]['name'],
                    ),
                  ),
                );
              }),)

    );
  }

  void fetchData() async{
    setState(() {
      _loading = true;
    });

    HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    GraphQLClient qlClient = GraphQLClient(
        link: link, 
        cache: GraphQLCache(
          store: HiveStore(),
        ));
    
    QueryResult queryResult = await qlClient.query(
      QueryOptions(document: gql(
        """query {
      characters() {
      results {
      name
      image 
    }
  }
  
}""",
      ))
    );

    setState(() {
      characters = queryResult.data!['characters'][
      'results'];
      _loading = false;
    });
  }

}




















