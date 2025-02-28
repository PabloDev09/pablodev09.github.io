import 'package:dio/dio.dart';

class GetProvincesCities {
  final Dio _dio = Dio();

  Future<List<String>> fetchCities(String codigoProvince) async 
  {
    final response = await _dio.get(
      'https://apiv1.geoapi.es/municipios?CPRO=${codigoProvince.trim()}&type=JSON&key=&sandbox=1',
    );


    if (response.statusCode == 200) 
    {
      List<dynamic> data = response.data["data"];
      return data.map<String>((city) => city["DMUN50"]).toList();
    } 
    else 
    {
      throw Exception('Error al obtener ciudades para la provicia seleccioanda');
    }
  }
}
