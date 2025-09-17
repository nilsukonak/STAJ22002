import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';

import 'package:todoapp/helpers/app_color.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

import 'package:provider/provider.dart';

@RoutePage()
class TasklistPage extends StatefulWidget {
  const TasklistPage({super.key});

  @override
  State<TasklistPage> createState() => _TasklistPageState();
}

//List<Taskmodel> tasklist = []; fetck ile provider yptgm için buna gerek yok

class _TasklistPageState extends State<TasklistPage> {
  @override
  void initState() {
    super.initState();
    _loadtask();
  }

  Future<void> _loadtask() async {
    //onceden bu vardı //final loadedTask = await fetchTasksFromFirestore();
    final taskprovider = Provider.of<TaskProvider>(context, listen: false);
    await taskprovider.fetchtasks();
  }

  @override
  Widget build(BuildContext context) {
    //apply fonksunu sildk onun yerine providerden watch ile selectedfilteri sectk

    final taskProvider = context.watch<TaskProvider>();
    final localFilteredTasks = taskProvider.filteredTasks;
    final taskActions = context.read<TaskProvider>(); // listen: false
    //taskactionla beraber tekrar tekrar provider cagırmadn butun fonkslara bu sekilde ulasılıyo

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView.builder(
        itemCount: localFilteredTasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = localFilteredTasks[index];
          // final taskProvider = Provider.of<TaskProvider>(context);

          return Dismissible(
            key: ValueKey(task.id ?? UniqueKey()),

            direction: DismissDirection.endToStart, // Sadece sağdan sola
            onDismissed: (direction) async {
              //burda onceden uidi böle alıyodk provider olmadan once final uid = FirebaseAuth.instance.currentUser?.uid;

              await taskActions.dismisibleTask(task.id!);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Task deleted')));
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.buttonColor,
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            child: Opacity(
              opacity: task.isdone ? 0.7 : 1.0, //tıklananın opaklıgı azalcak

              child: Card(
                //tıklanablr olck edt sayfası acılsn diye
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    context.router.push(
                      EditTaskRoute(taskmodel: task),
                    ); /*.then((value) {
                      //edit sayfasından dönünce listeyi tekrar yükle
                      //_loadtask();
                    });*/
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isdone,
                      activeColor: Colors.black,
                      onChanged: (bool? value) async {
                        //taskactionla beraber tekrar tekrar provider cagırmadn butun fonkslara bu sekilde ulasılıyo
                        await taskActions.toggleTaskDone(
                          task,
                        ); //nedne task.id! kullandk
                      },
                    ),

                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isdone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            // ignore: deprecated_member_use
                            color: task.isdone
                                // ignore: deprecated_member_use
                                ? Colors.black.withOpacity(0.7)
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              'Due: ${task.date} ,',
                              style: TextStyle(
                                color: const Color.fromARGB(147, 0, 0, 0),
                              ),
                            ),
                            Text(
                              'Priority: ${task.priority.isEmpty ? 'None' : task.priority}',

                              style: TextStyle(
                                color: const Color.fromARGB(147, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
