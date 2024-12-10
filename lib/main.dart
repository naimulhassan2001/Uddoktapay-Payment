import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uddoktapay/models/customer_model.dart';
import 'package:uddoktapay/models/request_response.dart';
import 'package:uddoktapay/uddoktapay.dart';
import 'package:uddoktapay/views/payment_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
            Get.to(() => WebviewScreen()) ;
            // try {
            //   final paymentResponse = await UddoktaPay.createPayment(
            //       context: context,
            //       amount: "500",
            //       customer: CustomerDetails(
            //           fullName: "Naimul", email: "naim@gmail.com"));
            //   print(paymentResponse);
            // } catch (e) {
            //   print("Error: $e");
            // }
          },
          child: Text("Pay Now"),
        ),
      ),
    );
  }
}

class WebviewScreen extends StatefulWidget {
  WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    createStripeAccount();
  }

  createStripeAccount() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          // Update loading bar.
        }, onPageStarted: (String url) {
          // Print the URL when the page starts loading
          print("Page started loading: $url");
        }, onPageFinished: (String url) {
          // Print the URL when the page finishes loading
          print("Page finished loading: $url");
        }, onWebResourceError: (WebResourceError error) {
          print("Page Error: ${error.description}");
        }, onNavigationRequest: (NavigationRequest request) {

          print("Page Navigation requested to URL: ${request.url}");
          Uri uri = Uri.parse(request.url);
          String baseUrl = '${uri.scheme}://${uri.host}';
          print("Base URL: $baseUrl");

          if(baseUrl.toString().contains("https://your-domain.com")) {
            Navigator.pop(Get.context!);
          }


          // if (request.url.startsWith("https://your-domain.com/success.phh")) {
          //   print("Detected return URL, navigating back.");
          //
          //
          //   Get.back();
          //   Navigator.pop(Get.context!);
          //   return NavigationDecision.prevent;
          // }
          //
          // if (request.url.startsWith("https://your-domain.com/cancel.php")) {
          //   print("Detected return URL, navigating back.");
          //
          //   Navigator.pop(Get.context!);
          //   return NavigationDecision.prevent;
          // }
          return NavigationDecision.navigate;
        }),
      )
      ..loadRequest(Uri.parse(
          "https://pay.sbtopup.com/payment/126fffd61da04dd67e72176b189b3742ca5a4906"));
    webViewController.setOnConsoleMessage((message) {
      if (kDebugMode) {
        print("message: =========>> ${message.message}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: webViewController),
    );
  }
}
