//TASK İÇİN CLASS

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'task_model.g.dart'; // build_runner ile generate edilecek

@HiveType(typeId: 0) // Benzersiz ID veriyoruz
class Taskmodel {
  @HiveField(0)
  late String? id; //firestorede her görevn idsi var edistask yaaprken lazm
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late String date;
  @HiveField(4)
  late String priority;
  @HiveField(5)
  late String category;
  @HiveField(6)
  bool isdone;
  Taskmodel({
    this.id,
    required this.title,
    required this.description,
    required this.date, //parametreyi zorunlu tutar ama deegr kontrollerini yapmz yani " " deegr de olblr gorevde
    required this.priority,
    required this.category,
    this.isdone = false,
  });
  //firebasede her sey json formatında ama bnm projede kulanmak icin bu jsonu modele cevirmem lazm FROMJSON  ile beraber
  factory Taskmodel.fromJson(Map<String, dynamic> json, String id) {
    return Taskmodel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      priority: json['priority'] ?? '',
      category: json['category'] ?? '',
      isdone: json['isdone'] ?? false,
    );
  }
  //şimdi mesela modelden giriln gorevlern frebaseye kaydetmke icin json formatına gerş cevirmemz lazm
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'priority': priority,
      'category': category,
      'isdone': isdone,
    };
  }

  Taskmodel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? priority,
    String? category,
    bool? isdone,
  }) {
    return Taskmodel(
      //copywitle eski asıl nesneyi değiştirmiyoz eni nesne olstrdk bazı alanlaı eğiştk simdi o nesneyi yeni nsneyi returnal dondurmemz lzm
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isdone: isdone ?? this.isdone,
    );
  }

  factory Taskmodel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Taskmodel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      priority: data['priority'] ?? '',
      category: data['category'] ?? '',
      isdone: data['isdone'] ?? false,
    );
  }
}
