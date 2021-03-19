// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i9;
import 'package:tripletriocore/tripletriocore.dart' as _i13;

import '../core/models/data_filter_service.dart' as _i10;
import '../core/models/data_order_service.dart' as _i8;
import '../core/models/product_service.dart' as _i18;
import '../core/models/search_service.dart' as _i19;
import '../services/access_controller_service.dart' as _i3;
import '../services/activity_service.dart' as _i4;
import '../services/api_service.dart' as _i5;
import '../services/cache_service.dart' as _i6;
import '../services/customer_service.dart' as _i7;
import '../services/init_service.dart' as _i11;
import '../services/journey_service.dart' as _i12;
import '../services/logistics_service.dart' as _i14;
import '../services/order_service.dart' as _i15;
import '../services/payments_service.dart' as _i16;
import '../services/permission_service.dart' as _i17;
import '../services/stock_controller_service.dart' as _i20;
import '../services/stop_service.dart' as _i21;
import '../services/third_party_services_module.dart' as _i23;
import '../services/user_service.dart'
    as _i22; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.AccessControlService>(
      () => thirdPartyServicesModule.accessControlService);
  gh.lazySingleton<_i4.ActivityService>(() => _i4.ActivityService());
  gh.lazySingleton<_i5.ApiService>(() => thirdPartyServicesModule.appService);
  gh.lazySingleton<_i6.CacheService>(
      () => thirdPartyServicesModule.cacheService);
  gh.lazySingleton<_i7.CustomerService>(
      () => thirdPartyServicesModule.customerService);
  gh.lazySingleton<_i8.DataOrderService>(() => _i8.DataOrderService());
  gh.lazySingleton<_i9.DialogService>(
      () => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<_i10.FilterService>(() => _i10.FilterService());
  gh.lazySingleton<_i11.InitService>(
      () => thirdPartyServicesModule.initService);
  gh.lazySingleton<_i12.JourneyService>(
      () => thirdPartyServicesModule.journeyService);
  gh.lazySingleton<_i13.LocationService>(
      () => thirdPartyServicesModule.locationService);
  gh.lazySingleton<_i14.LogisticsService>(
      () => thirdPartyServicesModule.logisticsService);
  gh.lazySingleton<_i9.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<_i15.OrderService>(
      () => thirdPartyServicesModule.orderService);
  gh.lazySingleton<_i16.PaymentsService>(() => _i16.PaymentsService());
  gh.lazySingleton<_i17.PermissionService>(() => _i17.PermissionService());
  gh.lazySingleton<_i18.ProductService>(() => _i18.ProductService());
  gh.lazySingleton<_i19.SearchService>(() => _i19.SearchService());
  gh.lazySingleton<_i9.SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  gh.lazySingleton<_i20.StockControllerService>(
      () => thirdPartyServicesModule.stockControlService);
  gh.lazySingleton<_i21.StopService>(() => _i21.StopService());
  gh.lazySingleton<_i22.UserService>(
      () => thirdPartyServicesModule.userService);
  return get;
}

class _$ThirdPartyServicesModule extends _i23.ThirdPartyServicesModule {
  @override
  _i3.AccessControlService get accessControlService =>
      _i3.AccessControlService();
  @override
  _i5.ApiService get appService => _i5.ApiService();
  @override
  _i6.CacheService get cacheService => _i6.CacheService();
  @override
  _i7.CustomerService get customerService => _i7.CustomerService();
  @override
  _i9.DialogService get dialogService => _i9.DialogService();
  @override
  _i11.InitService get initService => _i11.InitService();
  @override
  _i12.JourneyService get journeyService => _i12.JourneyService();
  @override
  _i13.LocationService get locationService => _i13.LocationService();
  @override
  _i14.LogisticsService get logisticsService => _i14.LogisticsService();
  @override
  _i9.NavigationService get navigationService => _i9.NavigationService();
  @override
  _i15.OrderService get orderService => _i15.OrderService();
  @override
  _i9.SnackbarService get snackbarService => _i9.SnackbarService();
  @override
  _i20.StockControllerService get stockControlService =>
      _i20.StockControllerService();
  @override
  _i22.UserService get userService => _i22.UserService();
}