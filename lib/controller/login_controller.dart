import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginKey = GlobalKey();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
}
