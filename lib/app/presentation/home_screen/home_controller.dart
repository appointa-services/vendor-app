import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:salon_user/app/utils/all_dependency.dart';
import 'package:salon_user/backend/get_home_data.dart';
import 'package:salon_user/data_models/user_model.dart';
import 'dart:ui' as ui;

import '../../../data_models/vendor_data_models.dart';
import '../../helper/shared_pref.dart';
import '../../utils/loading.dart';

class HomeController extends GetxController {
  UserModel? user;
  RxInt currentServiceImg = 0.obs;
  RxString selectedCat = "".obs;
  RxList<String> selectedCatList = <String>[].obs;
  RxList<UserModel> vendorList = <UserModel>[].obs;
  RxList<UserModel> filterVendorList = <UserModel>[].obs;
  RxList<UserModel> searchVendorList = <UserModel>[].obs;
  RxBool isBusinessLoad = false.obs;
  int? selectedIndex;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxBool isCatLoader = false.obs;

  Future<void> getCategoryData() async {
    isCatLoader.value = true;
    update();
    categoryList.value = await GetHomeData.getCategoryData();
    isCatLoader.value = false;
    update();
  }

  List getCatNameList(List cateIdList) {
    List nameList = [];
    if (categoryList.isNotEmpty &&
        categoryList.any((element) => cateIdList.contains(element.catId))) {
      for (var element in cateIdList) {
        List<CategoryModel> list =
            categoryList.where((e) => e.catId == element).toList();
        if (list.isNotEmpty) {
          nameList.add(list.first.catName);
        }
      }
    }
    return nameList;
  }

  Future<void> getVendorList({LatLng? newLat}) async {
    vendorList.clear();
    filterVendorList.clear();
    isBusinessLoad.value = true;
    update();
    if (newLat != null) {
      lat = newLat.latitude;
      lng = newLat.longitude;
      await GetHomeData.getVendorList(newLat).then(
        (value) {
          if (value != null) {
            vendorList.addAll(value);
            filterVendorList.addAll(value);
          } else {
            showSnackBar("Unable to get your vendor");
          }
        },
      );
    } else {
      await determinePosition().then(
        (latLng) async {
          lat = latLng.latitude;
          lng = latLng.longitude;
          await GetHomeData.getVendorList(latLng).then(
            (value) {
              if (value != null) {
                vendorList.addAll(value);
                filterVendorList.addAll(value);
              } else {
                showSnackBar("Unable to get your vendor");
              }
            },
          );
        },
      );
    }
    await markerConvert();
    isBusinessLoad.value = false;
    update();
  }

  Future<void> logout() async {
    Loader.show();
    await Pref.clearAlData().then(
      (value) {
        Loader.dismiss();
        Get.offAllNamed(AppRoutes.loginScreen);
      },
    );
  }

  void filterVendorByCat(String id) {
    bool isSelected = selectedCatList.contains(id);
    filterVendorList.clear();
    if (isSelected) {
      if (id == "all") {
        selectedCatList.clear();
      } else {
        selectedCatList.remove(id);
      }
    } else {
      if (id == "all") {
        selectedCatList.clear();
        List.generate(
          categoryList.length,
          (index) => selectedCatList.add(categoryList[index].catId),
        );
        selectedCatList.add(id);
      } else {
        selectedCatList.add(id);
        if (selectedCatList.length == categoryList.length) {
          selectedCatList.add(id);
        }
      }
    }

    if (selectedCatList.isNotEmpty) {
      for (int i = 0;
          i <
              (selectedCatList.length > categoryList.length
                  ? selectedCatList.length - 1
                  : selectedCatList.length);
          i++) {
        for (UserModel data in vendorList) {
          if (data.businessData?.selectedCat.any(
                (element) {
                  return element == selectedCatList[i];
                },
              ) ??
              false) {
            if (!filterVendorList.any((element) => element.id == data.id)) {
              filterVendorList.add(data);
            }
          }
        }
      }
    } else {
      for (var element in vendorList) {
        filterVendorList.add(element);
      }
    }

    addMarker();
    update();
  }

  /// location screen variables
  FocusNode focusNode = FocusNode();
  RxString search = "".obs;
  RxDouble latitude = lat.obs;
  RxDouble longitude = lng.obs;
  TextEditingController searchController = TextEditingController();
  Rx<GoogleMapController?> controller = Rx(null);
  Rx<bool> isLoad = Rx(false);
  RxList<String> locationSelectedCat = <String>[].obs;
  Rx<List<Marker>> markers = Rx([]);
  Rx<Uint8List?> mainIc = Rx(null);
  Rx<Uint8List?> locationIc = Rx(null);
  CarouselSliderController carouselController = CarouselSliderController();

  Rx<CameraPosition> kGooglePlex = Rx(
    CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12,
    ),
  );

  Future<void> markerConvert() async {
    mainIc.value = await getBytesFromAsset("assets/pin.png", 70);
    locationIc.value = await getBytesFromAsset("assets/mylocation.png", 60);
    update();
    addMarker();
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

  Future<void> addMarker({int? index}) async {
    markers.value.clear();
    update();
    markers.value.add(
      Marker(
        markerId: const MarkerId("my location"),
        position: LatLng(lat, lng),
        icon: locationIc.value == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.fromBytes(locationIc.value!),
      ),
    );
    for (int i = 0; i < filterVendorList.length; i++) {
      BusinessModel? data = filterVendorList[i].businessData;
      markers.value.add(
        Marker(
          markerId: MarkerId(filterVendorList[i].id ?? ""),
          position: LatLng(
            data?.latitude ?? lat,
            data?.longitude ?? lng,
          ),
          onTap: () {
            carouselController.animateToPage(i);
            update();
          },
          icon: mainIc.value == null
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.fromBytes(mainIc.value!),
        ),
      );
    }
    update();
  }

  void moveCamera(LatLng latLng, int index) {
    controller.value?.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
    addMarker(index: index);
    update();
  }

  Future<LatLng> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    LatLng latLng = LatLng(lat, lng);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Geolocator.lo
      // return latLng;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return latLng;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return latLng;
    }

    return LatLng(
      (await Geolocator.getCurrentPosition()).latitude,
      (await Geolocator.getCurrentPosition()).longitude,
    );
  }

  Future<void> getCurrentLoc() async {
    determinePosition().then(
      (value) {
        controller.value?.moveCamera(
          CameraUpdate.newLatLng(value),
        );
        if ((lat - value.latitude).abs() >= 0.01 &&
            (lng - value.longitude).abs() >= 0.01) {
          getVendorList(newLat: value);
        }
      },
    );
  }

  void searchVendor(String search) {
    searchVendorList.clear();
    List<UserModel> businessList = [];
    List<UserModel> dummySearchList = [];
    for (UserModel data in vendorList) {
      businessList.add(data);
    }
    update();
    if (search.length > 2) {
      for (UserModel data in businessList) {
        BusinessModel? businessModel = data.businessData;
        if (businessModel != null) {
          if (businessModel.businessName
              .toLowerCase()
              .contains(search.toLowerCase())) {
            if (!dummySearchList.any((element) => element.id == data.id)) {
              dummySearchList.add(data);
            }
          }
          if (businessModel.businessAddress
              .toLowerCase()
              .contains(search.toLowerCase())) {
            if (!dummySearchList.any((element) => element.id == data.id)) {
              dummySearchList.add(data);
            }
          }
          if (businessModel.serviceNameList.any(
            (e) => (e as String).toLowerCase().contains(search.toLowerCase()),
          )) {
            if (!dummySearchList.any((element) => element.id == data.id)) {
              dummySearchList.add(data);
            }
          }
        }
      }
    }
    searchVendorList.addAll(dummySearchList);
    update();
  }

  Future<String?> addRemoveFav(int index) async {
    String? key;
    vendorList[index].isLoad.value = true;
    update();
    List<FavouriteModel> list =
        vendorList[index].businessData?.favouriteList ?? [];
    int favIndex = list.indexWhere((element) => element.id == user?.id);
    await GetHomeData.addFavouriteStore(
      userId: user?.id ?? "",
      vendorId: vendorList[index].id ?? "",
      key: favIndex == -1 ? null : list[favIndex].key,
    ).then(
      (value) {
        if (value.$1) {
          if (value.$2 != null) {
            key = value.$2;
            list.add(
              FavouriteModel(
                id: user?.id ?? "",
                key: value.$2 ?? "",
              ),
            );
          } else {
            list.removeAt(favIndex);
          }
        } else {
          showSnackBar(
            "Unable to ${favIndex == -1 ? "add" : "remove"} store in favourite",
          );
        }
      },
    );
    vendorList[index].isLoad.value = false;
    update();
    return key;
  }

  @override
  void onInit() async {
    String userData = await Pref.getString(Pref.userData);
    user = UserModel.fromMap(jsonDecode(userData));
    getVendorList();
    getCategoryData();
    super.onInit();
  }
}
