import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uddoktapay/models/customer_model.dart';
import 'package:uddoktapay/models/request_response.dart';
import 'package:uddoktapay/uddoktapay.dart';
import 'package:uddoktapay/views/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final paymentResponse = await UddoktaPay.createPayment(
                  context: context,
                  amount: "500",
                  customer: CustomerDetails(
                      fullName: "Naimul", email: "naim@gmail.com"));
              print(paymentResponse);
            } catch (e) {
              print("Error: $e");
            }
          },
          child: Text("Pay Now"),
        ),
      ),
    );
  }
}
