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
  String deviceNo;
  String warehouse;
  String sellingPriceList;

  String get customerName => customerDetail.customerName;
  String get sellerName => sellerDetail.sellerName;
  String get transactionDate => _transactionDate;

  Invoice(
      {@required this.items,
      @required this.id,
      this.transactionStatus,
      this.warehouse,
      this.net,
      this.tax,
      this.deviceNo,
      this.total,
      this.gross,
      this.sellingPriceList,
      this.transactionType,
      CustomerDetail customerDetail,
      SellerDetail sellerDetail,
      String transactionDate})
      : _transactionDate = transactionDate ?? DateTime.now().toIso8601String();

  factory Invoice.fromAdhocDetail(AdhocDetail adhocDetail,
      {SellerDetail sellerDetail}) {
    String id = adhocDetail.referenceNo;
    CustomerDetail customerDetail = CustomerDetail(
        customerName: adhocDetail.customerName,
        customerId: adhocDetail.customerId);
    return Invoice(
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
        tax: adhocDetail.tax);
  }

  factory Invoice.fromDeliveryNote(DeliveryNote deliveryNote,
      {SellerDetail sellerDetail}) {
    CustomerDetail customerDetail = CustomerDetail(
        customerId: deliveryNote.customerId.toString(),
        customerName: deliveryNote.customerName,
        customerAddress: deliveryNote.address);
    return Invoice(
        warehouse: deliveryNote.deliveryWarehouse,
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
        id: deliveryNote.deliveryNoteId,
        items: deliveryNote.deliveryItems);
  }

  factory Invoice.fromMap(var data) {
    List items = data['items'];
    String id = data['id'];
    String deliveryStatus = data['deliveryStatus'];
    return Invoice(items: items, id: id);
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
