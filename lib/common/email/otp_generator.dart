import 'dart:math';

import 'package:on_time/common/email/otp_content.dart';

class OtpGenerator {
  final int _otpCode = _getOtpCode();

  static int _getOtpCode() => Random().nextInt(900000) + 100000;

  OtpContent getEmailContent() => OtpContent(
    otpCode: _otpCode,
    email: """
      <!DOCTYPE html>
      <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <meta http-equiv="X-UA-Compatible" content="ie=edge">
              <title>OnTime Email Verification</title>
          </head>
          <body>
              <h1>OnTime</h1>
              <p>
                  Hello,
                  <br>
                  Your One-Time Password (OTP) is: <strong>$_otpCode</strong>. <br>
                  Please use this code to complete your verification. <br>
                  If you did not request this, please ignore this message or contact the support team.
              </p>
              <p>
                  Regards, <br>
                  DebDevs Team
              </p>
          </body>
      </html>
    """
  );
}