import 'package:flutter/material.dart';
import '../../appTheme.dart';
import '../../models/orderListData.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingView extends StatelessWidget {
  final OrderListData hotelData;

  const RatingView({Key key, this.hotelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getTheme().backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.getTheme().dividerColor,
            blurRadius: 8,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: Text(
                    (hotelData.baseFare * 2).toStringAsFixed(1),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 38,
                      color: AppTheme.getTheme().primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Overall Rating',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppTheme.getTheme()
                                .disabledColor
                                .withOpacity(0.8),
                          ),
                        ),
                        SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: hotelData.tip,
                          size: 16,
                          color: AppTheme.getTheme().primaryColor,
                          borderColor: AppTheme.getTheme().primaryColor,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            getBarUI('Room', 95.0),
            SizedBox(
              height: 4,
            ),
            getBarUI('Service', 80.0),
            SizedBox(
              height: 4,
            ),
            getBarUI('Location', 65.0),
            SizedBox(
              height: 4,
            ),
            getBarUI('Price', 85),
          ],
        ),
      ),
    );
  }

  Widget getBarUI(String text, double percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 60,
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppTheme.getTheme().disabledColor.withOpacity(0.8),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: percent.toInt(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.getTheme().primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 100 - percent.toInt(),
                child: SizedBox(),
              )
            ],
          ),
        )
      ],
    );
  }
}
