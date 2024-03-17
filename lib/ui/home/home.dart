import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/dialog_utils.dart';
import 'package:todo_app/ui/login/login.dart';
import 'package:todo_app/ui/settings/settings_tab.dart';
import 'package:todo_app/ui/todo_list/todos_list_tab.dart';

import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static const String routeName = 'HomeSc';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Todo App'),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          )),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(
            side: BorderSide(color: Colors.white, width: 4)),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  var tabs = [const SettingsTab(), const TodosListTab()];

  void logout() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    DialogUtils.showMessage(
      context,
      'Are you sure to log out ? ',
      posActionTitle: 'Yes',
      posAction: () {
        authProvider.logout();
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      },
      negActionTitle: 'Cancel',
    );
  }
}
