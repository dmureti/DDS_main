import 'package:flutter/material.dart';
import 'package:tripletriocore/tripletriocore.dart';

class CustomerTextInput extends StatelessWidget {
  final List<Customer> customerList;
  final Function onSelected;
  const CustomerTextInput(
      {Key key, @required this.customerList, @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Customer>(
      displayStringForOption: (customer) => customer.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Customer>.empty();
        }
        return customerList.where((Customer customer) {
          return customer.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Customer customer) {
        onSelected(customer);
        Focus.of(context).unfocus();
      },
    );
  }
}
