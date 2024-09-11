import 'package:ez_english/core/constants.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final IconData? actionIcon;
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constants.padding12),
      child: GestureDetector(
        // onTap: onTap,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(Constants.padding12),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyles.bodyLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyles.bodyMedium,
                      ),
                      actionIcon != null
                          ? IconButton(
                              icon: Icon(actionIcon),
                              onPressed: onTap!,
                            )
                          : const SizedBox()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
