import 'package:collection/collection.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_app/models/activity.dart';
import 'package:training_app/style/text_styles.dart';
import 'package:training_app/util/extensions.dart';
import 'package:training_app/widgets/fd_app_bar.dart';
import 'package:training_app/widgets/fd_double_column.dart';
import 'package:training_app/widgets/fd_text_field.dart';

import '../style/colors.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({
    super.key,
    required this.activity,
  });
  final BVActivity activity;

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  late final Set<Polyline> _polyLines;

  @override
  void initState() {
    _polyLines = {
      if (widget.activity.advancedStats?.positions?.firstOrNull != null)
        Polyline(
          polylineId: const PolylineId("activity"),
          points: widget.activity.advancedStats!.positions!
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList(),
          color: BVColors.gold,
        ),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BVActivity activity = widget.activity;
    final AdvancedStats? stats = activity.advancedStats;
    return Scaffold(
      appBar: const FDAppBar(
        title: "Podrobnost aktivnosti",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FDTextField(
                readOnly: true,
                content: widget.activity.name,
                suffixText: "Ime aktivnosti",
              ),
              const SizedBox(height: 10),
              if (widget.activity.advancedStats?.positions?.firstOrNull !=
                  null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      myLocationEnabled: false,
                      polylines: _polyLines,
                      initialCameraPosition: CameraPosition(
                        zoom: 12,
                        target: LatLng(
                          stats!.positions!.first.latitude,
                          stats.positions!.first.longitude,
                        ),
                      ),
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer()),
                      },
                    ),
                  ),
                )
              ],
              const SizedBox(height: 30),
              Text("Osovni podatki", style: BVTextStyles.heading02),
              const SizedBox(height: 5),
              FDDoubleColumn(
                children: [
                  FDTextField(
                    readOnly: true,
                    content: activity.createdAt.toLocaleDate(),
                  ),
                  FDTextField(
                    readOnly: true,
                    content: "${activity.km}",
                    suffixText: "Razdalja [km]",
                  ),
                  FDTextField(
                    readOnly: true,
                    content: "${activity.duration}",
                    suffixText: "Trajanje ",
                  ),
                  FDTextField(
                    readOnly: true,
                    content: "${stats?.elevationClimbed?.toEUString()}",
                    suffixText: "Vzpon [m]",
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("Podrobnejši podatki", style: BVTextStyles.heading02),
              const SizedBox(height: 5),
              FDDoubleColumn(
                children: [
                  FDTextField(
                    readOnly: true,
                    content: stats?.normalizedPower?.toEUString() ?? "/",
                    suffixText: "Moč [W]",
                  ),
                  FDTextField(
                    readOnly: true,
                    content: stats?.elevationDescended?.toEUString() ?? "/",
                    suffixText: "Spust [m]",
                  ),
                ],
              ),
              if (stats?.insight != null) ...[
                const SizedBox(height: 30),
                Text("Forma", style: BVTextStyles.heading02),
                const SizedBox(height: 5),
                FDDoubleColumn(
                  children: [
                    FDTextField(
                      readOnly: true,
                      content: stats!.insight!.tss.toEUString(),
                      suffixText: "TSS",
                    ),
                    FDTextField(
                      readOnly: true,
                      content: stats.insight!.form.toEUString(),
                      suffixText: "Forma",
                    ),
                    FDTextField(
                      readOnly: true,
                      content: stats.insight!.ctl.toEUString(),
                      suffixText: "CTL",
                    ),
                    FDTextField(
                      readOnly: true,
                      content: stats.insight!.atl.toEUString(),
                      suffixText: "ATL",
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              Text("Grafi", style: BVTextStyles.heading01),
              const SizedBox(height: 5),
              if (stats?.power != null && stats!.power!.isNotEmpty) ...[
                Text("Moč", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "power",
                        data: stats.power!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: stats.timestamps![i],
                                measure: e,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
              if (stats?.elevation?.firstOrNull != null) ...[
                Text("Vzpon", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "elevation",
                        data: stats!.elevation!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: stats.timestamps![i],
                                measure: e,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
              if (stats?.heartRate?.firstOrNull != null) ...[
                Text("Srčni utrip", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "heartRate",
                        data: stats!.heartRate!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: stats.timestamps![i],
                                measure: e,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
              if (stats?.speed?.firstOrNull != null) ...[
                Text("Hitrost", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "speed",
                        data: stats!.speed!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: stats.timestamps![i],
                                measure: e,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
              if (stats?.cadence?.firstOrNull != null) ...[
                Text("Kadenca", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "cadence",
                        data: stats!.cadence!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: stats.timestamps![i],
                                measure: e,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
