import 'package:distributor/src/strings.dart';
import 'package:distributor/ui/views/home/home_viewmodel.dart';
import 'package:distributor/ui/widgets/dumb_widgets/adhoc_sale_list_tile.dart';
import 'package:distributor/ui/widgets/dumb_widgets/empty_content_container.dart';
import 'package:distributor/ui/widgets/dumb_widgets/generic_container.dart';
import 'package:distributor/ui/widgets/dumb_widgets/misc_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class AdhocListingView extends HookViewModelWidget<HomeViewModel> {
  const AdhocListingView({Key key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel model) {
    return GenericContainer(
      child: model.adhocSalesList == null
          ? BusyWidget()
          : model.adhocSalesList.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return AdhocSaleListTile();
                  },
                  itemCount: model.adhocSalesList.length,
                )
              : Center(child: EmptyContentContainer(label: kStringNoSales)),
    );
  }
}
