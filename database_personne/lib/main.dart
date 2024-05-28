import 'package:database_personne/model/personne.dart';
import 'package:database_personne/provider/personne_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo SQfLite'),
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
  Map<String, dynamic> mapPersonne = {
    'nom': 'DOE',
    'prenom': 'John',
    'age': '35'
  };
  late Map<String, dynamic> mapPersonneRecuperee;
  Personne personneEnregistree = Personne();
  Personne personneRecuperee = Personne();
  late PersonneProvider provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Icon(
                Icons.account_circle,
                size: 80.0,
                color: Colors.blue,
              ),
              const Text('Données soumises :'),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
// NOM SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nom : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${personneEnregistree.toMap()['nom']}',
                          style: const TextStyle(
                              fontSize: 30.0,
                              color: Color.fromARGB(255, 108, 107, 107),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
// PRENOM SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Prenom : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${personneEnregistree.toMap()['prenom']}',
                          style: const TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
// AGE SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Age : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${personneEnregistree.toMap()['age']}',
                          style: const TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Text('Données Récupérées :'),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
// ID SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'id : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        personneRecuperee.toMap()['id'] != null
                            ? Text(
                                '${personneRecuperee.toMap()['id']}',
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'Aucune donnée',
                                style: TextStyle(color: Colors.white),
                              )
                      ],
                    ),
// PRENOM SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nom : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        personneRecuperee.toMap()['nom'] != null
                            ? Text(
                                '${personneRecuperee.toMap()['nom']}',
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'Aucune donnée',
                                style: TextStyle(color: Colors.white),
                              )
                      ],
                    ),
// PRENOM SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Prenom : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        personneRecuperee.toMap()['prenom'] != null
                            ? Text(
                                '${personneRecuperee.toMap()['prenom']}',
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'Aucune donnée',
                                style: TextStyle(color: Colors.white),
                              )
                      ],
                    ),
// AGE SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Age : ',
                          style: TextStyle(color: Colors.white),
                        ),
                        personneRecuperee.toMap()['age'] != null
                            ? Text(
                                '${personneRecuperee.toMap()['age']}',
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'Aucune donnée',
                                style: TextStyle(color: Colors.white),
                              )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    onPressed: enregistrer,
                    child: const Text('Enregistrer'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    onPressed: recuperer,
                    child: const Text('Lire les données'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                    onPressed: supprimer,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    personneEnregistree = Personne.fromMap(mapPersonne);
    getInstance();
  }

  Future<PersonneProvider> getInstance() async {
    provider = await PersonneProvider.instance;
    return provider;
  }

  @override
  void dispose() {
    super.dispose();
    provider.close();
  }

  Future<void> enregistrer() async {
    int? id = await provider.insert(personneEnregistree);
    if (id != null) {
      mapPersonneRecuperee = {'id': id};
      personneRecuperee = Personne.fromMap(mapPersonneRecuperee);
    } else {
      // Gérer le cas où l'insertion échoue
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text('Enregistrement'),
              content: Text('Les données ont été enregistrées !'));
        });
  }

  Future<void> recuperer() async {
    if (personneRecuperee.toMap()['id'] != null) {
      personneRecuperee =
          (await provider.getPersonne(personneRecuperee.toMap()['id']))!;
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Récupération'),
                content: Text('Aucune données à recupérer !'));
          });
    }
  }

  Future<void> supprimer() async {
    if (personneRecuperee.toMap()['id'] != null) {
      await provider.delete(personneRecuperee.toMap()['id']);
      setState(() {
        personneRecuperee = Personne();
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Suppression'),
                content: Text('Les données ont été supprimées !'));
          });
    } else {
      // Gérer le cas où il n'y a aucune donnée à supprimer
    }
  }
}
