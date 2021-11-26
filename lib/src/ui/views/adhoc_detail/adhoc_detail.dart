import 'package:distributor/core/helper.dart';
import 'package:distributor/core/models/app_models.dart';
import 'package:distributor/src/ui/views/adhoc_detail/adhoc_detail_viewmodel.dart';
import 'package:distributor/ui/shared/text_styles.dart';
import 'package:distributor/ui/shared/widgets.dart';
import 'package:distributor/ui/widgets/dumb_widgets/busy_widget.dart';
import 'package:distributor/ui/widgets/dumb_widgets/empty_content_container.dart';
import 'package:distributor/ui/widgets/dumb_widgets/flat_button_widget.dart';
import 'package:distributor/ui/widgets/dumb_widgets/generic_container.dart';
import 'package:distributor/ui/widgets/dumb_widgets/product_quantity_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:tripletriocore/tripletriocore.dart';

class AdhocDetailView extends StatelessWidget {
  final String referenceNo;
  final String customerId;
  final String baseType;
  const AdhocDetailView(
      {Key key,
      @required this.referenceNo,
      @required this.customerId,
      @required this.baseType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdhocDetailViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(referenceNo),
            actions: [
              PopupMenuButton(
                  onSelected: (x) {
                    // model.navigateToPage(x);
                    model.confirmAction(x);
                  },
                  itemBuilder: (context) => <PopupMenuEntry<Object>>[
                        PopupMenuItem(
                          child: Text(
                            'Edit Adhoc Sale',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: 'edit_adhoc_sale',
                        ),
                        PopupMenuDivider(),
                        if (model.adhocDetail != null && !model.isCancelled)
                          PopupMenuItem(
                            child: Text(
                              'Cancel Adhoc Sale',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            value: 'cancel_adhoc_sale',
                          ),
                      ]),
            ],
          ),
          body: GenericContainer(
            child: !model.fetched
                ? Center(child: BusyWidget())
                : model.adhocDetail != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    '${model.adhocDetail.transactionStatus.toUpperCase()}'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          ReportFieldRow(
                              field: 'Transaction Date',
                              value: Helper.formatDate(DateTime.parse(
                                  model.adhocDetail.transactionDate))),
                          // ReportFieldRow(
                          //     field: 'Customer Id', value: model.customerId),
                          ReportFieldRow(
                              field: 'Customer Name',
                              value: model.adhocDetail.customerName),
                          ReportFieldRow(
                              field: 'Reference No',
                              value: model.adhocDetail.referenceNo),
                          ReportFieldRow(
                              field: 'Transaction Type',
                              value: model.adhocDetail.baseType),
                          // ReportFieldRow(
                          //     field: 'Warehouse',
                          //     value: model.adhocDetail.warehouseId),
                          ReportFieldRow(
                              field: 'Total',
                              value:
                                  'Kshs ${model.adhocDetail.total.toStringAsFixed(2)}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Items In Transaction'.toUpperCase()),
                              IconButton(
                                onPressed: () {
                                  model.toggleEditState();
                                },
                                icon: model.inEditState
                                    ? Icon(Icons.cancel)
                                    : Icon(Icons.edit),
                              ),
                            ],
                          ),
                          model.memento != null
                              ? Expanded(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        SaleItem saleItem =
                                            model.memento[index];
                                        return SaleItemWidget(
                                          saleItem: saleItem,
                                          index: index,
                                        );
                                      },
                                      separatorBuilder: (context, int) {
                                        return Divider(
                                          height: 0.2,
                                        );
                                      },
                                      itemCount: model.memento.length),
                                )
                              : Container(),
                          model.inEditState
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: FlatButtonWidget(
                                      label: 'Commit Changes',
                                      onTap: model.editTransaction),
                                )
                              : Container()
                        ],
                      )
                    : Center(
                        child: EmptyContentContainer(
                            label:
                                'There was no information found for this sale.'),
                      ),
          ),
        );
      },
      viewModelBuilder: () =>
          AdhocDetailViewModel(referenceNo, customerId, baseType),
    );
  }
}

class SaleItemWidget extends HookViewModelWidget<AdhocDetailViewModel> {
  final SaleItem saleItem;
  final int index;

  const SaleItemWidget({Key key, @required this.saleItem, @required this.index})
      : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, AdhocDetailViewModel model) {
    var textEditingController =
        useTextEditingController(text: saleItem.quantity.toString());
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${saleItem.itemCode}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: model.inEditState
                      ? () async {
                          var result = await showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  title: Text(
                                      'How many pieces would you like to reverse for  ${saleItem.itemName}'),
                                  children: [
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Allowed range is 0 to ${model.getMax(saleItem)}'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: textEditingController,
                                        onChanged: (val) {
                                          model.updateProduct(val);
                                        },
                                        decoration:
                                            InputDecoration(filled: false),
                                        onFieldSubmitted: (val) {
                                          model.updateMemento(
                                              saleItem, val, index);
                                        },
                                        // onSubmitted: (val) {
                                        //   model.updateProduct(val);
                                        // },
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        onPressed: () {
                                          model.updateMemento(
                                              saleItem,
                                              textEditingController.text,
                                              index);
                                          Navigator.pop(context);
                                          // onChange(model.delive);
                                          // Navigator.pop(context, model.product);
                                        },
                                        child: Text(
                                          'Submit',
                                          style: kActiveButtonTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });

                          if (result is Product) {
                            model.updateProduct(
                                result.quantity.toStringAsFixed(0));
                            // onChange(result);
                            model.notifyListeners();
                          }
                        }
                      : () {},
                  child: model.inEditState
                      ? Container(
                          width: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18,
                              ),
                              Text(saleItem.quantity.toString()),
                            ],
                          ),
                        )
                      : Text(model.adhocDetail.saleItems[index]['quantity']
                          .toString()),
                ),
              ],
            ),
          ),
          title: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${saleItem.itemName}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                        'Delivered : ${model.adhocDetail.saleItems[index]['quantity']}'),
                  ],
                ),
              ],
            ),
          ),
          trailing: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  saleItem.itemRate.toStringAsFixed(2),
                  // textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}