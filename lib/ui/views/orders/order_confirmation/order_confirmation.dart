import 'package:distributor/conf/dds_brand_guide.dart';
import 'package:distributor/core/enums.dart';
import 'package:distributor/core/helper.dart';
import 'package:distributor/src/ui/common/network_sensitive_widget.dart';
import 'package:distributor/ui/shared/brand_colors.dart';
import 'package:distributor/ui/widgets/dumb_widgets/busy_widget.dart';
import 'package:distributor/ui/widgets/dumb_widgets/empty_content_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:tripletriocore/tripletriocore.dart';

import 'order_confirmation_view_model.dart';

class OrderConfirmation extends StatelessWidget {
  final SalesOrderRequest salesOrderRequest;
  final Customer customer;

  const OrderConfirmation(
      {@required this.salesOrderRequest, @required this.customer, Key key})
      : assert(customer != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    bool isConnected = connectionStatus != ConnectivityStatus.Offline;
    return ViewModelBuilder<OrderConfirmationViewModel>.reactive(
      viewModelBuilder: () => OrderConfirmationViewModel(
          customer: customer, salesOrderRequest: salesOrderRequest),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft),
            onPressed: () async {
              model.navigateToProductSelection();
            },
          ),
          title: Text('Order Summary'.toUpperCase()),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NetworkSensitiveWidget(),
              Material(
                elevation: 4,
                color: kColorMiniDarkBlue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Customer'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            salesOrderRequest.customer,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due Date'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${Helper.getDay(salesOrderRequest.dueDate)}',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Number Of Items'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${model.salesOrder.items.length}',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Remarks'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              '${salesOrderRequest.remarks}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Total'.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            'Kshs ${Helper.formatCurrency(model.salesOrder.total)}',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Expanded(
                  child: model.salesOrder.items.isEmpty
                      ? Center(
                          child: EmptyContentContainer(
                            label: 'There are no items left',
                          ),
                        )
                      : ListView.separated(
                          itemCount: model.salesOrder.items.length,
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '${salesOrderRequest.items[index].quantity}',
                                          style: TextStyle(
                                              color: kColorMiniDarkBlue,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4.0, left: 4),
                                        child: Text('x'),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${salesOrderRequest.items[index].item.itemName}',
                                      style: TextStyle(
                                          color: kColorMiniDarkBlue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${Helper.formatCurrency((salesOrderRequest.items[index].quantity * salesOrderRequest.items[index].item.itemPrice))}',
                                        style: TextStyle(
                                            color: kColorMiniDarkBlue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      ClipOval(
                                        child: InkWell(
                                          onTap: () => model.deleteItem(
                                              salesOrderRequest
                                                  .items[index].item,
                                              salesOrderRequest.items[index]),
                                          splashColor: Colors.pink,
                                          child: Material(
                                            elevation: 4,
                                            type: MaterialType.card,
                                            color: Colors.grey.withOpacity(0.5),
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Icon(
                                                Icons.delete_forever_sharp,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      model.salesOrder.items.isEmpty ||
                              model.salesOrder.total == 0
                          ? Container(
                              child: ElevatedButton(
                                onPressed: () => model.backToPlaceOrder(),
                                child: Text(
                                  'Back to Place Order'.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                            )
                          : model.isBusy
                              ? Column(
                                  children: <Widget>[
                                    BusyWidget(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Please wait..placing order')
                                  ],
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kColDDSPrimaryDark),
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                      ),
                                    ),
                                    onPressed: () {
                                      model.createSalesOrder(isConnected);
                                    },
                                    child: Text(
                                      'place order'.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'NerisBlack',
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
