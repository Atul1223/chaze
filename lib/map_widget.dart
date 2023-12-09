import 'package:chase_map/BackDropFilter_widget.dart';
import 'package:chase_map/Event.dart';
import 'package:chase_map/Profile.dart';
import 'package:chase_map/createEventScreen.dart';
import 'package:chase_map/dbFunction.dart';
import 'package:chase_map/icon_text.dart';
import 'package:chase_map/polyline.dart';
import 'package:chase_map/utlis.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Location location = Location();
  bool _serviceEnabled = false;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isPopupVisible = false;
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 14.0,
  );

  late MapplsMapController mapController;
  double radius = 0;
  double currentZoom = 14.0;
  late LatLng destinationLocation;
  List<LatLng> markerCoordinates = [
    LatLng(13.0698, 77.5460),
  ];
  DirectionsRoute? route;
  bool isNavGoing = false;

  @override
  void initState() {
    super.initState();

    MapplsAccountManager.setMapSDKKey("dcd4f37afdb8625f4dbd33f11205b730");
    MapplsAccountManager.setRestAPIKey("dcd4f37afdb8625f4dbd33f11205b730");
    MapplsAccountManager.setAtlasClientId(
        "96dHZVzsAuvuNLYUiZe3isnXm8gSUtoG2t2KXOwxFwUshFO_TVcqHH_TB1F4rY6NOsNiPTuC-6unCWfrNhAlpH3rqTfHBkUH");
    MapplsAccountManager.setAtlasClientSecret(
        "lrFxI-iSEg-Ev_JYB-O45J4-bvmEyGXratBYBlaeOVIXQcKUifvy1ioMRSghsB8rZMLx-iPyE-gTutF5d0roODymcKG98useBm_bh11AggA=");

    initLocation();

    loadData();
  }

  void initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      MapplsMap(
          initialCameraPosition: _kInitialPosition,
          myLocationEnabled: true,
          trackCameraPosition: true,
          compassEnabled: true,
          rotateGesturesEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          onMapCreated: (mapController) {
            this.mapController = mapController;
            addMarker(markerCoordinates);
          },
          onUserLocationUpdated: (location) => {
                //changeCameraAngle()
              },
          onMapClick: (point, latlng) => {
                radius = calculateRadiusBasedOnZoom(
                    mapController!.cameraPosition!.zoom),
                checkMarkerClick(latlng, radius)
              }),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: FloatingActionButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEvent()),
              )
            },
          ),
        ),
      ),

      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 45.0, right: 30.0),
          child: FloatingActionButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              )
            },
          ),
        ),
      ),
      if (isNavGoing)
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              onPressed: () => {
                setState(() {
                  isNavGoing = false;
                  route = null;
                }),
                mapController.clearLines()
              },
              child: Text('Exit navigation'),
            ),
          ),
        ),

      if (isPopupVisible) const BackDropFilterWidget(),

      // Popup widget
      if (isPopupVisible)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 400.0,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popup Heading',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const TextWithIcon(label: 'Field 1', icon: Icons.person),
                  const TextWithIcon(label: 'Field 2', icon: Icons.lock),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPopupVisible = false;
                      });
                    },
                    child: const Text('Close Popup'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isPopupVisible = false;
                        startNavigation();
                        isNavGoing = true;
                      });
                    },
                    child: const Text('Start Nav'),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  void addMarker(List<LatLng> markerCoordinates) async {
    for (LatLng i in markerCoordinates) {
      await addImageFromAsset("icon", "assets/map/custom-icon.png");
      mapController.addSymbol(SymbolOptions(
          geometry: LatLng(i.latitude, i.longitude), iconImage: "icon"));
    }
  }

  void checkMarkerClick(LatLng clickedLatLng, double radius) {
    for (LatLng markerLatLng in markerCoordinates) {
      if ((markerLatLng.latitude - clickedLatLng.latitude).abs() < radius &&
          (markerLatLng.longitude - clickedLatLng.longitude).abs() < radius) {
        // Marker clicked
        // Perform actions for marker click
        print('Marker clicked: $markerLatLng');
        setState(() {
          isPopupVisible = true;
          destinationLocation = markerLatLng;
        });
        break; // Break the loop once a marker is found
      }
    }
  }

  void startNavigation() async {
    // Get current location
    LatLng? origin = await mapController.requestMyLocationLatLng();
    callDirection(origin!, markerCoordinates[0]);
  }

  callDirection(LatLng originLocation, LatLng destinationLocation) async {
    setState(() {
      route = null;
    });
    try {
      DirectionResponse? directionResponse = await MapplsDirection(
              origin: originLocation,
              destination: destinationLocation,
              alternatives: false,
              steps: true,
              resource: DirectionCriteria.RESOURCE_ROUTE,
              profile: DirectionCriteria.PROFILE_DRIVING)
          .callDirection();

      if (directionResponse != null &&
          directionResponse.routes != null &&
          directionResponse.routes!.isNotEmpty) {
        print("not null res");
        setState(() {
          route = directionResponse.routes![0];
        });
        Polyline polyline = Polyline.decode(
            encodedString: directionResponse.routes![0].geometry, precision: 6);
        List<LatLng> latlngList = [];
        if (polyline.decodedCoords != null) {
          polyline.decodedCoords?.forEach((element) {
            latlngList.add(LatLng(element[0], element[1]));
          });
        }
        if (directionResponse.waypoints != null) {
          List<SymbolOptions> symbols = [];
          directionResponse.waypoints?.forEach((element) {
            symbols.add(
              SymbolOptions(geometry: element.location, iconImage: 'icon'),
            );
          });
          mapController.addSymbols(symbols);
        }
        drawPath(latlngList);
      } else {
        print("is null");
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
    }
  }

  void drawPath(List<LatLng> latlngList) {
    mapController.addLine(LineOptions(
      geometry: latlngList,
      lineColor: "#3bb2d0",
      lineWidth: 4,
    ));
    LatLngBounds latLngBounds = boundsFromLatLngList(latlngList);
    //deinitinitSensors();
    LatLng start = latlngList.first;
    LatLng end = latlngList.last;
    //initSensors();
    //changeCameraAngle();
  }

  // void deinitinitSensors() {
  //   magnetometerValues = [0.0,0.0,0.0];
  //   _streamSubscriptions.remove(magnetometerEventStream());
  //   bearing = 0.0;
  //   changeCameraAngle();
  // }

  // void initSensors() {
  //     _streamSubscriptions.add(
  //     magnetometerEventStream(samplingPeriod: sensorInterval).listen(
  //       (MagnetometerEvent event) {
  //         setState(() {
  //           _magnetometerEvent = event;
  //           if (magnetometerFilter.hasSignificantChange(
  //               event.x, event.y, event.z)) {
  //             magnetometerValues = <double>[event.x, event.y, event.z];
  //             updateBearing();
  //           }
  //           //updateBearing();
  //           // magnetometerValues = <double>[event.x, event.y, event.z];
  //           // updateBearing();
  //         });
  //       },
  //       onError: (e) {
  //         showDialog(
  //             context: context,
  //             builder: (context) {
  //               return const AlertDialog(
  //                 title: Text("Sensor Not Found"),
  //                 content: Text(
  //                     "It seems that your device doesn't support Magnetometer Sensor"),
  //               );
  //             });
  //       },
  //       cancelOnError: true,
  //     ),
  //   );
  // }
  boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<void> loadData() async{
    print("supabase 2");
    dotenv.load();
  // WidgetsFlutterBinding.ensureInitialized();

  print("supabase 1");

  // final SupabaseClient supabaseClient = (await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL'] ?? '',
  //   anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  // )) as SupabaseClient;

  //  await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL'] ?? '',
  //   anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  // );

   await Supabase.initialize(
    url: 'https://ehwrhfywdqhjweqtytuy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVod3JoZnl3ZHFoandlcXR5dHV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk5MDA5NDMsImV4cCI6MjAxNTQ3Njk0M30.pkQkYz1LQQhLLqOUv4Wf9JySZj9iBRt1_l2pK0vsFPA',
  );


  final supabase = Supabase.instance.client;


  print("supabase $supabase");
  final SupabaseServiceDB supabaseServiceDB = SupabaseServiceDB(supabase);
  // try {
  //     final response = await supabase
  //         .from('Event_tbl')
  //         .select()
  //         .eq('EventId',6);

  //     // if (response.error != null) {
  //     //   throw response.error!;
  //     // }
  //     print("supabase $response");

  //     final data = response.data;
  //     print(data);
      
  //     // final EventDetails event = 
  //     //  await supabaseServiceDB.getAllEvents();
  //     // print('data ${event.claimedWalletAddress}');
  //   } catch (ex) {
  //     print('Error fetching data: $ex');
  //   }

    final EventDetails event = 
       await supabaseServiceDB.getAllEvents();
      print('data ${event.claimedWalletAddress}');

  // try {
  //    final response = await supabase
  //         .from('Event_tbl')
  //         .select()
  //         .eq('EventId', 7).single(); // Execute the query and retrieve a single row

  //     // if (response.error != null) {
  //     //   throw response.error!;
  //     // }

  //     final data = response.data;
  //     print(data);
  //   } catch (ex) {
  //     print(ex);
  //   }
  // }
  }
}
