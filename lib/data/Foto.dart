import 'package:intl/intl.dart';

class Foto {
  final int id; // = -1;
  final String nome; // = "";
  final String percorso; // = "";
  final int risultato; // = -1;
  final double latitudine; // = 0.0;
  final double longitudine; // = 0.0;
  final String dataCattura; // = DateFormat.yMd().format(DateTime.now());
  final String oraCattura; // = DateFormat.Hms().format(DateTime.now());

  const Foto({
    required this.id,
    required this.nome,
    required this.percorso,
    required this.risultato,
    required this.latitudine,
    required this.longitudine,
    required this.dataCattura,
    required this.oraCattura
  });

  factory Foto.fromMap(Map<String, dynamic> json) => Foto(
    id: json['id'],
    nome: json['nome'],
    percorso: json['percorso'],
    risultato: json['risultato'],
    latitudine: json['latitudine'],
    longitudine: json['longitudine'],
    dataCattura: json['dataCattura'],
    oraCattura: json['oraCattura']
  );

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'percorso': percorso,
      'risultato': risultato,
      'latitudine': latitudine,
      'longitudine': longitudine,
      'dataCattura': dataCattura,
      'oraCattura': oraCattura
    };
  }
}
