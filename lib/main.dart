import 'package:distributor/app/locator.dart';
import 'package:distributor/app/router.gr.dart';
import 'package:distributor/conf/style/lib/colors.dart';
import 'package:distributor/conf/style/lib/fonts.dart';
import 'package:distributor/core/enums.dart';
import 'package:distributor/services/connectivity_service.dart';
import 'package:distributor/ui/shared/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tripletriocore/tripletriocore.dart';
import 'package:distributor/app/router.gr.dart' as app_router;

import 'conf/dds_brand_guide.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      create: (context) =>
          ConnectivityService().connectionStatusController.stream,
      child: MaterialApp(
        supportedLocales: const [Locale('en'), Locale('en_us')],
        title: Globals.appName,
        debugShowCheckedModeBanner: false,
        theme: _kAppTheme,
        initialRoute: Routes.startupView,
        onGenerateRoute: app_router.Router().onGenerateRoute,
        navigatorKey: locator<NavigationService>().navigatorKey,
      ),
    );
  }
}

final ThemeData _kAppTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: kColDDSPrimaryDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // canvasColor: kCanvasColor,
    dialogTheme: DialogTheme(
        titleTextStyle:
            TextStyle(fontWeight: FontWeight.w700, color: Colors.indigo)),
    appBarTheme: AppBarTheme(
      elevation: 1.0,
      color: kColDDSPrimaryDark,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: kMediumTextSize,
          fontFamily: kFontBoldBody),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kColDDSPrimaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: base.iconTheme.copyWith(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(10.0),
      focusColor: Colors.grey,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: kColorMiniDarkBlue, style: BorderStyle.solid, width: 2),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.green, style: BorderStyle.solid, width: 2.0),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      filled: false,
    ),
    textTheme: _buildAppTextTheme(base.textTheme),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: kColorDDSPrimaryDark, actionTextColor: kColorNeutral),
  );
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(
          color: kColorDDSPrimaryLight,
          fontFamily: kFontBoldBody,
        ),
        headline6: base.headline6.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontFamily: kFontBoldBody,
          fontSize: 14.0,
        ),
        bodyText1: base.bodyText1.copyWith(
            fontFamily: kFontLightBody,
            fontSize: kBodyTextSize,
            color: Colors.white),
        button: base.button.copyWith(color: kColDDSPrimaryLight),
        bodyText2: base.bodyText1.copyWith(
            fontFamily: kFontLightBody,
            fontSize: kBodyTextSize,
            color: Colors.white),
      )
      .apply(
        fontFamily: kFontLightBody,
        displayColor: Colors.grey,
        bodyColor: Colors.black,
      );
}
