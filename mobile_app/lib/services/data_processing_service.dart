import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_tool/fit_tool.dart';
import 'package:flutter/services.dart';
import 'package:training_app/util/extensions.dart';

import '../firebase_options.dart';
import '../models/activity.dart';

class DataProcessingService {
  static DataProcessingService? _instance;
  static DataProcessingService get instance => _instance!;

  DataProcessingService._();

  factory DataProcessingService() {
    if (_instance != null) {
      throw StateError('DataProcessingService already created.');
    }

    _instance = DataProcessingService._();
    return _instance!;
  }

  static Future<BVActivity> processActivity(
    ProcessActivityParams params,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(params.token);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List<DateTime> timestamp = [];
    List<int> power = [];
    List<double> distance = [];
    List<double> speed = [];
    List<int> cadence = [];
    List<double> elevation = [];
    List<int> heartRate = [];
    List<GeoPoint> positions = [];

    final File fitFile = File(params.filePath);

    final appFit = FitFile.fromBytes(await fitFile.readAsBytes());

    for (Record record in appFit.records) {
      final Message message = record.message;

      if (message is RecordMessage) {
        timestamp
            .add(DateTime.fromMillisecondsSinceEpoch(message.timestamp ?? 0));
        distance.add(message.distance ?? 0);
        power.add(message.power ?? 0);
        speed.add(message.speed ?? 0);
        cadence.add(message.cadence ?? 0);
        elevation.add(message.altitude ?? 0);
        heartRate.add(message.heartRate ?? 0);
        if (message.positionLat != null && message.positionLong != null) {
          positions.add(GeoPoint(message.positionLat!, message.positionLong!));
        }
      }
    }

    BVActivity activity = params.activity;

    final double totalDistanceInKm = (distance.last - distance.first) / 1000;

    activity = activity.copyWith(
      km: totalDistanceInKm.toEUString(),
      duration: Duration(
        seconds: timestamp.last.difference(timestamp.first).inSeconds,
      ).toSlovenianDuration(),
      elevationString: elevation.last.toStringAsFixed(2),
    );

    DateTime startTimestamp = timestamp.first;
    List<double> time = timestamp
        .map((t) => t.difference(startTimestamp).inSeconds.toDouble())
        .toList();

    plotData(power, time, speed, cadence, elevation, heartRate);
    printStatistics(speed, cadence, power, heartRate);

    // Calculate elevation climbed and descended
    var elevationChanges = calculateElevationChanges(elevation);
    double elevationClimbed = elevationChanges[0];
    double elevationDescended = elevationChanges[1];
    print("Elevation climbed: ${elevationClimbed.toStringAsFixed(2)} meters");
    print(
        "Elevation descended: ${elevationDescended.toStringAsFixed(2)} meters");

    // Print maximum values
    printMaxValues(power, speed, heartRate, elevation);

    // Initialize training zones
    TrainingZones trainingZones = TrainingZones();

    // Calculate time spent in each training zone
    var zoneTimes = trainingZones.timeInZones(power, time);
    zoneTimes.forEach((zone, timeInZone) {
      int totalTime = (timeInZone * time.last).toInt();
      int hours = totalTime ~/ 3600;
      int minutes = (totalTime % 3600) ~/ 60;
      int seconds = totalTime % 60;
      print(
          "Time spent in power $zone: $hours hours, $minutes minutes, $seconds seconds");
    });

    // Calculate the 30-second interval with the highest average power
    final double maxPower = calculateHighestAveragePowerInterval(power, time);

    // Calculate Normalized Power
    final double normalizedPower = calculateNormalizedPower(power, time);
    print("Normalized Power: ${normalizedPower.toStringAsFixed(2)} W");

    // Define a person
    Person cyclist = Person(height: 1.75, weight: 70, ftp: 250);

    // Update cyclist's training metrics
    cyclist.updateTrainingMetrics(normalizedPower, time.length);

    // Print the person's metrics
    print("Person's TSS: ${cyclist.tss.toStringAsFixed(2)}");
    print("Person's CTL: ${cyclist.ctl.toStringAsFixed(2)}");
    print("Person's ATL: ${cyclist.atl.toStringAsFixed(2)}");
    print("Person's Form: ${cyclist.form.toStringAsFixed(2)}");

    // Write data to JSON
    activity = writeToActivity(
      activity,
      timestamp,
      power,
      speed,
      cadence,
      elevation,
      heartRate,
      zoneTimes,
      normalizedPower,
      cyclist,
      elevationClimbed,
      elevationDescended,
      positions,
    );

    await FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.id)
        .update(activity.toJson());

    return activity;
  }
}

void plotData(List<int> power, List<double> time, List<double> speed,
    List<int> cadence, List<double> elevation, List<int> heartRate) {
  // Plotting logic can be implemented with a suitable Dart charting library
}

void printStatistics(List<double> speed, List<int> cadence, List<int> power,
    List<int> heartRate) {
  double avgSpeed = speed.reduce((a, b) => a + b) / speed.length * 3.6;
  double avgCadence = cadence.reduce((a, b) => a + b) / cadence.length;
  double avgPower = power.reduce((a, b) => a + b) / power.length;
  double avgHeartRate = heartRate.reduce((a, b) => a + b) / heartRate.length;

  print("Average Speed: ${avgSpeed.toStringAsFixed(2)} km/h");
  print("Average Cadence: ${avgCadence.toStringAsFixed(2)} rpm");
  print("Average Power: ${avgPower.toStringAsFixed(2)} W");
  print("Average Heart Rate: ${avgHeartRate.toStringAsFixed(2)} bpm");
}

double calculateHighestAveragePowerInterval(
  List<int> power,
  List<double> time,
) {
  int intervalLength = 30;
  int numIntervals = power.length ~/ intervalLength;

  List<double> averages = [];
  for (int i = 0; i < numIntervals; i++) {
    double avg = power
            .sublist(i * intervalLength, (i + 1) * intervalLength)
            .reduce((a, b) => a + b) /
        intervalLength;
    averages.add(avg);
  }

  double maxAveragePower = averages.reduce((a, b) => a > b ? a : b);
  return maxAveragePower;
  print(
    "The highest average power in any $intervalLength-second interval is: ${maxAveragePower.toStringAsFixed(2)}.",
  );
}

double calculateNormalizedPower(List<int> power, List<double> time) {
  List<double> rollingAveragePower = [];
  for (int i = 0; i < power.length - 29; i++) {
    double avg = power.sublist(i, i + 30).reduce((a, b) => a + b) / 30;
    rollingAveragePower.add(avg);
  }

  List<double> rollingAveragePowerFourth =
      rollingAveragePower.map((p) => p * p * p * p).toList();
  double averagePowerFourth =
      rollingAveragePowerFourth.reduce((a, b) => a + b) /
          rollingAveragePowerFourth.length;

  return pow(averagePowerFourth, 0.25).toDouble();
}

List<double> calculateElevationChanges(List<double> elevation) {
  double elevationClimbed = 0;
  double elevationDescended = 0;
  for (int i = 1; i < elevation.length; i++) {
    double diff = elevation[i] - elevation[i - 1];
    if (diff > 0) {
      elevationClimbed += diff;
    } else if (diff < 0) {
      elevationDescended -= diff; // Make it positive
    }
  }
  return [elevationClimbed, elevationDescended];
}

void printMaxValues(List<int> power, List<double> speed, List<int> heartRate,
    List<double> elevation) {
  int maxPower = power.reduce((a, b) => a > b ? a : b);
  double maxSpeed = speed.reduce((a, b) => a > b ? a : b) * 3.6;
  int maxHeartRate = heartRate.reduce((a, b) => a > b ? a : b);
  double maxElevation = elevation.reduce((a, b) => a > b ? a : b);

  print("Max Power: ${maxPower.toStringAsFixed(2)} W");
  print("Max Speed: ${maxSpeed.toStringAsFixed(2)} km/h");
  print("Max Heart Rate: ${maxHeartRate.toStringAsFixed(1)} bpm");
  print("Max Elevation: ${maxElevation.toStringAsFixed(1)} meters");
}

double calculateIntensityFactor(double normalizedPower, double ftp) {
  return normalizedPower / ftp;
}

double calculateTSS(
    int seconds, double normalizedPower, double intensityFactor, double ftp) {
  return (seconds * normalizedPower * intensityFactor) / (ftp * 3600) * 100;
}

double calculateCTL(double ctlYesterday, double tssToday) {
  return ctlYesterday + (tssToday - ctlYesterday) / 42;
}

double calculateATL(double atlYesterday, double tssToday) {
  return atlYesterday + (tssToday - atlYesterday) / 7;
}

double calculateTSB(double ctlToday, double atlToday) {
  return ctlToday - atlToday;
}

BVActivity writeToActivity(
  BVActivity activity,
  List<DateTime> timestamp,
  List<int> power,
  List<double> speed,
  List<int> cadence,
  List<double> elevation,
  List<int> heartRate,
  Map<String, double> zoneTimes,
  double normalizedPower,
  Person cyclist,
  double elevationClimbed,
  double elevationDescended,
  List<GeoPoint> positions,
) {
  return activity.copyWith(
      timestamps: timestamp,
      power: power,
      speed: speed,
      cadence: cadence,
      elevation: elevation,
      heartRate: heartRate,
      zoneTimes: zoneTimes,
      normalizedPower: normalizedPower,
      insight: ActivityInsight(
        tss: cyclist.tss,
        ctl: cyclist.ctl,
        atl: cyclist.atl,
        form: cyclist.form,
      ),
      positions: positions,
      elevationClimbed: elevationClimbed,
      elevationDescended: elevationDescended);
}

class TrainingZones {
  final Map<String, List<int>> zones;

  factory TrainingZones() {
    return const TrainingZones._(zones: {
      "Zone 1": [0, 100],
      "Zone 2": [101, 200],
      "Zone 3": [201, 300],
      "Zone 4": [301, 400],
      "Zone 5": [401, 5000]
    });
  }

  const TrainingZones._({required this.zones});

  Map<String, double> timeInZones(List<int> power, List<double> time) {
    Map<String, double> zoneTimes = {for (var zone in zones.keys) zone: 0};
    for (var entry in zones.entries) {
      String zone = entry.key;
      int lower = entry.value[0];
      int upper = entry.value[1];
      zoneTimes[zone] = power.where((p) => p >= lower && p < upper).length *
          1.0 /
          time.length;
    }
    return zoneTimes;
  }
}

class Person {
  double height;
  double weight;
  double ftp;
  TrainingZones zones;
  double fatigue;
  double tss;
  double form;
  double ctl;
  double atl;

  Person({required this.height, required this.weight, required this.ftp})
      : zones = TrainingZones(),
        fatigue = 0.0,
        tss = 0.0,
        form = 0.0,
        ctl = 0.0,
        atl = 0.0;

  void updateTrainingMetrics(double normalizedPower, int duration) {
    double intensityFactor = calculateIntensityFactor(normalizedPower, ftp);
    double tss = calculateTSS(duration, normalizedPower, intensityFactor, ftp);
    this.tss = tss;
    ctl = calculateCTL(ctl, tss);
    atl = calculateATL(atl, tss);
    form = calculateTSB(ctl, atl);
  }
}

class ProcessActivityParams {
  final String filePath;
  final BVActivity activity;
  final RootIsolateToken token;

  const ProcessActivityParams(
    this.filePath,
    this.activity,
    this.token,
  );
}
