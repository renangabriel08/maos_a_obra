import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:maos_a_obra/controllers/data_controller.dart';
import 'package:maos_a_obra/models/address_model.dart';
import 'package:maos_a_obra/models/specialty_model.dart';
import 'package:maos_a_obra/models/user_model.dart';

class AuthService {
  final String baseUrl;
  AuthService({required this.baseUrl});

  Future<User?> login(String email, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final Map<String, dynamic> responseBody = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseBody['token'];
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        return User.fromJson({...decodedToken['user'], 'token': token});
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<User?> register(Map<String, dynamic> user) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/register');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );

      final Map<String, dynamic> responseBody = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(
          responseBody['user']..['token'] = responseBody['token'],
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Address?> registerAddress(Map address) async {
    try {
      final uri = Uri.parse('$baseUrl/addresses');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "authorization": "Bearer ${DataController.user!.token}",
        },
        body: jsonEncode(address),
      );

      final Map<String, dynamic> responseBody = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Address address = Address.fromJson(responseBody['address']);
        return address;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerExperiences(Map<String, dynamic> additionalData) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/users/${DataController.user!.id}/prestador',
      );
      final multipartRequest = http.MultipartRequest("POST", uri);
      multipartRequest.fields['experiencia'] = additionalData['experiencia'];
      multipartRequest.headers['authorization'] =
          'Bearer ${DataController.user!.token}';
      multipartRequest.files.add(
        http.MultipartFile(
          "imagePath",
          additionalData['image'].openRead(),
          additionalData['image'].lengthSync(),
          filename: additionalData['image'].path.substring(
            additionalData['image'].path.lastIndexOf("/") + 1,
          ),
        ),
      );
      final streamedResponse = await multipartRequest.send();

      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        final res = jsonDecode(response.body);

        DataController.user!.experiencia = additionalData['experiencia'];
        DataController.user!.imagePath =
            "$baseUrl/storage/${res['user']['imagePath']}";
      }

      return streamedResponse.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Specialty>?> registerSpecialties(
    List<Specialty> specialties,
  ) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/users/${DataController.user!.id}/especialidades',
      );
      final request = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${DataController.user!.token}',
        },
        body: jsonEncode({
          "especialidade": specialties.map((e) => e.id).toList(),
        }),
      );

      if (request.statusCode == 200 || request.statusCode == 201) {
        return specialties;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Address>?> getAddressByUserId() async {
    try {
      final uri = Uri.parse('$baseUrl/addresses');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          "authorization": "Bearer ${DataController.user!.token}",
        },
      );

      final Map<String, dynamic> responseBody = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Address> address = responseBody['enderecos']
            .map<Address>((e) => Address.fromJson(e))
            .toList();
        return address;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}