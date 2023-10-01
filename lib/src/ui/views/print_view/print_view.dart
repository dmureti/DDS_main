import 'package:distributor/core/helper.dart';
import 'package:distributor/src/ui/views/print_view/print_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stacked/stacked.dart';
import 'package:tripletriocore/tripletriocore.dart';

class PrintView extends StatelessWidget {
  final String title;
  final User user;
  var deliveryNote;
  String orderId;
  List items;

  PrintView(
      {Key key,
      this.title,
      @required this.deliveryNote,
      this.user,
      this.orderId = "",
      List items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrintViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: PdfPreview(
            initialPageFormat: PdfPageFormat.letter,
            build: (format) => _generatePdf(format, title, model),
            pageFormats: <String, PdfPageFormat>{
              'A4': PdfPageFormat.a4,
              'Letter': PdfPageFormat.letter,
              'Roll 57': PdfPageFormat.roll57
            },
          ),
        );
      },
      viewModelBuilder: () {
        return PrintViewModel(deliveryNote);
      },
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, PrintViewModel model) async {
    const imageProvider = const AssetImage('assets/images/mini_logo.png');
    final image = await flutterImageProvider(imageProvider);
    final font =
        await rootBundle.load("assets/fonts/proxima_nova/normal/proxima.ttf");
    final ttf = pw.Font.ttf(font);
    final pdf = pw.Document(
        pageMode: PdfPageMode.none,
        compress: false,
        theme: pw.ThemeData(
            defaultTextStyle: pw.TextStyle(font: ttf, fontSize: 14)));
    pdf.addPage(pw.MultiPage(
      // pageFormat: PdfPageFormat.roll57,
      build: (context) {
        return [
          _buildPrintRef(model),
          pw.Wrap(children: [
            _buildHeader(image, model),
            _buildSectionHeader("Section A: Sellers Detail"),
            _buildSellersDetail(user),
            _buildSectionHeader("Section B: URA Information"),
            _buildSectionHeader("Section C: Buyers Details"),
            _buildBuyerDetails(),
            _buildSectionHeader("Section D: Goods and Services Details"),
            ..._buildGoodsAndServices(items ?? deliveryNote.deliveryItems),
            _buildSpacer(),
            _buildSectionHeader("Section E: Tax Details"),
            _buildTaxDetails(model),
            _buildSectionHeader("Section F: Summary"),
            _buildSummary(model),
            _buildSpacer(),
            _buildFooter(model)
          ]),
        ];
      },
    ));

    return pdf.save();
  }

  ///
  /// Build the header of the invoice
  ///
  _buildHeader(pw.ImageProvider image, PrintViewModel model) {
    return pw.Row(children: [
      pw.Padding(
        child: pw.Container(
            child: pw.Image(image, height: 70), width: 100, height: 70),
        padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      ),
      // pw.Placeholder(fallbackHeight: 50, fallbackWidth: 50),
      pw.SizedBox(width: 20),
      pw.Column(children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Row(
          children: [
            pw.Text("Date: "),
            pw.Text("${Helper.formatToTime(model.dateTime)} "),
            pw.Text("${Helper.formatDate(model.dateTime)} "),
          ],
        )
      ], crossAxisAlignment: pw.CrossAxisAlignment.start)
    ]);
  }

  _buildBuyerDetails() {
    return pw.Column(children: [
      pw.Row(children: [
        pw.Text('Customer Name :', style: pw.TextStyle(fontSize: 15)),
        pw.Text(deliveryNote.customerName ?? "",
            style: pw.TextStyle(fontSize: 15))
      ]),
      _buildSpacer()
    ]);
  }

  _buildGoodsAndServices(List deliveryItems) {
    final pw.TextStyle style = pw.TextStyle(fontSize: 15);
    return deliveryItems
        .map(
          (deliveryItem) => pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Column(children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // pw.Text(deliveryItem['itemCode'], style: style),

                  pw.Expanded(
                    child: pw.Text(deliveryItem['itemName'], style: style),
                  ),
                  pw.Container(
                    child: pw.Text(deliveryItem['quantity'].toString(),
                        style: style, textAlign: pw.TextAlign.right),
                  ),
                  pw.Container(
                    child: pw.Text(" x ",
                        style: style, textAlign: pw.TextAlign.right),
                  ),
                  pw.SizedBox(width: 5),
                  pw.Text('${deliveryItem['itemRate']}'.toString(),
                      style: style),
                  pw.SizedBox(width: 5),
                  _buildCurrencyWidget(
                      deliveryItem['itemRate'] * deliveryItem['quantity'],
                      style),
                ],
              )
            ]),
          ),
        )
        .toList();
  }

  _buildSectionHeader(final String sectionHeader) {
    return pw.Column(children: [
      pw.Divider(),
      pw.Text(sectionHeader, style: pw.TextStyle(fontSize: 16)),
      pw.Divider(),
    ]);
  }

  _buildSellersDetail(User user) {
    var deliveryNoteId = deliveryNote.deliveryNoteId == null
        ? deliveryNote.referenceNo
        : orderId;
    final pw.TextStyle textStyle = pw.TextStyle(fontSize: 14);
    return pw.Column(children: [
      // _buildSpacer(),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("TIN", style: textStyle),
          pw.Text("1000219401", style: textStyle),
        ],
      ),
      pw.SizedBox(height: 5),
      pw.Text('MINI BAKERIES(UGANDA) LIMITED'.toUpperCase(), style: textStyle),
      pw.Text('4/5 Spring Road Nakawa'.toUpperCase(), style: textStyle),
      pw.Text('Kampala Nakawa Division'.toUpperCase(), style: textStyle),
      pw.Text('Nakawa Division Bugolobi'.toUpperCase(), style: textStyle),
      pw.Text(user.branch.toUpperCase(), style: textStyle),
      pw.SizedBox(height: 10),
      pw.Row(
        children: [
          pw.Text(
            'Seller\'s Reference No : ',
          ),
          pw.Text(
            user.full_name,
          ),
        ],
      ),
      pw.Row(
        children: [
          pw.Text(
            'Served By : ',
          ),
          pw.Text(
            user.full_name,
          ),
        ],
      ),
      pw.Row(
        children: [
          pw.Text(
            'Transaction Id : ',
          ),
          pw.Text(
            '${deliveryNoteId}',
          ),
        ],
      ),
      pw.Row(
        children: [
          pw.Text(
            'Transaction Date : ',
          ),
          pw.Text(
            '${deliveryNote.deliveryDate}',
          ),
        ],
      ),
      // pw.Row(
      //   children: [
      //     pw.Text('Status : ', style: pw.TextStyle(fontSize: 15)),
      //     pw.Text('${deliveryNote.deliveryStatus}',
      //         style: pw.TextStyle(fontSize: 15)),
      //   ],
      // ),
      _buildSpacer(),
    ]);
  }

  _buildSpacer() {
    return pw.SizedBox(height: 20);
  }

  _buildFooter(PrintViewModel model) {
    return pw.Column(children: [
      _buildSpacer(),
      pw.Center(
        child: pw.Text(model.deviceId, style: pw.TextStyle(fontSize: 14)),
      ),
      pw.SizedBox(height: 2),
      pw.Text("Powered by DDS ver:${model.versionCode}",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
    ], crossAxisAlignment: pw.CrossAxisAlignment.center);
  }

  _buildSummary(PrintViewModel model) {
    final pw.TextStyle style = pw.TextStyle(fontSize: 15);
    return pw.Column(children: [
      pw.SizedBox(height: 5),
      pw.Row(children: [
        pw.Text('Net Amount', style: pw.TextStyle(fontSize: 15)),
        _buildCurrencyWidget(model.netAmount, style),
      ], mainAxisAlignment: pw.MainAxisAlignment.spaceBetween),
      pw.Row(children: [
        pw.Text('Tax Amount', style: pw.TextStyle(fontSize: 15)),
        _buildCurrencyWidget(model.taxAmount, style),
      ], mainAxisAlignment: pw.MainAxisAlignment.spaceBetween),
      pw.Row(children: [
        pw.Text('Gross Amount', style: pw.TextStyle(fontSize: 15)),
        _buildCurrencyWidget(model.grossAmount, style),
      ], mainAxisAlignment: pw.MainAxisAlignment.spaceBetween),
    ]);
  }

  _buildTaxDetails(PrintViewModel model) {
    final pw.TextStyle style = pw.TextStyle(fontSize: 15);
    return pw.Column(children: [
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text('Tax Category : ', style: style),
          pw.Text('A: Standard (${(model.taxRate * 100).toStringAsFixed(0)}%)'),
        ],
      ),
      pw.SizedBox(height: 3),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Net Amt', style: style),
          pw.Text('Tax Amt', style: style),
          pw.Text('Gross Amt', style: style),
        ],
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildCurrencyWidget(model.netAmount, style),
          _buildCurrencyWidget(model.taxAmount, style),
          _buildCurrencyWidget(model.grossAmount, style),
        ],
      ),
    ]);
  }

  _buildCurrencyWidget(num val, pw.TextStyle style) {
    return pw.Text('${val.toStringAsFixed(2)}', style: style);
  }

  ///
  /// Build printer information
  /// Build version info
  ///
  _buildPrintRef(PrintViewModel model) {
    return pw.Row(children: [
      pw.Text("${model.versionCode}-${model.deviceId}",
          style: pw.TextStyle(fontSize: 10)),
    ], mainAxisAlignment: pw.MainAxisAlignment.end);
  }
}
