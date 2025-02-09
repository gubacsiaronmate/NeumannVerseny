import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  final String username;
  final String password;

  EmailService({required this.username, required this.password});

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String> cc = const [],
    List<String> bcc = const [],
  }) async {
    // Create the SMTP server configuration using Gmail credentials
    final smtpServer = gmail(username, password);

    // Configure the email message details
    final message = Message()
      ..from = Address(username)
      ..recipients.add(to)
      ..ccRecipients.addAll(cc)
      ..bccRecipients.addAll(bcc)
      ..subject = subject
      ..text = body;

    try {
      // Send the message via the configured SMTP server
      final sendReport = await send(message, smtpServer);
      print('Message sent successfully: $sendReport');
    } on MailerException catch (e) {
      // Handle any errors encountered during the sending process
      print('Message not sent. Error: $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      rethrow;
    }
  }
}