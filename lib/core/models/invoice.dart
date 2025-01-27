import 'package:distributor/core/models/app_models.dart';
import 'package:flutter/foundation.dart';
import 'package:tripletriocore/tripletriocore.dart';

class Invoice {
  final String id;
  final List items;
  final String transactionStatus;
  CustomerDetail customerDetail;
  SellerDetail sellerDetail;
  String _transactionDate;
  // Type of transaction
  String transactionType;
  num total;
  num gross;
  double net;
  double tax;
  double withholdingTax;
  double discount;
  String deviceNo;
  String warehouse;
  String sellingPriceList;
  String currency;
  String qrCode;
  String fdn;
  String verificationCode;
  String remarks;
  String mode;
  num invoiceNumber;

  String get customerName => customerDetail.customerName;
  String get sellerName => sellerDetail.sellerName;
  String get transactionDate => _transactionDate;

  Invoice(
      {@required this.items,
      @required this.id,
      this.fdn = "",
      this.qrCode = "",
      this.verificationCode = "",
      this.remarks = "",
      this.transactionStatus,
      this.mode = "Online",
      this.currency,
      this.warehouse,
      this.net,
      this.tax,
      this.deviceNo = "",
      this.total,
      this.gross,
      this.sellingPriceList,
      this.transactionType,
      this.discount,
      this.withholdingTax,
      this.invoiceNumber,
      CustomerDetail customerDetail,
      SellerDetail sellerDetail,
      String transactionDate})
      : _transactionDate = transactionDate ?? DateTime.now().toIso8601String();

  factory Invoice.fromAdhocDetail(AdhocDetail adhocDetail, String currency,
      {SellerDetail sellerDetail, CustomerDetail customerDetail}) {
    String id = adhocDetail.referenceNo;
    return Invoice(
        mode: adhocDetail.mode,
        fdn: adhocDetail.fdn,
        withholdingTax: adhocDetail.withholdingTax,
        qrCode: adhocDetail.qrCode,
        remarks: adhocDetail.remarks,
        verificationCode: adhocDetail.verificationCode,
        currency: currency,
        customerDetail: customerDetail,
        warehouse: adhocDetail.warehouseId,
        gross: adhocDetail.gross,
        sellingPriceList: adhocDetail.sellingPriceList,
        id: id,
        total: adhocDetail.total,
        items: adhocDetail.saleItems,
        transactionDate: adhocDetail.transactionDate,
        transactionType: adhocDetail.baseType,
        transactionStatus: adhocDetail.transactionStatus,
        deviceNo: adhocDetail.deviceNo,
        net: adhocDetail.net,
        sellerDetail: sellerDetail,
        discount: adhocDetail.discount,
        tax: adhocDetail.tax);
  }

  factory Invoice.fromDeliveryNote(
      DeliveryNote deliveryNote, String currency, String orderId,
      {SellerDetail sellerDetail}) {
    CustomerDetail customerDetail = CustomerDetail(
        customerId: deliveryNote.customerId.toString(),
        customerName: deliveryNote.customerName,
        customerAddress: deliveryNote.address);
    return Invoice(
        warehouse: deliveryNote.deliveryWarehouse,
        currency: currency,
        discount: deliveryNote.discount,
        verificationCode: deliveryNote.verificationCode,
        remarks: deliveryNote.remarks,
        qrCode: deliveryNote.qrCode,
        fdn: deliveryNote.fdn,
        mode: deliveryNote.mode,
        withholdingTax: deliveryNote.withholdingTax,
        gross: deliveryNote.gross,
        net: deliveryNote.net,
        total: deliveryNote.total,
        deviceNo: deliveryNote.deviceNo,
        sellerDetail: sellerDetail,
        tax: deliveryNote.tax,
        transactionDate: deliveryNote.deliveryDate,
        transactionType: deliveryNote.deliveryType,
        customerDetail: customerDetail,
        sellingPriceList: deliveryNote.sellingPriceList,
        transactionStatus: deliveryNote.deliveryStatus,
        id: orderId,
        items: deliveryNote.deliveryItems);
  }

  factory Invoice.fromMap(var data) {
    List items = data['items'];
    String id = data['id'];
    double discount = data['discount'] ?? 0.00;
    double withholding = data['withholding'] ?? 0.00;
    String deliveryStatus = data['deliveryStatus'];
    double tax = data['tax'] ?? 0.00;
    num invoiceNumber = data['invoiceNumber'] ?? 0;

    return Invoice(
        items: items,
        id: id,
        discount: discount,
        withholdingTax: withholding,
        tax: tax,
        invoiceNumber: invoiceNumber);
  }
}

class SellerDetail {
  String sellerName;
  String sellerId;
}

class CustomerDetail {
  String customerName;
  String customerId;
  String customerAddress;
  String taxId;

  CustomerDetail(
      {this.customerName,
      this.customerId,
      this.customerAddress,
      this.taxId = "NA"});

  factory CustomerDetail.fromCustomer(Customer customer) {
    return CustomerDetail(
        customerName: customer.name,
        customerId: customer.id,
        taxId: customer.taxId,
        customerAddress: customer.customerType);
  }
}
