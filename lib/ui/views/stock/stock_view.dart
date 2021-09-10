import 'package:distributor/ui/views/stock/stock_viewmodel.dart';
import 'package:distributor/ui/widgets/dumb_widgets/flat_button_widget.dart';
import 'package:distributor/ui/widgets/smart_widgets/info_bar_controller/info_bar_controller_view.dart';
import 'package:distributor/ui/widgets/smart_widgets/stock_controller/stock_controller_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:tripletriocore/tripletriocore.dart';

class StockView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StockViewModel>.reactive(
        builder: (context, model, child) => Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InfoBarController(),
                  model.user.hasSalesChannel
                      ? Container(
                          height: 50,
                          margin: EdgeInsets.only(bottom: 5),
                          child: Material(
                            elevation: 1,
                            child: ButtonBar(
                              alignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (model.renderPendingStockTransactionsButton)
                                  FlatButtonWidget(
                                    onTap: () => model
                                        .navigateToPendingTransactionsView(),
                                    label: 'Pending Stock Transactions',
                                  ),
                                FlatButtonWidget(
                                  label: 'Return Stock',
                                  onTap: () =>
                                      model.navigateToReturnStockView(),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  StockControllerWidget()
                ],
              ),
            ),
        viewModelBuilder: () => StockViewModel());
  }

  Widget buildProductList(List<Product> productList) {
    return Expanded(
      child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                onTap: () {},
                splashColor: Colors.pink.withOpacity(0.5),
                child: ListTile(
                  subtitle: Text('${productList[index].itemCode}'),
                  title: Text('${productList[index].itemName}'),
                  trailing:
                      Text('${productList[index].quantity.toStringAsFixed(0)}'),
                ),
              ),
            );
          }),
    );
  }
}
