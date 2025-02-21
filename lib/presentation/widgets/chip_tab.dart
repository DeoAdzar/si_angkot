import 'package:flutter/material.dart';
import 'package:si_angkot/core/utils/app_text_style.dart';
import 'package:si_angkot/gen/colors.gen.dart';

class ChipTab extends StatefulWidget {
  final List<String> tabs;
  final Function(int) onTabSelected;
  final int initialIndex;

  const ChipTab({
    super.key,
    required this.tabs,
    required this.onTabSelected,
    this.initialIndex = 0,
  });

  @override
  _ChipTabState createState() => _ChipTabState();
}

class _ChipTabState extends State<ChipTab> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(widget.tabs[index]),
              selected: _selectedIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTabSelected(index);
              },
              selectedColor: MyColors.colorWhite,
              backgroundColor: MyColors.backgroundTabChips,
              labelStyle: TextStyle(
                color: _selectedIndex == index ? MyColors.fontColorPrimary : MyColors.fontColorSecondary,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// use this widget like this
// ChipTabBar(
//   tabs: ["Tab 1", "Tab 2", "Tab 3"],
//   onTabSelected: (index) {
//     print("Tab terpilih: $index");
//   },
// )
