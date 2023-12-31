import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key key,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  @override
  Widget build(BuildContext context) {
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).subtotal,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.subTotal, context,
                          style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).delivery_fee,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      if (Helper.canDelivery(_con.carts[0].product.market,
                          carts: _con.carts))
                        Helper.getPrice(
                            _con.carts[0].product.market.deliveryFee, context,
                            style: Theme.of(context).textTheme.subtitle1)
                      else
                        Helper.getPrice(0, context,
                            style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.taxAmount, context,
                          style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  SizedBox(height: 10),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 90,
                          child: ElevatedButton(
                              onPressed: () {
                                _con.goCheckout(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).accentColor),
                                shape:
                                    MaterialStateProperty.all(StadiumBorder()),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        S.of(context).checkout + '\t',
                                      ),
                                      Helper.getPrice(
                                        _con.total,
                                        context,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    ],
                                  ))))
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
}
