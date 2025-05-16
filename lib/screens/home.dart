import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocozados/_utils/color_theme.dart';
import 'package:mocozados/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  bool isLoadingLocation = true;
  String locationErrorMessage = '';
  final Auth _authService = Auth();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
      locationErrorMessage = '';
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoadingLocation = false;
        locationErrorMessage = 'Permissão de Acesso a Localização Recusada.';
      });
      return;
    }

    if (!serviceEnabled || permission == LocationPermission.denied) {
      setState(() {
        isLoadingLocation = false;
        locationErrorMessage =
            'Permissão de localização negada ou serviço de localização desabilitado.';
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 10));

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        isLoadingLocation = false;
      });

      if (mapController != null && currentPosition != null) {
        _goToCurrentLocation();
      }
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
        locationErrorMessage = 'Erro ao obter a localização. Tente novamente.';
      });
    }
  }

  void _goToCurrentLocation() {
    if (mapController != null && currentPosition != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(currentPosition!));
    }
  }

  void _getCoordinates(LatLng position) {
    print(
      'Coordenadas: Latitude: ${position.latitude} / Longitude: ${position.longitude}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isLoadingLocation)
            Center(child: CircularProgressIndicator())
          else if (locationErrorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  locationErrorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            )
          else
            GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: currentPosition ?? LatLng(-23.5489, -46.6388),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                if (currentPosition != null) {
                  mapController!.animateCamera(
                    CameraUpdate.newLatLng(currentPosition!),
                  );
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: _getCoordinates,
            ),

          // Botão para centralizar localização
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 80.0),
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                backgroundColor: ColorTheme.primaryColor,
                child: Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ),

          // Barra inferior com ícones
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: ColorTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.location_on,
                      size: 30,
                      color: ColorTheme.tertiaryColor,
                    ),
                    onPressed: _goToCurrentLocation,
                  ),
                  IconButton(
                    icon: Icon(Icons.list, size: 30, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          /* Botão Logout */
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 16.0),
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.red, size: 30),
                onPressed: () async {
                  /* Desloga no firebase e volta para a primeira tela */
                  await _authService.signOutUser();
                  await Future.delayed(Duration(milliseconds: 100));
                  if (!mounted) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
