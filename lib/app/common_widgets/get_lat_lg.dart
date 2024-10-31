import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

class PickLatLng extends StatefulWidget {
  final LatLng? latLng;
  const PickLatLng({super.key, this.latLng});

  @override
  State<PickLatLng> createState() => PickLatLngState();
}

class PickLatLngState extends State<PickLatLng> {
  String address = "";
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  ValueNotifier<bool> isPick = ValueNotifier<bool>(false);

  /// add marker
  void add(LatLng latLng) {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latLng.latitude, latLng.longitude),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  getUserLocation(LatLng _) async {
    Placemark placemarks = (await placemarkFromCoordinates(
      _.latitude,
      _.longitude,
    ))
        .first;
    setState(() {
      address = "${getVal(placemarks.name)}${getVal(placemarks.subLocality)}"
          "${getVal(placemarks.locality)}${getVal(placemarks.administrativeArea)}"
          "${getVal(placemarks.country, isLast: true)}";
    });
  }

  String getVal(String? value, {bool isLast = false}) {
    return value != null && value.isNotEmpty
        ? "$value${isLast ? "." : ","} "
        : "";
  }

  @override
  void initState() {
    add(widget.latLng ?? const LatLng(21.168200646644618, 72.82845061272383));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: false,
            zoomControlsEnabled: false,
            onTap: (_) {
              add(_);
              getUserLocation(_);
              setState(() => isPick.value = true);
            },
            initialCameraPosition: CameraPosition(
              target: widget.latLng ??
                  const LatLng(21.168200646644618, 72.82845061272383),
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isPick,
            builder: (context, value, child) {
              return AnimatedBuilder(
                animation: isPick,
                builder: (context, child) {
                  final offset =
                      value ? const Offset(0, 0) : const Offset(0, 150);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform:
                        Matrix4.translationValues(offset.dx, offset.dy, 0),
                    child: child,
                  );
                },
                child: IntrinsicHeight(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          S16Text(
                            address,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w700,
                          ),
                          10.vertical(),
                          Row(
                            children: [
                              Expanded(
                                child: CommonBtn(
                                  text: "Cancel",
                                  isBoxShadow: false,
                                  btnColor: AppColor.grey40,
                                  textColor: AppColor.primaryColor,
                                  onTap: () =>
                                      setState(() => isPick.value = false),
                                ),
                              ),
                              15.horizontal(),
                              Expanded(
                                child: CommonBtn(
                                  text: "Choose Location",
                                  isBoxShadow: false,
                                  onTap: () => Get.back(
                                    result: (
                                      markers[const MarkerId("1")]?.position,
                                      address,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
