import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocozados/_utils/color_theme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  bool isLoadingLocation = true;
  String locationErrorMessage = '';

  @override
  /* Metodo chamado quando o Widget esta sendo inicializado */
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /* Pega as coordenadas atuais */
  Future<void> _getCurrentLocation() async {
    /* Ativa tela de carregamento e zera mensagens de erro */
    setState(() {
      isLoadingLocation = true;
      locationErrorMessage = '';
    });

    /* Verifica se o serviço de localização do dispositivo esta ativado e o status da permissão */
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    /* Pede permissão para acessar a localização */
    if (!serviceEnabled || permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    /* Avisa que o acesso a localização foi negado permanentemente (usuario precisa ativar manualmente) */
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoadingLocation = false;
        locationErrorMessage = 'Permissão de Acesso a Localização Recusada.';
      });
      return;
    }

    /* Avisa que a localização esta desativada ou a permissão negada */
    if (!serviceEnabled || permission == LocationPermission.denied) {
      setState(() {
        isLoadingLocation = false;
        locationErrorMessage =
            'Permissão de localização negada ou serviço de localização desabilitado.';
      });
      return;
    }

    /* Obtem localização do usuario */
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 10));

      /* Se a localização for obtida, o estado da posição é atualizado */
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        isLoadingLocation = false;
      });

      /* Move a posição da camera do Maps para a posição do usuario */
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

  /* Move a posição da camera do Maps para a posição do usuario */
  void _goToCurrentLocation() {
    if (mapController != null && currentPosition != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(currentPosition!));
    }
  }

  /* Pega as cordenadas selecionadas e salva? */
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
            /* Google Maps */
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

          /* Barra inferior */
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

          /* Botão flutuante de voltar para localização atual */
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
        ],
      ),
    );
  }
}
