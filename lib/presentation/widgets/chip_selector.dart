import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';
import 'package:todoapp/presentation/themes/theme.dart';

final containerrenk = const Color.fromARGB(253, 234, 232, 232);

// ignore: must_be_immutable
class Chipapp extends StatefulWidget {
  final Function(String) onchipselected;
  List<String> chiplist;
  final String? selectedValue; // seçili değeri dışarıdan alıyoruz

  Chipapp({
    super.key,
    required this.chiplist,
    required this.onchipselected,
    this.selectedValue,
    required bool showCheckmark,
  });

  @override
  State<Chipapp> createState() => _ChipappState();
}

class _ChipappState extends State<Chipapp> {
  List<String> get chiplist => widget.chiplist;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = context.watch<ThemeProvider>();
    final bool isdarkmode = themeprovider.isDarkMode;
    return Wrap(
      spacing: MediaQuery.of(context).size.width * 0.04,
      children: List.generate(chiplist.length, (index) {
        final isSelected =
            chiplist[index] == widget.selectedValue; // <- Düzeltildi
        //mainde 3 kere donmemek icin
        return ChoiceChip(
          label: Text(
            chiplist[index],
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isdarkmode
                  ? AppTheme.darkGray
                  : AppTheme.darkCard,
              //tıklanınca beyaz olsn secilen chipn texti
            ),
          ),

          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) {
              widget.onchipselected(chiplist[index]);
            }
          },

          shape: StadiumBorder(), //yuvarlak olması için
          //avatar: CircleAvatar(backgroundColor: containerrenk), //tik iconu
          selectedColor: isdarkmode ? AppTheme.darkGray : AppTheme.buttonColor,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        );
      }),
    );
  }
}
