import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/screens/CategoryProductView.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

import '../my_theme.dart';
import 'category_list.dart';
import 'category_products.dart';

class CategoryView extends StatefulWidget {
  const CategoryView(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String category_name;
  int category_id = 1;
  int dummy;

  changeId(int id) {
    setState(() {
      category_id = id;
      dummy = category_id;
    });
  }

  changeName(String catName) {
    setState(() {
      category_name = catName;
    });
    print(category_name + " category_name");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(dummy.toString() + " categoryId");
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(),
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: buildCategoryList()),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: CategoryProductView(
                  category_id: category_id,
                ),
              )
            ],
          )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: widget.is_base_category
          ? GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 0.0),
                  child: Container(
                    child: Image.asset(
                      'assets/hamburger.png',
                      height: 16,
                      color: MyTheme.dark_grey,
                    ),
                  ),
                ),
              ),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      title: Text(
        getAppBarTitle(),
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = widget.parent_category_name == ""
        ? (widget.is_top_category
            ? AppLocalizations.of(context).category_list_screen_top_categories
            : AppLocalizations.of(context).category_list_screen_categories)
        : widget.parent_category_name;

    return name;
  }

  buildCategoryList() {
    var future = widget.is_top_category
        ? CategoryRepository().getTopCategories()
        : CategoryRepository()
            .getCategories(parent_id: widget.parent_category_id);
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("category list error");
            print(snapshot.error.toString());
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: Shimmer.fromColors(
                      baseColor: MyTheme.shimmer_base,
                      highlightColor: MyTheme.shimmer_highlighted,
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var categoryResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.builder(
                primary: false,
                itemCount: categoryResponse.categories.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildCategoryItemCard(categoryResponse, index);
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: Shimmer.fromColors(
                      baseColor: MyTheme.shimmer_base,
                      highlightColor: MyTheme.shimmer_highlighted,
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  Card buildCategoryItemCard(categoryResponse, index) {
    return Card(
      color: category_id == categoryResponse.categories[index].id
          ? Colors.grey.shade200
          : Colors.grey.shade50,
      // shape: RoundedRectangleBorder(
      //   side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
      //   borderRadius: BorderRadius.circular(16.0),
      // ),
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            changeId(categoryResponse.categories[index].id);
            changeName(categoryResponse.categories[index].name);
            print(categoryResponse.categories[index].id);
          });
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 8, 16),
            child: Text(
              categoryResponse.categories[index].name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 12,
                  height: 1.6,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)
                            .category_list_screen_all_products_of +
                        " " +
                        widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
