import 'package:razorpay_flutter/razorpay_flutter.dart';


class Payment {
  final Razorpay razorpay = Razorpay();

  void checkOption() {
    var options = {
      "key": "rzp_test_SMo2FvwQ4OgIBQ",
      "amount": 1 * 100,
      "currency": "INR",
      'name': "Oxford Brooks University",
      'description': "Membership",
      'prefill': {
        "contact": '918320322098',
        "email": 'admin@oxford.com',
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void event(
      _handlePaymentSuccess, _handlePaymentError) { 
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }
}
