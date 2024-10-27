import 'package:client_beta/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'Question_screens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Disease extends StatefulWidget {
  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  List<dynamic> diseases = [];
  final tokenService = TokenService();
  @override
  void initState() {
    super.initState();
    fetchDiseases();
  }

  Future<void> fetchDiseases() async {
    String? token = await tokenService.getValidAccessToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/disease'),
      headers: {
        'Authorization': 'Bearer $token', // Đặt token đã xác thực của bạn
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        diseases = json.decode(response.body);
      });
    } else {
      print('Failed to load diseases');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bệnh của bạn là ?'),
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(diseases[index]['Disease']),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => DiseaseQuestionsScreen(
            //         diseaseId: diseases[index]['_id'],
            //       ),
            //     ),
            //   );
            // },
          );
        },
      ),
    );
  }
}