import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'http://192.168.1.100:8899';

  static Future<String> sendTextQuery(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/chat?query=$query'));

    return response.body;
  }

  static Future<String> generateImage(String prompt) async {
    final response = await http.get(Uri.parse('$_baseUrl/generateImage?promt=$prompt'));

    return response.body;
  }

  static Future<String> sendImageQuery(String question, File image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/askImage'));
    request.fields['question'] = question;
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return response.body;
  }
}
