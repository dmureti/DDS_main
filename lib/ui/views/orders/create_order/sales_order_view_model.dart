import 'package:distributor/app/locator.dart';
import 'package:distributor/app/router.gr.dart';
import 'package:distributor/core/models/product_service.dart';
import 'package:distributor/services/adhoc_cart_service.dart';
import 'package:distributor/services/order_service.dart';
import 'package:distributor/services/stock_controller_service.dart';
import 'package:distributor/src/ui/views/pos/payment_view/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tripletriocore/tripletriocore.dart';

enum ProductOrdering { alphaAsc, alphaDesc }

class SalesOrderViewModel extends ReactiveViewModel {
  AdhocCartService _adhocCartService = locator<AdhocCartService>();
  StockControllerService _stockControllerService =
      locator<StockControllerService>();

  bool get isVariable => _adhocCartService.isVariable ?? false;

  checkIfStockExists(Product product) {
    Product p = _stockBalanceList.firstWhere(
        (element) => element.itemCode == product.itemCode,
        orElse: () => null);
    return p != null;
  }

  /// This is used to convert the local time to UTC.
  /// The [DatePicker] returns a date object with a default time of 00:00
  ///

  static const Duration kLocalTimeInUTC = Duration(hours: 4);
  ProductService _productService = locator<ProductService>();
  OrderService _orderService = locator<OrderService>();
  NavigationService _navigationService = locator<NavigationService>();
  ProductOrdering _productOrdering = ProductOrdering.alphaAsc;

  String _skuSearchString = "";
  String get skuSearchString => _skuSearchString;

  List<Product> filteredProductList = <Product>[];
  get customerName => _adhocCartService.customerName ?? "Walk In Customer";

  // Check if the cart has items
  bool get cartHasItems => _adhocCartService.items.isNotEmpty;

  // Get the item count
  int get itemCount => _adhocCartService.items.length;

  // Reset the items in the cart
  resetCart() {
    _adhocCartService.resetCart();
    notifyListeners();
  }

  updateSearchString(String val) {
    _skuSearchString = val.trim();
    search();
    notifyListeners();
  }

  toggleShowSummary(bool val) {
    _displaySummary = val;
    notifyListeners();
  }

  search() {
    if (skuSearchString.isNotEmpty) {
      _updateSKUList(skuSearchString);
    } else {
      _resetSKUList();
    }
  }

  List<Product> filterBySKU(String val) {
    if (val.isNotEmpty) {
      return productList
          .where((product) =>
              product.itemName.toLowerCase().contains(val.toLowerCase()))
          .toList();
    } else
      return productList;
  }

  _resetSKUList() {
    _skuSearchString = "";
    filteredProductList = productList;
    notifyListeners();
  }

  _updateSKUList(String val) {
    filteredProductList = productList
        .where((product) =>
            product.itemName.toLowerCase().contains(val.toLowerCase()))
        .toList();
    notifyListeners();
  }

  navigateToCustomerDetailView() async {
    await _navigationService.popRepeated(1);
  }

  updateProductOrdering(ProductOrdering val) {
    _productOrdering = val;
    notifyListeners();
  }

  Customer _customer;
  Customer get customer => _customer;

  SalesOrderViewModel({@required Customer customer, bool isWalkIn})
      : _customer = customer,
        _isWalkIn = isWalkIn;

  String _remarks = "";
  String get remarks => _remarks;
  updateRemarks(String val) {
    _remarks = val;
    notifyListeners();
  }

  List<Product> _productList = [];

  List<Product> get productList {
    if (_productList.isNotEmpty) {
      switch (_productOrdering) {
        case ProductOrdering.alphaAsc:
          _productList.sort((a, b) => a.itemCode.compareTo(b.itemCode));
          break;
        case ProductOrdering.alphaDesc:
          _productList.sort((b, a) => a.itemCode.compareTo(b.itemCode));
          break;
      }
      if (skuSearchString.isNotEmpty) {
        return _productList
            .where((product) =>
                product.itemPrice > 0 &&
                product.itemName
                    .toLowerCase()
                    .contains(skuSearchString.toLowerCase()))
            .toList();
      }
      return _productList.where((product) => product.itemPrice > 0).toList();
    }
    return _productList;
  }

  resetSearch() {
    _skuSearchString = "";
    _displaySummary = true;
    _resetSKUList();
    notifyListeners();
  }

  bool _displaySummary = true;
  bool get displaySummary => _displaySummary;
  changeSummaryState(bool val) {
    _displaySummary = val;
    notifyListeners();
  }

  int get totalNoOfProducts => _productList.length;

  double _total = 0.00;
  double get total => _total;

  List<SalesOrderItem> _salesOrderItems = [];
  List<SalesOrderItem> get salesOrderItems => _salesOrderItems;

  List<Product> _items = [];
  List<Product> get items => _items;

  String _dueDate;
  String get dueDate => _dueDate;

  /// Added [Duration] 4 hours to the selected [DateTime]
  void setDueDate(DateTime dateTime) {
    _dueDate = dateTime.add(Duration(hours: 4)).toUtc().toIso8601String();
    notifyListeners();
  }

  /// It shall always start the following day
  //  DateTime _initialDate = DateTime.now().add(Duration(days: 1));
  DateTime _initialDate = DateTime.now();
  DateTime get initialDate => _initialDate;

  DateTime get firstDate => _initialDate;
  DateTime get lastDate => firstDate.add(Duration(days: 1));

  String formatDate(DateTime dateTime) {
    String result;
    var formatter = DateFormat('yyyy-MM-dd');
    result = formatter.format(dateTime);
    return result;
  }

  increaseSalesOrderItems(Product p, quantity) {
    _adhocCartService.increaseSalesOrderItems(p, quantity);
    if (_items.contains(p)) {
      // Get the element that contains the product in the sales item
      for (int i = 0; i < _salesOrderItems.length; i++) {
        if (_salesOrderItems[i].item == p) {
          // Increase the value of the sales order item
          _salesOrderItems[i].quantity += quantity;
          notifyListeners();
        }
      }
    } else {
      _items.add(p);
      SalesOrderItem s = SalesOrderItem(item: p, quantity: quantity);
      _salesOrderItems.add(s);
      notifyListeners();
    }
  }

  editQuantityManually(Product p, quantity) {
    if (_items.contains(p)) {
      for (int i = 0; i < _salesOrderItems.length; i++) {
        if (_salesOrderItems[i].item == p) {
          _salesOrderItems[i].quantity == quantity;
          if (quantity == 0) {
            items.remove(p);
            _salesOrderItems.removeAt(i);
          }
        }
      }
      notifyListeners();
    } else {
      //Add the item
      _items.add(p);
      salesOrderItems.add(SalesOrderItem(item: p, quantity: quantity));
      notifyListeners();
    }
  }

  decreaseSalesOrderItems(Product p, quantity) {
    _adhocCartService.decreaseSalesOrderItems(p, quantity);
    if (_items.contains(p)) {
      // Get the element that contains the product in the sales item
      for (int i = 0; i < _salesOrderItems.length; i++) {
        if (_salesOrderItems[i].item == p) {
          // Decrease the value of the sales order item
          _salesOrderItems[i].quantity -= quantity;
          if (salesOrderItems[i].quantity == 0) {
            _items.remove(p);
            _salesOrderItems.removeAt(i);
          }
        }
      }
    }
    notifyListeners();
  }

  addToTotal(double value, {Product item}) {
    _total += value;
    _adhocCartService.addToTotal(value, item: item);
    notifyListeners();
  }

  removeFromTotal(double value, {Product item}) {
    if (total > 0) {
      _total -= value;
      _adhocCartService.subtractFromTotal(value, item: item);
    }
    notifyListeners();
  }

  DialogService _dialogService = locator<DialogService>();

  init() async {
    await fetchProducts();
    // _adhocCartService.initializeSalesOrderItems(productList);
  }

  Future fetchProducts() async {
    setBusy(true);
    var result = await _productService.fetchProductsByPriceList(customer);
    setBusy(false);
    if (result is List<Product>) {
      _productList = result;
      _customerProductList = result;
      filteredProductList = productList;
      return _productList;
    } else {
      _customerProductList = <Product>[];
      await _dialogService.showDialog(
          title: 'Error', description: 'An error occurred.');
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_adhocCartService];

  onEditComplete() {
    notifyListeners();
  }

  onFieldSubmitted(String val) {
    print(val);
    print('Field Submitted');
  }

  final bool _isWalkIn;
  bool get isWalkIn => _isWalkIn;

  initializeAdhoc() async {
    setBusy(true);
    if (customer != null) {
      await _adhocCartService.initializeCustomerData(
          customer, customerProductList);
    }
    await fetchStockBalance();
    // await fetchProductsByPrice();
    isWalkIn ? await fetchProductsByPrice() : await fetchProducts();
    // _productList.removeWhere((item) => stockBalanceList.contains(item));
    setBusy(false);
  }

  double get securityBalance => _adhocCartService.securityBalance;
  double get securityAmount => _adhocCartService.securityAmount;
  double get creditLimit => _adhocCartService.creditLimit;

  Future fetchProductsByPrice() async {
    setBusy(true);
    var result = await _productService.fetchProductsByDefaultPriceList(
        defaultStock: _adhocCartService.sellingPriceList);
    setBusy(false);
    if (result is List<Product>) {
      _productList = result;
      _customerProductList = result;
      notifyListeners();
    } else {
      _productList = <Product>[];
      _customerProductList = <Product>[];
    }
  }

  getAdhocQuantity(Product product) {
    var result = stockBalanceList.firstWhere((element) {
      print(element.itemCode);
      return element.itemCode.toString().toLowerCase() ==
          product.itemCode.toString().toLowerCase();
    }, orElse: () => null);
    return result?.initialQuantity ?? 0;
  }

  getQuantity(Product product) {
    var result = salesOrderItems.firstWhere((element) {
      return element.item.itemCode.toString().toLowerCase() ==
          product.itemCode.toString().toLowerCase();
    }, orElse: () => null);
    return result?.quantity ?? 0;
  }

  Future fetchStockBalance() async {
    var result = await _stockControllerService.getStockBalance();
    if (result is List<Product>) {
      _stockBalanceList = result;
      _stockBalanceList.removeWhere(
          (element) => element.itemName.toLowerCase().contains("crate"));
      print(stockBalanceList.length);
      notifyListeners();
    } else if (result is CustomException) {
      _stockBalanceList = <Product>[];
      notifyListeners();
      await _dialogService.showDialog(
          title: result.title, description: result.description);
    }
  }

  List<Product> _customerProductList = [];
  List<Product> get customerProductList => _customerProductList;

  List<Product> _stockBalanceList = [];
  List<Product> get stockBalanceList => _stockBalanceList;

  compareValues() {
    print("Credit Limit----$creditLimit---");
    print("Total ----$total---");
    print("Security Amount ----$securityAmount---");
    print("Security Balance ----$securityBalance---");
    return (creditLimit - (total + securityBalance)) >= 0;
  }

  navigateToAdhocPaymentView() async {
    //Compare security
    // if (!compareValues()) {
    //   num security =
    //       isVariable ? (securityBalance - securityAmount) : securityAmount;
    //
    //   num exceededLimit = -1 * (creditLimit - (total + security));
    //   await _dialogService.showDialog(
    //       title: 'Credit Limit Exceeded',
    //       description:
    //           'Available Limit :$creditLimit\nTotal : $total\nSecurity : $security\n\nYou have exceeded the credit limit allocated by $exceededLimit');
    // } else {
    //   await _navigationService.navigateTo(Routes.adhocPaymentView);
    // }
    await _navigationService.navigateTo(Routes.adhocPaymentView);
  }

  navigateToPaymentView() async {
    await _navigationService.navigateToView(
      PaymentView(
        items: _adhocCartService.itemsInCart,
        total: _adhocCartService.total,
      ),
    );
  }
}
