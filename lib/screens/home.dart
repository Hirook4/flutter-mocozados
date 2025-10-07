import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocozados/_utils/color_theme.dart';
import 'package:mocozados/services/auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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

  /* Pega localização atual */
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
        locationErrorMessage = 'Permissão de Acesso à Localização Recusada.';
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 10));

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

  /* Centralizar mapa na localização atual */
  void _goToCurrentLocation() {
    if (mapController != null && currentPosition != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(currentPosition!));
    }
  }

  /* Stream de marcadores */
  Stream<Set<Marker>> getMarkersStream() {
    return FirebaseFirestore.instance.collection('locations').snapshots().map((
      snapshot,
    ) {
      print('Total de marcadores: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(data['lat'], data['lng']),
          infoWindow: InfoWindow(
            title: data['name'],
            snippet: data['description'],
          ),
        );
      }).toSet();
    });
  }

  /* Modal para salvar local */
  void _saveLocation(LatLng position) {
    print(
      'Coordenadas: Latitude: ${position.latitude} / Longitude: ${position.longitude}',
    );

    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome do Local'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text.trim();
                  String desc = descController.text.trim();
                  if (name.isEmpty || desc.isEmpty) return;

                  /* Salva no Firebase */
                  await FirebaseFirestore.instance.collection('locations').add({
                    'name': name,
                    'description': desc,
                    'lat': position.latitude,
                    'lng': position.longitude,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  Navigator.of(context).pop();

                  /* Move a tela para o ponto salvo */
                  mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(position, 16),
                  );
                },
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isLoadingLocation)
            const Center(child: CircularProgressIndicator())
          else if (locationErrorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  locationErrorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            )
          else
            /* StreamBuilder para atualizar as localizações salvas no mapa */
            StreamBuilder<Set<Marker>>(
              stream: getMarkersStream(),
              builder: (context, snapshot) {
                final markers = snapshot.data ?? <Marker>{};

                return GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: currentPosition ?? const LatLng(-23.5489, -46.6388),
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
                  onTap: _saveLocation,
                  markers: markers,
                );
              },
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 80.0),
              child: FloatingActionButton(
                onPressed: _goToCurrentLocation,
                backgroundColor: ColorTheme.primaryColor,
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                    icon: const Icon(Icons.list, size: 30, color: Colors.grey),
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
              padding: const EdgeInsets.only(top: 50.0, right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.red, size: 30),
                onPressed: () async {
                  await _authService.signOutUser();
                  await Future.delayed(const Duration(milliseconds: 100));
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
