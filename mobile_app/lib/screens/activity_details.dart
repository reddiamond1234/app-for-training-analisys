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
      if (widget.activity.positions?.firstOrNull != null)
        Polyline(
          polylineId: const PolylineId("activity"),
          points: widget.activity.positions!
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
              if (widget.activity.positions?.firstOrNull != null) ...[
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
                          activity.positions!.first.latitude,
                          activity.positions!.first.longitude,
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
                    content: "${activity.elevationClimbed?.toEUString()}",
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
                    content: activity.normalizedPower?.toEUString() ?? "/",
                    suffixText: "Moč [W]",
                  ),
                  FDTextField(
                    readOnly: true,
                    content: activity.elevationDescended?.toEUString() ?? "/",
                    suffixText: "Spust [m]",
                  ),
                ],
              ),
              if (activity.insight != null) ...[
                const SizedBox(height: 30),
                Text("Forma", style: BVTextStyles.heading02),
                const SizedBox(height: 5),
                FDDoubleColumn(
                  children: [
                    FDTextField(
                      readOnly: true,
                      content: activity.insight!.tss.toEUString(),
                      suffixText: "TSS",
                    ),
                    FDTextField(
                      readOnly: true,
                      content: activity.insight!.form.toEUString(),
                      suffixText: "Forma",
                    ),
                    FDTextField(
                      readOnly: true,
                      content: activity.insight!.ctl.toEUString(),
                      suffixText: "CTL",
                    ),
                    FDTextField(
                      readOnly: true,
                      content: activity.insight!.atl.toEUString(),
                      suffixText: "ATL",
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              Text("Grafi", style: BVTextStyles.heading01),
              const SizedBox(height: 5),
              if (activity.power != null && activity.power!.isNotEmpty) ...[
                Text("Moč", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "power",
                        data: activity.power!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: activity.timestamps![i],
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
              if (activity.elevation?.firstOrNull != null) ...[
                Text("Vzpon", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "elevation",
                        data: activity.elevation!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: activity.timestamps![i],
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
              if (activity.heartRate?.firstOrNull != null) ...[
                Text("Srčni utrip", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "heartRate",
                        data: activity.heartRate!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: activity.timestamps![i],
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
              if (activity.speed?.firstOrNull != null) ...[
                Text("Hitrost", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "speed",
                        data: activity.speed!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: activity.timestamps![i],
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
              if (activity.cadence?.firstOrNull != null) ...[
                Text("Kadenca", style: BVTextStyles.headingEnter),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: DChartLineT(
                    groupList: [
                      TimeGroup(
                        id: "cadence",
                        data: activity.cadence!
                            .mapIndexed(
                              (i, e) => TimeData(
                                domain: activity.timestamps![i],
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
