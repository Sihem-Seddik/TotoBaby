import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../elements/GridItemWidget.dart';
import '../models/market.dart';

class GridWidget extends StatelessWidget {
  final List<Market> marketsList;
  final String heroTag;
  GridWidget({Key key, this.marketsList, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4, // Number of columns
      mainAxisSpacing: 15.0, // Spacing between items on the main axis
      crossAxisSpacing: 15.0, // Spacing between items on the cross axis
      children: List.generate(marketsList.length, (int index) {
        final market = marketsList[index];
        return GridItemWidget(market: market, heroTag: heroTag);
      }),
    );
  }
}
