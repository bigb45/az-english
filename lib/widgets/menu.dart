import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Menu extends StatefulWidget {
  final Function onItemSelected;
  final List<MenuItemData> items;
  const Menu({super.key, required this.onItemSelected, required this.items});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.items.length, (index) {
          bool isSelected = index == selectedIndex;
          MenuItemData currentItem = widget.items[index];
          if (index == widget.items.length - 1) {
            index = -1;
          }

          return GestureDetector(
            onTap: () {
              _handleMenuItemPressed(index);
            },
            child: Container(
              decoration: BoxDecoration(
                  color:
                      isSelected ? Palette.secondaryVariant : Palette.secondary,
                  border: index == 0 || index == -1
                      ? Border(
                          top: BorderSide(
                            width: 2,
                            color: isSelected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                          ),
                          bottom: BorderSide(
                            width: 2,
                            color: isSelected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                          ),
                          left: BorderSide(
                            width: 2,
                            color: isSelected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                          ),
                          right: BorderSide(
                            width: 2,
                            color: isSelected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                          ))
                      : Border.symmetric(
                          vertical: BorderSide(
                            width: 2,
                            color: isSelected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                          ),
                          horizontal: BorderSide(
                            width: 2,
                            color: isSelected
                                ? Palette.secondaryVariantStroke
                                : Palette.secondaryStroke,
                          ),
                        ),
                  borderRadius: switch (index) {
                    0 => BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    -1 => BorderRadius.only(
                        bottomLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    _ => BorderRadius.zero,
                  }),
              width: 390,
              height: 60,
              child: Padding(
                padding: EdgeInsets.all(Constants.padding20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentItem.mainText,
                      style: TextStyle(
                        color: isSelected
                            ? Palette.primaryVariantText
                            : Palette.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      currentItem.description,
                      style: TextStyle(
                        color: isSelected
                            ? Palette.primaryVariantText
                            : Palette.secondaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        })
      ],
    );
  }

  void _handleMenuItemPressed(int index) {
    if (index == -1) {
      index = widget.items.length - 1;
    }
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }
}

class MenuItemData {
  final String mainText;
  final String description;
  const MenuItemData({required this.mainText, required this.description});
}
