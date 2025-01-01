import 'package:avaz_app/util/images.dart';
import 'package:flutter/material.dart';

import '../../common/common_text_field_widget.dart';
import '../../model/search_table_model.dart';
import '../../util/app_color_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen(
      {super.key,
      required this.searchList,
      required this.searchChangeTable,
      required this.scaffoldKey,
      required this.dashboradNavigatorKey,
      required this.drawerNavigatorKey});
  final List<SearchTableModel> searchList;
  final Function(SearchTableModel searchTable) searchChangeTable;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<NavigatorState> dashboradNavigatorKey;
  final GlobalKey<NavigatorState> drawerNavigatorKey;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchBarController = TextEditingController();
  List<SearchTableModel> filteredSearchList = [];

  @override
  void initState() {
    super.initState();
    filteredSearchList = widget.searchList; // Initialize with the full list
    searchBarController.addListener(_filterSearchList);
  }

  @override
  void dispose() {
    searchBarController.removeListener(_filterSearchList);
    searchBarController.dispose();
    super.dispose();
  }

  void _filterSearchList() {
    final query = searchBarController.text.toLowerCase();
    setState(() {
      final filteredItems = widget.searchList
          .where((item) => item.voice.toLowerCase().contains(query))
          .toList();
      filteredSearchList = filteredItems.toSet().toList(); // Remove duplicates
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Search",
            style: TextStyle(
              color: AppColorConstants.buttonColorBlue2,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CommonTextFieldWidget(
            controller: searchBarController,
            keyboardType: TextInputType.text,
            hintText: "Search the vocabulary",
            radius: 10,
            prefixIcon: Images.magnifyImage,
            isPrefixIConShow: true,
            onChanged: (value) {}, // Listener already added
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: searchBarController.text.isEmpty
                  ? 10
                  : filteredSearchList.length,
              itemBuilder: (context, index) {
                var searchData = filteredSearchList[index];
                return InkWell(
                  onTap: () {
                    widget.scaffoldKey.currentState?.closeEndDrawer();
                    widget.searchChangeTable(searchData);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              searchData.voice,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColorConstants.buttonColorBlue1,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.arrow_right,
                              color: AppColorConstants.buttonColorBlue1,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              (searchData.category != null
                                      ? "${searchData.category} -> "
                                      : "")
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColorConstants.buttonColorBlue1,
                              ),
                            ),
                            Text(
                              (searchData.subCategorySlug != null
                                      ? "${searchData.subCategorySlug} -> "
                                      : "")
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColorConstants.buttonColorBlue1,
                              ),
                            ),
                            Text(
                              (searchData.voice).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColorConstants.buttonColorBlue1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
