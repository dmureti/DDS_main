import 'package:distributor/conf/style/lib/text_styles.dart';
import 'package:distributor/src/ui/views/pos/invoicing/invoicing_viewmodel.dart';
import 'package:distributor/ui/widgets/dumb_widgets/busy_widget.dart';
import 'package:distributor/ui/widgets/dumb_widgets/empty_content_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class InvoicingView extends StatelessWidget {
  const InvoicingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InvoicingViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return DefaultTabController(
            length: 3,
            child: Scaffold(
              // appBar: AppBar(title: Text('Invoicing')),
              body: Container(
                child: Column(
                  children: [
                    Container(
                      child: TabBar(
                        tabs: [
                          Tab(
                            child: Text('Pending'),
                          ),
                          Tab(
                            child: Text('Finalized'),
                          ),
                          Tab(
                            child: Text('Failed'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: model.isBusy
                            ? Center(child: BusyWidget())
                            : TabBarView(
                                children: [
                                  model.pendingInvoices.isNotEmpty
                                      ? _InvoiceTile(model.pendingInvoices,
                                          InvoiceType.pending)
                                      : Center(
                                          child: EmptyContentContainer(
                                              label:
                                                  'There are no pending invoices.'),
                                        ),
                                  model.finalizedInvoices.isNotEmpty
                                      ? _InvoiceTile(model.finalizedInvoices,
                                          InvoiceType.finalized)
                                      : Center(
                                          child: EmptyContentContainer(
                                              label:
                                                  'There are no finalized invoices.'),
                                        ),
                                  model.failedInvoices.isNotEmpty
                                      ? _InvoiceTile(model.failedInvoices,
                                          InvoiceType.failed)
                                      : Center(
                                          child: EmptyContentContainer(
                                              label:
                                                  'There are no failed invoices.'),
                                        ),
                                ],
                              ))
                  ],
                ),
              ),
            ));
      },
      viewModelBuilder: () => InvoicingViewModel(),
    );
  }
}

class _InvoiceTile extends HookViewModelWidget<InvoicingViewModel> {
  final List invoiceList;
  final InvoiceType invoiceType;
  _InvoiceTile(this.invoiceList, this.invoiceType);
  @override
  Widget buildViewModelWidget(BuildContext context, InvoicingViewModel model) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var invoice = invoiceList[index];
        return ListTile(
            onTap: () => model.navigateToView(invoice),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice['customerName'] ?? "",
                  style: kTileLeadingTextStyle,
                ),
                Text(invoice['deliveryStatus'] ?? ""),
              ],
            ),
            subtitle: Text(
              invoice['deliveryNoteId'] ?? "",
              style: kTileSubtitleTextStyle,
            ),
            trailing:
                _buildTrailingButton(invoiceType, context, invoice, model));
      },
      itemCount: invoiceList.length,
    );
  }

  _buildTrailingButton(InvoiceType invoiceType, BuildContext context,
      var invoice, InvoicingViewModel model) {
    switch (invoiceType) {
      case InvoiceType.failed:
        return Container(
          width: 10,
        );
        break;
      case InvoiceType.finalized:
        return IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              await showModalBottomSheet(
                  context: (context),
                  builder: (context) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Submit Returns'),
                              onTap: () {
                                Navigator.pop(context);
                                model.submitReturns(invoice);
                              },
                            ),
                            // ListTile(
                            //   title: Text('Print Invoice'),
                            //   onTap: () {
                            //     model.navigateToPrint(
                            //         invoice, invoice['deliveryNoteId'], "");
                            //     Navigator.pop(context);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    );
                  });
            });
        break;
      case InvoiceType.pending:
        return IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () async {
              await showModalBottomSheet(
                  context: (context),
                  builder: (context) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Push To SAP'),
                              onTap: () {
                                model.pushToSAP(invoice);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            });
        break;
    }
  }
}
