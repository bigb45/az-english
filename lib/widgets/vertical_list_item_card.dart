import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalListItemCard extends StatelessWidget {
  final String mainText;
  final String? subText;
  final Widget? info;
  final IconData? action;
  final bool showDeleteIcon;
  final VoidCallback? onTap;
  final VoidCallback? onIconPressed;
  final bool isLoading;
  const VerticalListItemCard({
    super.key,
    required this.mainText,
    this.subText,
    this.info,
    this.onTap,
    this.action,
    this.onIconPressed,
    this.showDeleteIcon = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constants.padding8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Palette.secondaryStroke),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constants.padding20,
              vertical: Constants.padding12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mainText,
                            style: TextStyles.practiceCardSecondaryText,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subText != null) ...[
                            SizedBox(height: 5.h),
                            Text(
                              subText!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.wordType,
                            ),
                          ],
                          SizedBox(height: 5.h),
                          info ?? const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: Constants.padding8),
                      width: 2,
                      height: 50.h,
                      color: Palette.secondaryStroke,
                    ),
                    if (showDeleteIcon)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: onIconPressed,
                        iconSize: 25.w,
                      )
                    else if (action != null)
                      isLoading
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: onIconPressed,
                              icon: Icon(
                                action!,
                              ),
                            ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
