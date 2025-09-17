import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/data/repositories/task_repository.dart';

//bu provider olmadna once surekli ekrna bastrmk için firestore gidiyod aam artk gorevler bi kere ceklp providerde tutuluyo sen filtreleme yapıyosn

enum FilterOption { All, Active, Completed }

class TaskProvider with ChangeNotifier {
  List<Taskmodel> _task = [];
  List<Taskmodel> get task => _task;
  String? get userid => _userid;

  final TaskRepository _repository;
  TaskProvider(this._repository);

  // Dinamik getter

  String? _userid;

  //FİLTRELEME için
  FilterOption _selectedFilter = FilterOption.All;

  List<Taskmodel> get filteredTasks {
    if (_selectedFilter == FilterOption.Active) {
      return _task.where((t) => !t.isdone).toList();
    } else if (_selectedFilter == FilterOption.Completed) {
      return _task.where((t) => t.isdone).toList();
    }
    return List.from(_task)..sort((a, b) {
      if (a.isdone == b.isdone) return 0;
      return a.isdone == false ? -1 : 1;
    });
  }

  FilterOption get selectedFilter => _selectedFilter;
  //o an secli fitreyi okumak uı de chiplern hangisinin secili oldunu gostermke için lazm

  void changeFilter(FilterOption filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void addTask(Taskmodel newTask) {
    _task.add(newTask);
    notifyListeners();
  }

  void setUserId(String? uid) {
    if (_userid == uid) {
      print("uid değişmedi");
      return;
    }

    _userid = uid; //uid değişmş yeni uidi atadk
    _task.clear(); //gorevler temizlendi

    if (uid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> fetchtasks() async {
    if (_userid == null) {
      print("UID null, görev çekilemez");
      return;
    }

    // Task listesini temizle
    _task.clear();
    //notifyListeners();
    // UI’ı güvenli şekilde güncelle

    // Repository üzerinden görevleri çek
    _task = await _repository.fetchtasks(_userid!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> dismisibleTask(String taskId) async {
    final uid = _userid;
    if (uid == null) return;
    await _repository.deleteTask(taskId, uid);

    _task.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  Future<void> updatedTask(Taskmodel updatedTask) async {
    // Firestore güncelle
    final uid = _userid;
    if (uid != null) {
      print('Güncellenecek ID: ${updatedTask.id}');
      await _repository.updateTask(uid, updatedTask);
      int index = _task.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _task[index] = updatedTask;
      }
      notifyListeners();
    }
  }

  //isdone durumununguncelleme
  Future<void> toggleTaskDone(Taskmodel task) async {
    final uid = _userid;
    final newStatus = !task.isdone;
    await _repository.toogletask(uid!, task);
    task.isdone = newStatus;
    notifyListeners();
  }
}
