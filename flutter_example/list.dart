import 'package:coaty/config.dart';
import 'package:coaty/helpers/app_fonts.dart';
import 'package:coaty/page/nft-collection/nft-item.dart';
import 'package:coaty/styles.dart';
import 'package:coaty/widgets/local_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../helpers/app_colors.dart';

var query = gql('''
    query GetStoreNfts(\$offset: Int = 0, \$limit: Int = 10) 
     @cached {
      mb_views_nft_metadata_unburned(
        where: { nft_contract_id: { _eq: "${Config.mintbaseStoreId}" } }
        offset: \$offset
        limit: \$limit
        order_by: { minted_timestamp: desc }
      ) {
        createdAt: minted_timestamp 
        price 
        media 
        storeId: nft_contract_id 
        metadataId: metadata_id 
        title 
      }
    }
  ''');

const _itemsPageLimit = 10;
const _itemsPerRow = 2;

class NFTList extends StatefulWidget {
  const NFTList({Key? key}) : super(key: key);

  @override
  State<NFTList> createState() => _NFTListState();
}

class _NFTListState extends State<NFTList> {
  int cursor = 0;
  bool isLoadData = false;
  late List<dynamic> _items = [];

  static HttpLink httpLink =
      HttpLink('https://interop-testnet.hasura.app/v1/graphql');

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: httpLink, cache: GraphQLCache(store: InMemoryStore())));

  void loadMore() {
    setState(() {
      cursor = cursor + _itemsPageLimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GraphQLProvider(
          client: client,
          child: Query(
            options: QueryOptions(document: query, variables: {
              'offset': cursor,
              'limit': _itemsPageLimit,
            }),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return LocalError(error: result.exception);
              }

              if (result.isLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: CupertinoActivityIndicator(
                    color: AppColors.lightBlue,
                    radius: 15.r,
                  ),
                );
              }

              _items = result.data?['mb_views_nft_metadata_unburned'];

              if (_items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Text('No more NFTs for now',
                      style: getTextStyle(
                          AppColors.lightBlue, AppFonts.regular, 14.sp)),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _itemsPerRow,
                        ),
                        itemBuilder: (context, index) {
                          return NFTSlot(item: _items.elementAt(index));
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 10.h),
                      //   child: TextButton(
                      //     style: TextButton.styleFrom(
                      //       backgroundColor: Colors.transparent,
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      //     ),
                      //     onPressed: loadMore,
                      //     child: Text('Load more', style: getTextStyle(AppColors.darkBlue, AppFonts.semibold, 17.sp)),
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
