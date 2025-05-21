import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart'; // Add this import for IOClient
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/matkul.dart';

class ApiService {
  static const String baseUrl = 'https://learn.smktelkom-mlg.sch.id/ukl1/api';

  // Create an HTTP client that allows self-signed certificates
  http.Client _getClient() {
    HttpClient httpClient =
        HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
    return IOClient(httpClient);
  }

  // Register user
  Future<Map<String, dynamic>> registerUser(
    String namaNasabah,
    String gender,
    String alamat,
    String telepon,
    File imageFile,
    String username,
    String password,
  ) async {
    // Use HttpClient with certificate bypass
    HttpClient httpClient =
        HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);

    // Create a multipart request
    var uri = Uri.parse('$baseUrl/register');
    var request = await httpClient.openUrl('POST', uri);

    // Create a boundary for multipart form data
    var boundary =
        '----WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}';
    request.headers.set(
      'Content-Type',
      'multipart/form-data; boundary=$boundary',
    );

    // Prepare the request body
    var body = <int>[];

    // Add text fields
    void addTextPart(String name, String value) {
      body.addAll(utf8.encode('--$boundary\r\n'));
      body.addAll(
        utf8.encode('Content-Disposition: form-data; name="$name"\r\n\r\n'),
      );
      body.addAll(utf8.encode('$value\r\n'));
    }

    addTextPart('nama_nasabah', namaNasabah);
    addTextPart('gender', gender);
    addTextPart('alamat', alamat);
    addTextPart('telepon', telepon);
    addTextPart('username', username);
    addTextPart('password', password);

    // Add the file
    body.addAll(utf8.encode('--$boundary\r\n'));
    body.addAll(
      utf8.encode(
        'Content-Disposition: form-data; name="foto"; filename="${imageFile.path.split('/').last}"\r\n',
      ),
    );
    body.addAll(utf8.encode('Content-Type: image/jpeg\r\n\r\n'));
    body.addAll(await imageFile.readAsBytes());
    body.addAll(utf8.encode('\r\n'));

    // Close the boundary
    body.addAll(utf8.encode('--$boundary--\r\n'));

    // Set request content length
    request.contentLength = body.length;

    // Write data to request
    request.add(body);

    // Get the response
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to register user: $responseBody');
    }
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final client = _getClient();
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      body: {'username': username, 'password': password},
    );
    client.close();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // Save user data to SharedPreferences
      if (data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        // Tambahkan token ke SharedPreferences jika ada dalam respons
        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }

        // Simpan user_id juga jika tersedia
        if (data['data'] != null && data['data']['id'] != null) {
          await prefs.setString('user_id', data['data']['id'].toString());
        } else if (data['user'] != null && data['user']['id'] != null) {
          await prefs.setString('user_id', data['user']['id'].toString());
        }
      }
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Get user profile
  Future<User> getUserProfile() async {
    final client = _getClient();

    // Tambahkan header Authorization jika token tersedia
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(
      Uri.parse('$baseUrl/profil'),
      headers: headers,
    );
    client.close();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == true) {
        return User.fromJson(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Update user profile - sesuai dengan informasi Postman
  Future<Map<String, dynamic>> updateProfile(
    String namaPelanggan,
    String alamat,
    String gender,
    String telepon,
  ) async {
    final client = _getClient();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId =
        prefs.getString('user_id') ?? '1'; // default to '1' if not found

    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Menggunakan http.put yang lebih sederhana
    final response = await client.put(
      Uri.parse('$baseUrl/update/$userId'),
      headers: headers,
      body: {
        'nama_pelanggan': namaPelanggan,
        'alamat': alamat,
        'gender': gender,
        'telepon': telepon,
      },
    );
    client.close();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  // Get available matkul
  Future<List<Matkul>> getMatkul() async {
    final client = _getClient();
    final response = await client.get(Uri.parse('$baseUrl/getmatkul'));
    client.close();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == true) {
        List<Matkul> matkuls = [];
        for (var item in data['data']) {
          matkuls.add(Matkul.fromJson(item));
        }
        return matkuls;
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to load matkul');
    }
  }

  // Submit selected matkul - updated based on working example
  Future<Map<String, dynamic>> selectMatkul(List<String> matkulIds) async {
    final client = _getClient();

    // First, fetch the matkul details so we can create complete objects
    final matkuls = await getMatkul();

    // Filter the selected matkuls based on the IDs
    final selectedMatkuls =
        matkuls
            .where((matkul) => matkulIds.contains(matkul.id))
            .map(
              (matkul) => {
                'id': matkul.id,
                'nama_matkul': matkul.namaMatkul,
                'sks': matkul.sks,
              },
            )
            .toList();

    // Debug the payload
    print('Sending data to server: $selectedMatkuls');

    // Send with application/json content type
    final response = await client.post(
      Uri.parse('$baseUrl/selectmatkul'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'list_matkul': selectedMatkuls}),
    );
    client.close();

    // Debug the response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to select matkul: ${response.body}');
    }
  }
}
