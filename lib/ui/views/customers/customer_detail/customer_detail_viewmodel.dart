import 'package:distributor/app/locator.dart';
import 'package:distributor/app/router.gr.dart';

import 'package:distributor/services/api_service.dart';
import 'package:distributor/services/customer_service.dart';
import 'package:distributor/services/user_service.dart';
import 'package:distributor/src/ui/views/add_issue/add_issue_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tripletriocore/tripletriocore.dart';

class CustomerDetailViewModel extends BaseViewModel {
  final Customer customer;
  final UserService _userService = locator<UserService>();
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CustomerService _customerService = locator<CustomerService>();
  final DialogService _dialogService = locator<DialogService>();
  SnackbarService _snackbarService = locator<SnackbarService>();

  User get user => _userService.user;
  Api get api => _apiService.api;

  int _tabLength = 4;
  int get tabLength => _tabLength;

  String get customerName => customer.name;

  int _initialIndex = 0;
  int get initialIndex => _initialIndex;

  CustomerDetailViewModel({@required this.customer});

  List<double> get coordinates {
    List<double> _coordinates = List<double>();
    if (customer.gpsLocation != null) {
      List<String> splitGPSString = customer.gpsLocation.split(',');
      splitGPSString.map((e) {
        coordinates.add(double.parse(e));
      }).toList();
    }
    return _coordinates;
  }

  Future navigateToCreateSalesOrderView(Customer customer) async {
    //Check if the user has permissions
    bool enableCreateOrder = _customerService.enablePlaceOrderButton();
    if (enableCreateOrder) {
      var result = await _navigationService.navigateTo(
          Routes.createSalesOrderViewRoute,
          arguments: CreateSalesOrderViewArguments(customer: customer));
      await fetchCustomerOrders();
      return result;
    } else {
      await _dialogService.showDialog(
          title: 'Insufficient Permissions',
          description:
              'You do not have sufficient permissions to use this place an order.');
    }
  }

  bool canPlaceOrder() {
    if (_customerService.enablePlaceOrderButton()) {
      return true;
    } else {
      return false;
    }
  }

  bool get enableCreateOrderTab => _customerService.enablePlaceOrderButton();
  bool get enableAccountsTab => _customerService.enableAccountsTab;
  bool get enableOrdersTab => _customerService.enableOrdersTab;

  Future<bool> checkAuthority(int index) async {
    if (index == 2 && !enableAccountsTab) {
      await _dialogService.showDialog(
          title: 'Insufficient Permissions',
          description:
              'You do not have sufficient permissions to view customer accounts.');
      return false;
    } else {
      return true;
    }
  }

  Future fetchCustomerOrders() async {
    setBusy(true);
    List<SalesOrder> result =
        await _customerService.fetchOrdersByCustomer(customer.id);
    setBusy(false);
    return result;
  }

  navigateToCustomers() async {
    await _navigationService.navigateTo(Routes.homeViewRoute);
  }

  void navigateToPaymentReferenceView(Customer customer) async {
    await _navigationService.navigateTo(Routes.paymentReferenceView,
        arguments: PaymentReferenceViewArguments(customer: customer));
  }

  void navigateToPage(String x) async {
    switch (x) {
      case 'link_payment':
        await _navigationService.navigateTo(Routes.paymentReferenceView,
            arguments: PaymentReferenceViewArguments(customer: customer));
        break;
      case 'place_order':
        await navigateToPlaceOrder();
        break;
      case 'add_payment':
        navigateTOAddPayment();
        break;
      case 'make_adhoc_sale':
        navigateToMakeAdhocSale();
        break;
      case 'add_issue':
        navigateToAddIssue();
        break;
    }
  }

  navigateToPlaceOrder() async {
    var result = await _navigationService.navigateTo(
        Routes.createSalesOrderViewRoute,
        arguments: CreateSalesOrderViewArguments(customer: customer));

    if (result) {
      _snackbarService.showSnackbar(
          message: 'The order was placed successfully');
    }
  }

  navigateTOAddPayment() async {
    var result = await _navigationService.navigateTo(Routes.addPaymentView,
        arguments: AddPaymentViewArguments(customer: customer));
    if (result) {
      _snackbarService.showSnackbar(
          message: 'The payment was added successfully.');
    }
  }

  navigateToMakeAdhocSale() async {
    var result = await _navigationService.navigateTo(Routes.adhocSaleView,
        arguments: AddAdhocSaleViewArguments(customer: customer));
  }

  void navigateToAddIssue() async {
    var result = await _navigationService.navigateTo(Routes.addIssueView,
        arguments: AddIssueViewArguments(customer: customer));
    if (result is bool) {
      _snackbarService.showSnackbar(
          message: 'The issue was added successfully.');
    }
  }
}
