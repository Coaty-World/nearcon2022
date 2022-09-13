import 'package:coaty/page/nft-collection/list.dart';
import 'package:coaty/styles.dart';
import 'package:coaty/widgets/gradient_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/app_colors.dart';

const _title = 'Minted NFTs';

class NFTCollection extends StatefulWidget {
  const NFTCollection({Key? key}) : super(key: key);

  @override
  State<NFTCollection> createState() => _NFTCollectionState();
}

class _NFTCollectionState extends State<NFTCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/interface/backgrounds/inventory.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const SafeArea(
          child: NFTList(),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 60.h,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: GradientDivider(color: appBarLineColorBlue)),
        elevation: 0,
        centerTitle: true,
        title: Text(
          _title,
          style: appBarTextStyleBlue,
        ),
      ),
      backgroundColor: AppColors.backgroundGrey,
    );
  }
}
