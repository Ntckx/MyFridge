import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class PlanList extends StatelessWidget {
  final IconData iconData;
  final String text;

  const PlanList({
    super.key,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(
            iconData,
            color: AppColors.blue,
            size: 30,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.darkblue,
                  ),
               overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
