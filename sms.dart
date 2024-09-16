import 'package:http/http.dart' as http;

String getTemplateWithNumbers(List<String> numbers) {
  // List of numbers

  // Template message with a placeholder for the number and a variable part
  String template =
      '{#number#}^Foremost Koil Annan Swamy 633rd Tirunakshatra Mahotsavam on ${DateTime.now().toString()}. Tiruvaimozhi shatrumarai with Periya Perumal garland & prasadam. Join & get blessed -KKANNN';

  // The variable part to replace {#var#}
  // String varReplacement = 'September 7th, 2024';

  // Generate messages
  String messages = numbers
      .map((number) {
        return template.replaceAll('{#number#}', number);
      })
      .toList()
      .join('~');

  // Print or use the generated messages

  return messages;
}

Future<void> sendSMS(String templatesNumber) async {
  final String apiUrl = 'http://sms.nsite.in:6005/api/v2/SendBulkSMS';

  final Map<String, String> queryParams = {
    'SenderId': 'KKANNN',
    'Is_Unicode': 'true',
    'Is_Flash': 'false',
    // 'Message':
    //     'Foremost Koil Annan Swamy 633rd Tirunakshatra Mahotsavam on {$messageDate}. Tiruvaimozhi shatrumarai with Periya Perumal garland & prasadam. Join & get blessed -KKANNN',
    'MobileNumber_Message': templatesNumber,
    'TemplateId': '1707166451995347749',
    'ApiKey': 'LVrwDbZjYKOF46DDbUt9DdsM23GeaUTQtnXmFhhxz+Q=',
    'ClientId': '80829db9-6a7c-43c2-a692-c5363fd44e1d',
  };

  final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('SMS Sent Successfully');
    } else {
      print('Failed to send SMS: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
