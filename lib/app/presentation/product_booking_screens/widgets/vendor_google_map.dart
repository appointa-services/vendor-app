import 'dart:ui' as ui;
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class Place with ClusterItem {
  final LatLng latLng;
  final int id;

  Place({required this.latLng, required this.id});

  @override
  LatLng get location => latLng;
}

class CompanyMap extends StatefulWidget {
  final LatLng latLng;

  const CompanyMap({super.key, required this.latLng});

  @override
  State<CompanyMap> createState() => CompanyMapState();
}

class CompanyMapState extends State<CompanyMap> {
  late ClusterManager _manager;
  Set<Marker> markers = {};

  @override
  void initState() {
    _manager = _initClusterManager();
    _manager.updateMap;
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
      [
        Place(
          latLng: widget.latLng,
          id: 1,
        ),
      ],
      _updateMarkers,
      markerBuilder: (Cluster<Place> places) => _markerBuilder(places),
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    debugPrint('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  bool multiple = false;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapToolbarEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      mapType: MapType.normal,
      // ignore: prefer_collection_literals
      gestureRecognizers: Set()
        ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
      initialCameraPosition: CameraPosition(target: widget.latLng, zoom: 15),
      markers: markers,
      onMapCreated: (GoogleMapController googleMapController) {
        _manager.setMapId(googleMapController.mapId);
      },
      onTap: (lat) {
        MapsLauncher.launchCoordinates(
            widget.latLng.latitude, widget.latLng.longitude, 'Salon is here');
      },
      onCameraMove: (position) {
        _manager.onCameraMove(position);
      },
      onCameraIdle: _manager.updateMap,
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Marker> _markerBuilder(Cluster<Place> place) async {
    final Uint8List markerIcon = await getBytesFromAsset(AppAssets.mapPin, 90);
    return Marker(
      markerId: MarkerId(place.getId()),
      position: place.location,
      icon: BitmapDescriptor.fromBytes(markerIcon),
    );
  }
}
