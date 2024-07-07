import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItemCard extends StatelessWidget {
  final String mainText;
  final String subText;
  final Widget? info;
  final IconData? actionIcon;
  final VoidCallback? onTap;

  const ListItemCard({
    super.key,
    required this.mainText,
    required this.subText,
    this.info,
    this.onTap,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constants.padding8),
      child: GestureDetector(
        onTap: actionIcon != null ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Palette.secondaryStroke),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.padding20, vertical: Constants.padding20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              mainText,
                              style: TextStyles.practiceCardSecondaryText,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          const Icon(
                            Icons.circle,
                            color: Palette.primaryText,
                            size: 5,
                          ),
                          SizedBox(width: 10.w),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              subText,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.wordType,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          const Icon(
                            Icons.circle,
                            color: Palette.primaryText,
                            size: 5,
                          ),
                          if (info != null) ...[
                            SizedBox(width: 10.w),
                            info!,
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (actionIcon != null)
                  Icon(
                    actionIcon,
                    color: Palette.primaryText,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
