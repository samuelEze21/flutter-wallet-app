import 'package:http/http.dart' as http;

class TransferService {
  // Replace this with your actual backend API endpoint
  final String _baseUrl = 'https://your-backend-api.com/api';

  Future<http.Response> confirmPayment(String password) async {
    // Mocking the backend response for now
    // In a real app, you would make an HTTP request to your backend
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Mock logic: If password is "123456", return a 200 status code
    if (password == '123456') {
      return http.Response('{"status": "success", "message": "Payment confirmed"}', 200);
    } else {
      return http.Response('{"status": "error", "message": "Invalid password"}', 400);
    }

    // Uncomment the following code to use a real API
    /*
    final response = await http.post(
      Uri.parse('$_baseUrl/confirm-payment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': password,
      }),
    );
    return response;
    */
  }
}