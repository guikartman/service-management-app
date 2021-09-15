import 'package:flutter/material.dart';
import 'package:services_controll_app/pages/user/login.page.dart';
import 'package:services_controll_app/pages/user/user.page.dart';

import 'pages/index.dart';

final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/': (BuildContext context) => HomePage(),
  '/clientes': (BuildContext context) => CustomersPage(),
  '/relatorios': (BuildContext context) => ReportsPage(),
  '/cadastrar': (BuildContext context) => SinginPage(),
  '/user': (BuildContext context) => UserPage()
};
