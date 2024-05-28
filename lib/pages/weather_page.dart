import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../app/arch/bloc_provider.dart';
import '../bloc/weather_bloc.dart';
import '../loader_container/loader_container.dart';
import '../model/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}
class _WeatherPageState extends State<WeatherPage> {
  WeatherBloc? _bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = BlocProvider.of(context);
    _getCurrentPosition();
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _bloc!.setListener("${position.latitude},${position.longitude}");
    }).catchError((e) {
      debugPrint(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        title: Text('Weather Report'),
        centerTitle: true,),
      body: LoaderContainer(
        stream: _bloc!.isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<Location>(
                initialData: null,
                stream: _bloc!.locationData,
                builder: (c, s) {
                  return (s.data!=null)?Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(15)),

                          ),
                          child: Column(
                            children: [
                              Text(s.data!.name ?? '',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),),
                              SizedBox(height: 8,),
                              Text('${s.data!.region ?? ''} ,${s.data!.country ?? ''}',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400),),
                              SizedBox(height: 8,),
                              StreamBuilder<Current>(
                                stream: _bloc!.currentData,
                                initialData: null,
                                builder: (context, sc) {
                                  return (sc.data!=null)?Column(
                                    children: [
                                      Text("${sc.data!.tempC.toString() ?? ''} °C",style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.w600),),
                                      Row(
                                        children: [
                                          Image.network('https:${sc.data!.condition!.icon.toString()}',
                                            errorBuilder: (BuildContext context, Object exception, stackTrace) {

                                              return Text('😢');
                                            },),
                                          Text(sc.data!.condition!.text.toString() ?? '',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400),),
                                          Spacer(),
                                          Text(DateFormat("dd-MMM-yyyy").format(DateTime.parse(sc.data!.lastUpdated.toString())) ?? '',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400),),
                                        ],
                                      ),

                                    ],
                                  ):SizedBox();
                                }
                              ),


                            ],
                          ),

                        ),

                      ],
                    ),
                  ):SizedBox();
                }
              ),
              StreamBuilder<Forecast>(
                  initialData: null,
                  stream: _bloc!.forecastData,
                  builder: (b,fs){
                    return fs.data!=null&&fs.data!.forecastday!=null?
                    (fs.data!.forecastday![0].hour!=null)?ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),
                        itemCount: fs.data!.forecastday![0].hour!.length,
                        itemBuilder: (b,i){
                          DateTime dateTime = DateTime(2024, 1, 1, (i+1));
                          return Container(
                            padding: EdgeInsets.only(left: 14,right: 14),
                            margin: EdgeInsets.only(bottom: 14),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(DateFormat('h a').format(dateTime).toString(),style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600)),
                                Spacer(),
                                Text(fs.data!.forecastday![0].hour![i].condition!.text.toString() ?? '',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                                Spacer(),
                                Column(
                                  children: [
                                    Image.network('https:${fs.data!.forecastday![0].hour![i].condition!.icon.toString()}',
                                      errorBuilder: (BuildContext context, Object exception, stackTrace) {

                                        return Text('😢');
                                      },
                                      height: 45,width: 45,),
                                    Text(fs.data!.forecastday![0].hour![i].tempC.toString()+"°C",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400),),
                                      SizedBox(height: 5,)
                                  ],
                                ),

                              ],
                            ),
                          );
                        }):SizedBox():SizedBox();
                  })
            ],
          ),
        ),
      ),

    );
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
