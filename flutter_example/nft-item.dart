import 'package:coaty/styles.dart';
import 'package:coaty/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../helpers/app_colors.dart';
import '../../helpers/app_fonts.dart';
import '../../utils/image.dart';

class NFTSlot extends StatefulWidget {
  final Map<String, dynamic> item;
  // Constructor for Item.
  const NFTSlot({Key? key, required this.item}) : super(key: key);

  @override
  State<NFTSlot> createState() => _NFTSlotState();
}

class _NFTSlotState extends State<NFTSlot> {
  @override
  Widget build(BuildContext context) {
    Widget item = Padding(
      padding: const EdgeInsets.all(12.0).r,
      child: SimpleShadow(
        child: getNetworkImage(widget.item['media']),
        // opacity: 0.5,
        sigma: 7,
        offset: const Offset(0, 5),
        color: const Color.fromRGBO(96, 119, 163, 1),
      ),
    );
    Widget column = Column(
      children: [
        Expanded(flex: 3, child: item),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(7.0).r,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(widget.item['title'],
                  style:
                      getTextStyle(AppColors.lightBlue, AppFonts.bold, 16.sp)),
            ),
          ),
        ),
      ],
    );
    Widget child = column;

    // return rounded card with gradient background depending on item type
    return GestureDetector(
      onTap: () {
        launchNFT(context, widget.item['metadataId']);
      },
      child: Container(
        margin: const EdgeInsets.all(10).r,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
