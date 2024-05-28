import 'package:database_personne/model/table_util.dart';

class Personne {

  int id = 0;
  String nom = "";
  String prenom = "";
  String age = "";

  Personne();

  Personne.fromMap(Map<String, dynamic> map) {
    id = map[COLONNE_ID] ?? 0;
    nom = map[COLONNE_NOM] ?? '';
    prenom = map[COLONNE_PRENOM] ?? '';
    age = map[COLONNE_AGE] ?? '';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      COLONNE_NOM: nom,
      COLONNE_PRENOM: prenom,
      COLONNE_AGE: age
    };
    if (id != 0) {
      map[COLONNE_ID] = id;
    }
    return map;
  }

}