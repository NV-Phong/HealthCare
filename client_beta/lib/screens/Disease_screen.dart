import 'package:client_beta/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Disease extends StatefulWidget {
  @override
  _DiseaseState createState() => _DiseaseState();
}

class _DiseaseState extends State<Disease> {
  List<dynamic> diseases = [];
  List<bool> isExpandedList = []; // Danh sách trạng thái mở rộng cho từng khung
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
        isExpandedList = List.generate(diseases.length, (index) => false);
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
          // Tạo một mảng các màu sắc để áp dụng cho các khung
          List<Color> boxColors = [
            Colors.blueAccent,
            Colors.greenAccent,
            Colors.orangeAccent,
            Colors.purpleAccent,
            Colors.redAccent,
            // Có thể thêm màu tùy ý
          ];

          // Tạo màu cho khung dựa trên chỉ số của mục
          Color boxColor = boxColors[index % boxColors.length];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpandedList[index] = !isExpandedList[index];
                });
              },
              child: AnimatedContainer(
                duration:
                    Duration(milliseconds: 300), // Thời gian hiệu ứng mở rộng
                padding: EdgeInsets.all(16.0),
                width: double.infinity, // Đặt kích thước chiều rộng đầy đủ
                decoration: BoxDecoration(
                  color: boxColor, // Màu nền của khung từ mảng màu
                  borderRadius: BorderRadius.circular(12.0), // Bo góc
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Màu đổ bóng
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: Offset(0, 3), // Độ lệch của bóng
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.shade300, // Màu viền
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diseases[index]['Disease'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // Màu chữ, bạn có thể thay đổi tùy ý
                      ),
                    ),
                    SizedBox(height: 8.0),
                    if (isExpandedList[index])
                      ..._buildQuestionList(diseases[index]['ListQuestion'])
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildQuestionList(Map<String, dynamic>? listQuestions) {
    if (listQuestions == null || listQuestions.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Không có câu hỏi nào.",
            style: TextStyle(color: Colors.black),
          ),
        )
      ];
    }
    return listQuestions.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                entry.value, // Lấy giá trị của câu hỏi từ map
                style: TextStyle(color: Colors.black),
              ),
            ),
            // Thêm các nút tương tác sau này tại đây, ví dụ:
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Hành động tương tác của nút
              },
            ),
          ],
        ),
      );
    }).toList();
  }
}
