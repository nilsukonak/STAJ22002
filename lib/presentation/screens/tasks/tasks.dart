import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

import 'package:todoapp/presentation/screens/tasks/tasklist.dart';
import 'package:todoapp/presentation/widgets/chip_selector.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    //final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // ignore: deprecated_member_use ?? willpopscope hata verince

    // ignore: deprecated_member_use

    final themeprovider = Provider.of<ThemeProvider>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        //geri tusunu basınca onceki işleme değil giriş sayfasına dönsn
        context.router.replaceAll([const LoginRoute()]);
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: Text(
            'Task List ',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                themeprovider.toogleTheme();
              },
            ),

            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                try {
                  await context.read<LoginProvider>().logout();
                  // Yönlendirmeyi AuthWrapper otomatik yapacak YANİ BURDA EKRAR LOGİNE DONMKE İÇN BİŞE YAPMIYOZ
                  context.router.replaceAll([const AuthWrapperRoute()]);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Çıkış başarısız: $e')),
                  );
                }
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Chipapp(
                    chiplist: ['All', 'Completed', 'Active'],
                    selectedValue: context
                        .watch<TaskProvider>()
                        .selectedFilter
                        .name,
                    onchipselected: (selected) {
                      final option = FilterOption.values.firstWhere(
                        (e) => e.name == selected,
                      );
                      context.read<TaskProvider>().changeFilter(option);
                    },
                    showCheckmark: true,
                  ),
                ],
              ),

              const TasklistPage(),

              //taskk icindr tasklist cagırılarak birbirine baglantı dart dosyaları
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.height * 0.18,
                        MediaQuery.of(context).size.width * 0.19,
                      ),
                      //backgroundColor: AppTheme().buttonColor,
                    ),
                    onPressed: () {
                      context.router.push(const NewtasksRoute());
                    },

                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '+ ',
                              style: TextStyle(fontSize: 27),
                            ),
                            TextSpan(
                              text: 'Add Task',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
