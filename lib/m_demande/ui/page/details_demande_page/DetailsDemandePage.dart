import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:odc_mobile_project/m_demande/ui/page/details_demande_page/DetailsDemandeCtrl.dart';
import 'package:odc_mobile_project/navigation/routers.dart';

class DetailsDemandePage extends ConsumerStatefulWidget {
  final int id;

  const DetailsDemandePage({super.key, required this.id});

  @override
  ConsumerState createState() => _DetailsDemandePageState();
}

class _DetailsDemandePageState extends ConsumerState<DetailsDemandePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var ctrl = ref.watch(detailsDemandeCtrlProvider.notifier);
      ctrl.recupererDemande(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(detailsDemandeCtrlProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Détails de la demande",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                var ctrl = ref.watch(detailsDemandeCtrlProvider.notifier);
                ctrl.recupererDemande(widget.id);
              },
              icon: Icon(
                Icons.refresh_sharp,
                size: 30,
              )),
        ],
        backgroundColor: Color(0xFFFF4500),
      ),
      body: Stack(
        children: [
          if (state.demande != null && !state.isLoading)
            _contenuPrincipale(context, ref),
          _chargement(context, ref)
        ],
      ),
    );
  }

  _contenuPrincipale(BuildContext context, WidgetRef ref) {
    var state = ref.watch(detailsDemandeCtrlProvider);
    var demande = state.demande;
    var dateDeplacement = demande?.dateDeplacement;
    var date = demande?.dateDemande;
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;

    print("demande ${demande?.motif}");

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Color(0xFFFF4500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/avatar.jpeg",
                      height: 150,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${demande?.initiateur!.nom} ${demande?.initiateur!.prenom}",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                        /*Text(
                          "${_jourEnLettre(date!.weekday)} ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        Text(
                          "${date!.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),*/
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      demande!.status == "1"
                          ? "Discuter avec le chauffeur"
                          : "En attente du début de la course",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chat,
                        color:
                            demande!.status == "1" ? Colors.black : Colors.grey,
                        size: 50,
                      ),
                      onPressed: demande!.status == "1" ? () {} : null,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.85,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(top: 35),
          decoration: BoxDecoration(
            border: Border.all(
              color: demande!.status != "1" ? Color(0xFFFFC107) : Colors.green,
              // Couleur de la bordure
              width: 3.0, // Épaisseur de la bordure
            ),
            borderRadius: BorderRadius.circular(8.0), // Rayon des coins
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${demande?.motif}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _getStatus("${demande?.status}"),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color(0x809E9E9E),
                  borderRadius: BorderRadius.circular(8.0), // Rayon des coins
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.car_repair, size: 35),
                    Text(
                      "${_jourEnLettre(dateDeplacement!.weekday)} ${dateDeplacement.day.toString().padLeft(2, '0')}-${dateDeplacement.month.toString().padLeft(2, '0')}-${dateDeplacement.year.toString().padLeft(4, '0')} à ${dateDeplacement.hour.toString().padLeft(2, '0')}:${dateDeplacement.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                          fontSize: 15.00, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${demande?.nbrePassagers} passagers",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _lieuInfo(demande?.lieuDepart, "Lieu de départ"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 20),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    _lieuInfo(demande?.destination, "Déstination"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: demande.status != '1' ? () {
                      var ctrl = ref.read(detailsDemandeCtrlProvider.notifier);
                      ctrl.annulerDemande(widget.id);
                      context.goNamed(Urls.listeDemandes.name);
                    } : null,
                    child: Text("Annuler"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          demande.status != '1' ? Colors.black : Colors.grey,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String _getDayOfWeek(DateTime date) {
    final formatter = DateFormat('EEEE');
    return formatter.format(date);
  }

  String _getStatus(String status) {
    switch (status.toLowerCase()) {
      case '0':
        return "En attente";
      case '1':
        return "Traitée";
      default:
        return 'En attente';
    }
  }

  String _jourEnLettre(int i) {
    var jours = [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche"
    ];

    return jours[i - 1];
  }

  _chargement(BuildContext context, WidgetRef ref) {
    var state = ref.watch(detailsDemandeCtrlProvider);

    return Visibility(
        visible: state.isLoading,
        child: Center(child: CircularProgressIndicator()));
  }

  _lieuInfo(lieu, label) {
    return Row(
      children: [
        Icon(Icons.location_on),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  "$lieu",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
                child: Text(
                  "$label",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
