import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';
import 'package:job_management_system_mobileapp/widgets/richTextWidgets.dart';

class ListViewWidgets {
  ListViewWidgets();

  Widget horizontalListViewWidget(
    String text,
    List<Map<String, dynamic>>? list,
    double? _deviceHeight,
    RichTextWidget? _richTextWidget,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _deviceHeight! * 0.05,
        ),
        _richTextWidget!.simpleText(text, 21, Colors.black87, FontWeight.w600),
        SizedBox(
          height: _deviceHeight * 0.01,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(69, 177, 162, 161),
          ),
          height: _deviceHeight * 0.42,
          child: _buildList(list, _deviceHeight,_richTextWidget),
        ),
      ],
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>>? list,
    double _deviceHeight,
    RichTextWidget _richTextWidget,
  ) {
    return Padding(
      padding: EdgeInsets.all(_deviceHeight! * 0.03),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list?.length ?? 0,
        itemBuilder: (context, index) {
          Map<String, dynamic>? listItem = list?[index];
          if (listItem != null) {
            return _buildItem(
              _richTextWidget,
              listItem,
              listItem['job_position'],
              listItem['company_name'],
              listItem['salary'],
              listItem['location'],
            );
          } else {
            return SizedBox(); // Return an empty SizedBox if vacancy is null
          }
        },
      ),
    );
  }

  Widget _buildItem(RichTextWidget _richTextWidget,Map<String, dynamic> listItem, String jobPosition,
      String companyName, String salary, String location,) {
    return Card(
      color: cardBackgroundColorLayer3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _richTextWidget!.simpleTextWithIconLeft(
                Icons.work, jobPosition, 20, Colors.black, FontWeight.w700),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                _richTextWidget!.simpleTextWithIconRight(Icons.location_pin,
                    location, 15, Colors.black, FontWeight.w700),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _richTextWidget!.simpleTextWithIconRight(Icons.money_rounded,
                    "Rs. $salary", 20, Colors.black, FontWeight.w700),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
