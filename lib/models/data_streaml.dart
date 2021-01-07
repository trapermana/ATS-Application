
class DATA {
  final double arus;
  final double daya;
  final double tegangan;
  final double persentaseBaterai;
  final double konsumsiDaya;

  DATA({this.arus, this.daya, this.tegangan, this.persentaseBaterai, this.konsumsiDaya});

  factory DATA.fromJson(Map<dynamic, dynamic> json) {
    double parser(dynamic source){
      try{
        return double.parse(source.toString());
      } on FormatException {
        return -1;
      }
    }

    return DATA(
      arus: parser(json['Arus']),
      daya: parser(json['Daya']),
      tegangan: parser(json['Tegangan']),
      persentaseBaterai: parser(json['Persentase Baterai']),
      konsumsiDaya: parser(json['Konsumsi Daya'])
      );


  }
}