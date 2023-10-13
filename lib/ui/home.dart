import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
        centerTitle: true,
        backgroundColor: Colors.green ,
      ),
    );

  }
}
Location location = Location();
PermissionStatus? permissionStatus;
LocationData? locationData;
bool serviceEnabled=false;
StreamSubscription<LocationData>? subscription;

Future<bool> isPermissionGranted()async{
  permissionStatus = await location.hasPermission();
  if(permissionStatus==PermissionStatus.denied){
    permissionStatus = await location.requestPermission();
    return permissionStatus==PermissionStatus.granted;
  }
  return permissionStatus==PermissionStatus.granted;
}

Future<bool> isServiceEnabled()async{
  serviceEnabled = await location.serviceEnabled();
  if(!serviceEnabled){
    serviceEnabled = await location.requestService();
  }
  return serviceEnabled;
}

 void getCurrentLocation()async{
  bool permission = await isPermissionGranted();
  if(!permission) return;
  bool service = await isServiceEnabled();
  if(!service) return;

  locationData = await location.getLocation();
  subscription = location.onLocationChanged.listen((event) {
    locationData=event;
    print("lat : ${locationData!.latitude} , long : ${locationData!.longitude}");
  });
  location.changeSettings(accuracy: LocationAccuracy.low);
 }
