import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class EmailReplyIdeasPageModel extends FlutterFlowModel<EmailReplyIdeasPage> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class EmailReplyIdeasPage extends StatefulWidget {
  const EmailReplyIdeasPage({super.key, required this.apiStore});

  final ApiStore apiStore;

  @override
  State<EmailReplyIdeasPage> createState() => _EmailReplyIdeasPageState();
}

class _EmailReplyIdeasPageState extends State<EmailReplyIdeasPage> {
  late EmailReplyIdeasPageModel _model;
  final emailData = {
    "subject": "ĐĂNG KÝ “NGÀY HỘI SINH VIÊN VÀ DOANH NGHIỆP - NĂM 2024”",
    "sender": "TT Hỗ trợ sinh viên Trường ĐH Khoa học Tự nhiên, ĐHQG-HCM",
    "receiver": "tthotrosinhvien@hcmus.edu.vn",
    "email": """Các bạn sinh viên thân mến, Trung tâm Hỗ trợ Sinh viên giới thiệu tới các bạn “Ngày Hội Sinh viên và Doanh nghiệp - Năm 2024” - Ngày hội việc làm là dịp để cho Sinh viên gặp gỡ, giao lưu, kết nối và tìm kiếm cơ hội việc làm ở rất nhiều lĩnh vực ngành nghề. Chương trình được tổ chức bởi Trung tâm Hỗ trợ sinh viên Trường Đại học Khoa học tự nhiên, ĐHQG-HCM dưới sự chỉ đạo của BGH Nhà trường. Thời gian: 7g30 ngày 03/11/2024 (Chủ nhật) Địa điểm: Sân trường Đại học Khoa học Tự nhiên, ĐHQG-HCM cơ sở 2 – Linh Trung, Khu đô thị Đại học Quốc gia tại Thành phố Thủ Đức. ______________________ Năm nay, “Ngày hội Sinh viên và Doanh nghiệp năm 2024" mang đến cho bạn: 28 Doanh nghiệp tham gia; 30 Sàn dịch vụ - việc làm; 200 Công việc full time/part time; 17 Gian hàng dịch vụ thầy cô, sinh viên, CLB – Đội – Nhóm; 02 Chương trình, hội thảo kỹ năng - hướng nghiệp dành cho các bạn sinh viên; 10 Địa điểm phỏng vấn cực HOT. Bên cạnh đó, Ngày hội mang tới hơn 1000 món quà hấp dẫn như: balo, túi xách, áo polo,... Để đăng ký tham gia: Bước 1: Đăng kí theo link: https://docs.google.com/forms/d/e/1FAIpQLSc1uJXxOaXyEVs0YIj6pnWT0DM6b4dvlBGx89SCgAuAvF1KgA/viewform Bước 2: Nhận vé mời tại Trung tâm ở hai cơ sở. Nếu bạn không có thời gian có thể nhận tại cổng Ngày hội, ngày 03/11/2024 !!! Đây là hoạt động có tính điểm rèn luyện nhé!!! Chi tiết ngày Hội xem tại: Hẹn gặp các bạn ở “Ngày hội Sinh viên và Doanh nghiệp - Năm 2024" vào ngày 03/11/2024 ________________________________ Mọi thông tin liên hệ TRUNG TÂM HỖ TRỢ SINH VIÊN Email: tthotrosinhvien@hcmus.edu.vn Website: sacus.vn Tel: 028 38 320 287""",
  };
  List<String> replyIdeas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmailReplyIdeasPageModel());
    _fetchReplyIdeas();
  }

  Future<void> _fetchReplyIdeas() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await widget.apiStore.jarvisService.getUser();
      final response = await http.post(
        Uri.parse('https://api.dev.jarvis.cx/api/v1/ai-email/reply-ideas'),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Authorization': 'Bearer ${user!.accessToken}',
          'Content-Type': 'application/json',
        },
        // body: json.jsonEncode({
        //   "action": "Suggest 3 ideas for this email",
        //   "email": emailData["email"],
        //   "metadata": {
        //     "context": [],
        //     "subject": emailData["subject"],
        //     "sender": emailData["sender"],
        //     "receiver": emailData["receiver"],
        //     "language": "vietnamese",
        //   },
        // }),
      );

      // if (response.statusCode == 200) {
      //   final data = json.jsonDecode(response.body);
      //   setState(() {
      //     replyIdeas = List<String>.from(data['ideas'] ?? []);
      //     isLoading = false;
      //   });
      // } else {
      //   setState(() {
      //     errorMessage = 'Failed to load reply ideas: ${response.statusCode}';
      //     isLoading = false;
      //   });
      // }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching reply ideas: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondary,
        automaticallyImplyLeading: false,
        leading: JarvisIconButton(
          borderRadius: 8.0,
          buttonSize: 40.0,
          fillColor: theme.secondary,
          icon: Icon(
            Icons.arrow_back,
            color: theme.info,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Email Reply Ideas',
          style: theme.displaySmall.override(
            fontFamily: 'Poppins',
            color: theme.primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: theme.secondaryText,
                offset: const Offset(2.0, 2.0),
                blurRadius: 2.0,
              ),
            ],
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchReplyIdeas();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email Details Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.alternate, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Details',
                          style: theme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(theme, 'Subject', emailData["subject"]!),
                        const SizedBox(height: 8),
                        _buildDetailRow(theme, 'Sender', emailData["sender"]!),
                        const SizedBox(height: 8),
                        _buildDetailRow(theme, 'Receiver', emailData["receiver"]!),
                        const SizedBox(height: 16),
                        Text(
                          'Content',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emailData["email"]!,
                          style: theme.bodyMedium.copyWith(
                            color: theme.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Reply Ideas Section
                Text(
                  'Reply Ideas',
                  style: theme.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: theme.bodyMedium.copyWith(color: theme.error),
                    ),
                  )
                else if (replyIdeas.isEmpty)
                  Center(
                    child: Text(
                      'No reply ideas available',
                      style: theme.bodyMedium,
                    ),
                  )
                else
                  Column(
                    children: replyIdeas.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final idea = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.alternate, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Idea $index',
                                  style: theme.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  idea,
                                  style: theme.bodyMedium.copyWith(
                                    color: theme.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(dynamic theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.bodyMedium.copyWith(
            color: theme.secondaryText,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class User {
  final String accessToken;

  User({required this.accessToken});
}