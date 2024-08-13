import 'package:cms/Pages/address.dart';
import 'package:cms/Pages/dashboard.dart';
import 'package:cms/Pages/sishyas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String id = "home-page";
  static Color primarycolor = Color(0xffFF6600);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _selectedscreen = Dashboard();

  currentScreen(item) {
    switch (item.route) {
      case Dashboard.id:
        setState(() {
          _selectedscreen = Dashboard();
        });

        break;

      case AddAddress.id:
        setState(() {
          _selectedscreen = AddAddress();
        });

        break;
      case SishyasScreen.id:
        setState(() {
          _selectedscreen = SishyasScreen();
        });

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'CMS',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.orange[900],
        ),
        sideBar: SideBar(
          textStyle: TextStyle(
            color: Colors.white,
          ),
          backgroundColor: Colors.blueGrey,
          items: const [
            AdminMenuItem(
              title: 'DashBoard',
              route: Dashboard.id,
              icon: CupertinoIcons.macwindow,
              children: [],
            ),
            AdminMenuItem(
              title: 'Sishyas Master',
              icon: Icons.computer,
              children: [
                AdminMenuItem(
                  route: SishyasScreen.id,
                  title: 'Add Sishyas',
                  icon: CupertinoIcons.add,
                )
              ],
            ),
            AdminMenuItem(
              title: 'Address Master',
              icon: Icons.computer,
              children: [
                AdminMenuItem(
                  route: AddAddress.id,
                  title: 'Add Address',
                  icon: CupertinoIcons.add,
                )
              ],
            ),
          ],
          selectedRoute: HomePage.id,
          onSelected: (item) {
            currentScreen(item);
          },
        ),
        body: _selectedscreen);
  }
}
