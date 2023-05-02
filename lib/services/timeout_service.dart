//Service to manage the timeout

import 'dart:async';

import 'package:distributor/app/locator.dart';
import 'package:distributor/app/router.gr.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class TimeoutService {
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  Timer _timer;
  Timer get timer => _timer;

  //Timeout in hours
  final int duration = 2;

  //Initialize the timer
  init() {
    _timer = Timer(Duration(hours: duration), handleTimeout);
  }

  void handleTimeout() async {
    //@TODO Check if there are any unprocessed transactions
    //@TODO Stop all background services
    //@TODO Clear the cache

    //Display a dialog that the session has timed out
    await _dialogService.showDialog(
        title: 'SESSION EXPIRED',
        description: 'Your session has expired. Please sign in again.');

    //Navigate the user to the login page
    _navigationService.pushNamedAndRemoveUntil(Routes.loginView);
  }
}
