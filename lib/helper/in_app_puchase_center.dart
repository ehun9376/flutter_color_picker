import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPCenter {
  final List<String> kIds;
  final Function(String id) buyComplete;
  List<ProductDetails> products = [];
  late StreamSubscription<dynamic> _subscription;

  IAPCenter({required this.kIds, required this.buyComplete}) {
    init();
  }

  init() async {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    getQueryProductDetails();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if ((purchaseDetails.status == PurchaseStatus.restored ||
              purchaseDetails.status == PurchaseStatus.purchased) &&
          purchaseDetails.pendingCompletePurchase) {
        _completePurchase(purchaseDetails);
      }
    });
  }

  getQueryProductDetails() async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(kIds.toSet());

    products = response.productDetails;
  }

  bool buy(String wantBuyID) {
    if (products.map((e) => e.id).contains(wantBuyID)) {
      final ProductDetails productDetails =
          products.firstWhere((element) => element.id == wantBuyID);
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);

      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
      return true;
    } else {
      return false;
    }
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    debugPrint(
        "=====> Completing Purchase, PurchaseId: ${purchaseDetails.purchaseID}, Token NOT Empty? ${purchaseDetails.verificationData.serverVerificationData.isNotEmpty}");
    buyComplete(purchaseDetails.productID);
    try {
      await InAppPurchase.instance.completePurchase(purchaseDetails);
    } catch (e) {
      debugPrint('=====!!!!! Error completing purchase: $e');
    } finally {}
  }
}
