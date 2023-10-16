import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/category_controller.dart';
import '../controllers/market_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/GalleryCarouselWidget.dart';
import '../elements/ProductGridItemWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../elements/ProductListItemWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';
import 'category.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  MarketController _con;

  List<String> selectedCategories;
  CategoryController _con2;
  _MenuWidgetState() : super(MarketController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForGalleries(widget.routeArgument.id);
    _con.market = (new Market())..id = widget.routeArgument.id;
    _con.listenForTrendingProducts(widget.routeArgument.id);
    _con.listenForCategories();
    selectedCategories = ['0'];
    _con.listenForProducts(widget.routeArgument.id);
    super.initState();
  }

  String layout = 'grid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //change drawer color
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color:
              Theme.of(context).hintColor, // Change this to your desired color
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.products.isNotEmpty ? _con.products[0].market.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(onClickFilter: (filter) {
                _con.scaffoldKey?.currentState?.openEndDrawer();
              }),
            ),
            ImageThumbCarouselWidget(galleriesList: _con.galleries),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.bookmark,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).featured_products,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            ProductsCarouselWidget(
                heroTag: 'menu_trending_product',
                productsList: _con.trendingProducts),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.subject,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).products,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            _con.categories.isEmpty
                ? SizedBox(height: 90)
                : Container(
                    height: 80,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_con.categories.length, (index) {
                        var _category = _con.categories.elementAt(index);
                        var _selected =
                            this.selectedCategories.contains(_category.id);
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: RawChip(
                            elevation: 0,
                            label: Text(_category.name),
                            labelStyle: _selected
                                ? Theme.of(context).textTheme.bodyText2.merge(
                                    TextStyle(
                                        color: Theme.of(context).primaryColor))
                                : Theme.of(context).textTheme.bodyText2,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            backgroundColor:
                                Theme.of(context).focusColor.withOpacity(0.1),
                            selectedColor: Theme.of(context).accentColor,
                            selected: _selected,
                            //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                            showCheckmark: false,
                            avatar: (_category.id == '0')
                                ? null
                                : (_category.image.url
                                        .toLowerCase()
                                        .endsWith('.svg')
                                    ? CircularProgressIndicator()
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: _category.image.icon,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                            onSelected: (bool value) {
                              setState(() {
                                if (_category.id == '0') {
                                  this.selectedCategories = ['0'];
                                } else {
                                  this
                                      .selectedCategories
                                      .removeWhere((element) => element == '0');
                                }
                                if (value) {
                                  this.selectedCategories.add(_category.id);
                                } else {
                                  this.selectedCategories.removeWhere(
                                      (element) => element == _category.id);
                                }
                                _con.selectCategory(this.selectedCategories);
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              this.layout = 'list';
                            });
                          },
                          icon: Icon(
                            Icons.format_list_bulleted,
                            color: this.layout == 'list'
                                ? Theme.of(context).accentColor
                                : Theme.of(context).focusColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              this.layout = 'grid';
                            });
                          },
                          icon: Icon(
                            Icons.apps,
                            color: this.layout == 'grid'
                                ? Theme.of(context).accentColor
                                : Theme.of(context).focusColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _con.products.isEmpty
                    ? CircularLoadingWidget(height: 500)
                    : Offstage(
                        offstage: this.layout != 'list',
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.products.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return ProductListItemWidget(
                              heroTag: 'favorites_list',
                              product: _con.products.elementAt(index),
                            );
                          },
                        ),
                      ),
                _con.products.isEmpty
                    ? CircularLoadingWidget(height: 500)
                    : Offstage(
                        offstage: this.layout != 'grid',
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4,
                          // Generate 100 widgets that display their index in the List.
                          children:
                              List.generate(_con.products.length, (index) {
                            return ProductGridItemWidget(
                                heroTag: 'category_grid',
                                product: _con.products.elementAt(index),
                                onPressed: () {
                                  if (currentUser.value.apiToken == null) {
                                    Navigator.of(context).pushNamed('/Login');
                                  } else {
                                    if (_con2.isSameMarkets(
                                        _con2.products.elementAt(index))) {
                                      _con2.addToCart(
                                          _con.products.elementAt(index));
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AddToCartAlertDialogWidget(
                                              oldProduct: _con2.carts
                                                  .elementAt(0)
                                                  ?.product,
                                              newProduct: _con.products
                                                  .elementAt(index),
                                              onPressed: (product,
                                                  {reset: true}) {
                                                return _con2.addToCart(
                                                    _con.products
                                                        .elementAt(index),
                                                    reset: true);
                                              });
                                        },
                                      );
                                    }
                                  }
                                });
                          }),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
