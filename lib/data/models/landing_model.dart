class LandingModel {

  final String tituloHero;
  final String subtituloHero;
  final String historia;
  final String mision;
  final String vision;
  final String horarios;
  final String ubicacion;
  final String imagenHero;
  final String imagenHistoria;

  LandingModel({
    required this.tituloHero,
    required this.subtituloHero,
    required this.historia,
    required this.mision,
    required this.vision,
    required this.horarios,
    required this.ubicacion,
    required this.imagenHero,
    required this.imagenHistoria,
  });

  factory LandingModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return LandingModel(

      tituloHero:
          json["titulo_hero"] ?? "",

      subtituloHero:
          json["subtitulo_hero"] ?? "",

      historia:
          json["historia"] ?? "",

      mision:
          json["mision"] ?? "",

      vision:
          json["vision"] ?? "",

      horarios:
          json["horarios"] ?? "",

      ubicacion:
          json["ubicacion"] ?? "",

      imagenHero:
          json["imagen_hero"] ?? "",

      imagenHistoria:
          json["imagen_historia"] ?? "",
    );
  }
}