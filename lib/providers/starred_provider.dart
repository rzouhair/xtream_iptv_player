import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Starred with ChangeNotifier {
  Box? box;
  Box? login;

  Starred({
    this.box,
    this.login,
  });
}
