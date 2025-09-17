import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/helpers/validation_helper.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

import 'package:todoapp/helpers/app_color.dart';
import 'package:todoapp/presentation/widgets/chip_selector.dart';
import 'package:todoapp/presentation/widgets/date_picker.dart';
import 'package:todoapp/presentation/widgets/dropdown_menu.dart';
import 'package:todoapp/presentation/providers/dropdown_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class EditTaskPage extends StatefulWidget {
  final Taskmodel taskmodel;
  const EditTaskPage({super.key, required this.taskmodel});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController titlecont = TextEditingController();
  final TextEditingController descriptioncont = TextEditingController();

  final TextEditingController datecont = TextEditingController();

  final TextEditingController categorycont = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); //title için validate ile boş kontrolü yapacağız

  @override
  void initState() {
    super.initState(); //oncei deeğrler gozuksn
    print('InitState _formKey hash: ${_formKey.hashCode}');
    titlecont.text = widget.taskmodel.title;
    descriptioncont.text = widget.taskmodel.description;
    datecont.text = widget.taskmodel.date;

    categorycont.text = widget.taskmodel.category;
    Future.microtask(() {
      //initState içinde provider’ı güncellemek istiyorsan, ama context henüz hazır değilse, widget build işlemine başlansın, sonra en kısa zamanda şu kodu çalıştır
      final dropdownProvider = context.read<DropdownProvider>();
      dropdownProvider.setPriority(widget.taskmodel.priority);
      dropdownProvider.setCategory(widget.taskmodel.category);
    });
  }

  @override
  void dispose() {
    // Controller’ları serbest bırak
    titlecont.dispose();
    descriptioncont.dispose();
    datecont.dispose();
    categorycont.dispose();
    super.dispose();
  }

  // build m

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          'Edit Task',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) => validateNotEmpty(value, 'Title'),
                      controller: titlecont,
                      decoration: InputDecoration(
                        labelText: '  Title',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 12),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: descriptioncont,
                  decoration: InputDecoration(
                    labelText: '  Description',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 12),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Container(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Datesec(controller: datecont);
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                  Chipapp(
                    chiplist: ['Low', 'Medium', 'High'],
                    selectedValue: context
                        .watch<DropdownProvider>()
                        .selectedPriority,
                    onchipselected: (value) async {
                      // DropdownProvider güncelle
                      context.read<DropdownProvider>().setPriority(value);
                    },

                    showCheckmark: true,
                  ),
                ],
              ),

              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownMenuExample(),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //category yazdırmka için provider lazım
                      final dropdownProvider = context.read<DropdownProvider>();
                      final updatedTask = Taskmodel(
                        //“verileri yeni bir model içine koyma işlrmi altta guncelleme yapıyo ”
                        id: widget.taskmodel.id,
                        title: titlecont.text,
                        description: descriptioncont.text,
                        date: datecont.text,
                        priority: dropdownProvider.selectedPriority ?? "",
                        category: dropdownProvider.selectedvalue ?? "",

                        //category: categorycont.text, setstateli  bi durum vardı onu provider yaptm bu categoryi textte değil providerden alıp guncellemesi lazm firebaseye yazarken
                      );
                      // 🔹 1. Hive güncelle
                      var box = Hive.box<Taskmodel>('tasks');
                      final index = box.values.toList().indexWhere(
                        (t) => t.id == updatedTask.id,
                      );
                      if (index != -1) {
                        box.putAt(index, updatedTask);
                      }
                      final taskprovider = Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      );
                      taskprovider.updatedTask(updatedTask);

                      /* Navigator.pushReplacement(
                        //sadece pop context vardı ama tarih kısmı login yapmadan guncellenmiyodu o yuzden her seferinde taskı cagırıyoz taskın icndeki initstatet de fetch var o yuzden guncelleniyo heemn
                        context,
                        MaterialPageRoute(builder: (context) => ViewTasks()),
                      );*/
                      context.router.replace(const TasksRoute());
                    } else {
                      print('hata');
                    }
                  },
                  child: Text('Save Changes', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
