import 'package:distributor/ui/widgets/smart_widgets/manual_input_widget/manual_input_widget_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:tripletriocore/tripletriocore.dart';

class ManualInputWidget extends StatelessWidget {
  final int quantity;
  final maxQuantity;
  final bool isAdhocSale;
  final Product product;
  final Function onPressed;
  const ManualInputWidget(
      {Key key,
      this.quantity,
      this.maxQuantity,
      this.isAdhocSale = false,
      this.product,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManualInputWidgetViewModel>.reactive(
        onModelReady: (model) => model.init(),
        builder: (context, model, child) {
          return Center(
            child: Material(
              elevation: 3,
              type: MaterialType.card,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit Quantity'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.pink,
                                fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    model.isValidInput
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              model.validationError,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.product.itemName),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: model.textEditingController,
                        // onChanged: (val) => model.checkInputWithinRange(val),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            suffixIcon: !model.isValidInput
                                ? Icon(
                                    Icons.info_outline,
                                    color: Colors.red,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      // model.setQuantity(_textEditingController.text);
                                      onPressed(model.finalQuantity);
                                      Navigator.pop(context,
                                          model.finalQuantity - quantity);
                                    },
                                    icon: Icon(Icons.send),
                                  )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => ManualInputWidgetViewModel(
            initialQuantity: quantity,
            isAdhocSale: isAdhocSale,
            maxQuantity: maxQuantity,
            product: product));
  }
}