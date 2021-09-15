import 'package:flutter/material.dart';
import 'package:services_controll_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    return SizedBox(
      width: 150,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                'MENU',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600, color: color),
              ),
            ),
            Divider(
              height: 20,
              color: Colors.black,
            ),
            _MenuItem(
                color: color,
                title: 'Services',
                icon: Icons.work,
                onTap: () => onNavigate(context, '/')),
            SizedBox(
              height: 15,
            ),
            _MenuItem(
              title: 'Clientes',
              color: color,
              icon: Icons.people,
              onTap: () => onNavigate(context, '/clientes'),
            ),
            SizedBox(
              height: 15,
            ),
            _MenuItem(
                color: color,
                title: 'Perfil',
                icon: Icons.person,
                onTap: () => onNavigate(context, '/user')),
            SizedBox(
              height: 15,
            ),
            _MenuItem(
                title: 'Sair',
                color: color,
                icon: Icons.logout,
                onTap: () => logout(context))
          ],
        ),
      ),
    );
  }

  void onNavigate(BuildContext context, String uri) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(uri);
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uri = '${Constants.hostname}/tokens/revoke';
    var token = prefs.get('token');
    var response = await http.delete(Uri.parse(uri),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 204) {
      Navigator.of(context).pushNamed('/login');
    }
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(
      {Key? key,
      required this.color,
      required this.title,
      required this.icon,
      required this.onTap})
      : super(key: key);

  final Color color;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: 0.6,
        child: Container(
          height: 70,
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 40,
              ),
              Text(title,
                  style: TextStyle(
                      color: color, fontSize: 16, fontWeight: FontWeight.w700))
            ],
          ),
        ),
      ),
    );
  }
}
