import 'package:flutter/material.dart';
import '../../appTheme.dart';
import '../../models/hotelListData.dart';

class PopularListView extends StatefulWidget {
  final Function(int) callBack;
  final AnimationController animationController;
  const PopularListView({Key key, this.callBack, this.animationController})
      : super(key: key);
  @override
  _PopularListViewState createState() => _PopularListViewState();
}

class _PopularListViewState extends State<PopularListView>
    with TickerProviderStateMixin {
  var popularList = HotelListData.popularList;
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animationController,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - widget.animationController.value), 0.0),
            child: Container(
              height: 180,
              width: double.infinity,
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, right: 24, left: 8),
                      itemCount: popularList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var count =
                            popularList.length > 10 ? 10 : popularList.length;
                        var animation = Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController.forward();
                        return CategoryView(
                          popularList: popularList[index],
                          animation: animation,
                          animationController: animationController,
                          callback: () {
                            widget.callBack(index);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryView extends StatelessWidget {
  final VoidCallback callback;
  final HotelListData popularList;
  final AnimationController animationController;
  final Animation animation;

  const CategoryView(
      {Key key,
      this.popularList,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, bottom: 24, top: 16, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.getTheme().dividerColor,
                        offset: Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 2,
                          child: Image.asset(
                            popularList.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.getTheme()
                                            .dividerColor
                                            .withOpacity(0.4),
                                        AppTheme.getTheme()
                                            .dividerColor
                                            .withOpacity(0.0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 32, top: 8),
                                    child: Text(
                                      popularList.titleTxt,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color:
                                            AppTheme.getTheme().backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
