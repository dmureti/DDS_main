import 'dart:io';

import 'package:distributor/app/locator.dart';
import 'package:distributor/firebase_options.dart';
import 'package:distributor/main.dart';
import 'package:distributor/ui/setup_snackbar_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripletriocore/tripletriocore.dart';

import 'services/init_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => print(value.name));
  setupLocator();
  setupSnackbarUi();
  InitService _initService = locator<InitService>();
  _initService.setAvailableEnvList([
    // AppEnv(
    //   flavor: Flavor.mini,
    //   name: 'mini',
    //   flavorValues: FlavorValues(
    //       baseUrl: 'https://mbnl.ddsolutions.tech/dds-backend/api/v1'),
    // ),
    AppEnv(
      flavor: Flavor.demo,
      name: 'DDS Demo',
      flavorValues:
          FlavorValues(baseUrl: 'http://63.34.178.251:8888/dds-backend/api/v1'),
    ),
  ]);
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(MainApp());
}
