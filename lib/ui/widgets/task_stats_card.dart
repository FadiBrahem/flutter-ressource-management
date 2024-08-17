import 'package:flutter/material.dart';
import 'package:naxxum_projectplanner_mobile_local/ui/shared/ui_helpers.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskStatsCard extends StatelessWidget {
  final Color cardColor;
  final double loadingPercent;
  final String title;
  final String subtitle;
  final String percentTasks;

  TaskStatsCard({
    this.cardColor,
    this.loadingPercent,
    this.title,
    this.subtitle,
    this.percentTasks,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        width: screenWidth(context)/2 - 50,
        height: screenHeight(context)/3,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularPercentIndicator(
                animation: true,
                radius: 75.0,
                percent: loadingPercent,
                lineWidth: 5.0,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white10,
                progressColor: Colors.white,
                center: Text(
                  percentTasks,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            verticalSpace(screenHeight(context)/2.5/5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      
    );
  }
}
