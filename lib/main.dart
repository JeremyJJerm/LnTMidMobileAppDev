import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create:(context) => FitnessProvider(),
      child: MyApp(),
    )      
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class FitnessProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> stepsData = [];
  final List<Map<String, dynamic>> waterData = [];

  void addSteps(int steps, DateTime date) {
    stepsData.add({'date': date, 'steps': steps});
    notifyListeners();
  }

  void updateSteps(int steps, DateTime date) {
    int index = stepsData.indexWhere((entry) => entry['date'] == date);
    if (index != -1) {
      stepsData[index] = {'date': date, 'steps': steps};
      notifyListeners();
    }
  }

  void updateWater(double water, DateTime date) {
    int index = waterData.indexWhere((entry) => entry['date'] == date);
    if (index != -1) {
      waterData[index] = {'date': date, 'water': water};
      notifyListeners();
    }
  }

  void addWater(double water, DateTime date) {
    waterData.add({'date': date, 'water': water});
    notifyListeners();
  }

  void deleteSteps(DateTime date, int steps) {
    stepsData.removeWhere((entry) => entry['date'] == date && entry['steps'] == steps);
    notifyListeners();
  }

  void deleteWater(DateTime date, double water) {
    waterData.removeWhere((entry) => entry['date'] == date && entry['steps'] == water);
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // final String title = "Fitness Statisitcs";

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selected = 0;
  static final List<Widget> pages = <Widget>[
    StatsScreen(),
    StepsScreen(),
    WaterScreen(),
  ];

  void itemSelect(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: IndexedStack(
        index: _selected,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label:'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_walk_sharp), label: "Steps"),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink_rounded), label: "Water"),
        ],
      currentIndex: _selected,
      onTap: (index){
          setState(() {
            _selected = index;
          });
        }
      ),
    );
  }
}

class StatsScreen extends StatelessWidget{
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context){
    // final provider = Provider.of<FitnessProvider>(context);
    return Scaffold(
       appBar: AppBar(
          title: const Center(
            child: Text('Fitness Summary'),
          ),
        ),
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child){
            if (provider.stepsData.isNotEmpty) {
              var latestData = provider.stepsData.last;
              DateTime date = latestData['date'] is String
              ? DateTime.parse(latestData['date']) // Parse if it's a string
              : latestData['date']; // Already DateTime
              DateTime latestDate = latestData['date'];
              int latestSteps = latestData['steps'];
              String formattedDate = DateFormat('yyyy-MM-dd').format(latestData['date']);
              int latestWater = latestData['water']; 
            
        return Padding( 
          padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
              const SizedBox(
                height: 20
              ),

              Expanded(
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Title(color: Colors.black, 
                            child: Text("Latest Steps",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[700], 
                              )
                            )
                          ),

                          Expanded(
                            child: provider.stepsData.isNotEmpty
                              ? Center(
                                  child: Column( 
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(
                                      '$latestSteps Steps',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.teal[800],
                                      ),
                                    ),
                                if(provider.stepsData.last['steps'] < 4000)
                                Text("bad",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red[300],
                                  ),
                                )
                                else if(provider.stepsData.last['steps'] >= 4000 && provider.stepsData.last['steps'] <=8000)
                                  Text("Average",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.yellow[600]
                                  ),
                                )
                                else
                                  Text("Good",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[600]
                                  ),
                                )    
                              ],
                            )
                          )
                        : Center(
                            child: Text(
                            "No Data",
                            style: TextStyle(
                              fontSize: 20,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                          )
                        ],
                      )
                    )
                  )
                )
              ),
              Expanded(
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Title(color: Colors.black, 
                            child: Text("Latest Liter of Water",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[700], 
                              )
                            )
                          ),

                          Expanded(
                            child: provider.waterData.isNotEmpty
                              ? Center(
                                  child: Column( 
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(
                                      '$latestWater Litre',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.teal[800],
                                      ),
                                    ),
                                if(provider.waterData.last['water'] < 4000)
                                Text("bad",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red[300],
                                  ),
                                )
                                else if(provider.waterData.last['water'] >= 4000 && provider.waterData.last['water'] <=8000)
                                  Text("Average",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.yellow[600]
                                  ),
                                )
                                else
                                  Text("Good",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green[600]
                                  ),
                                )    
                              ],
                            )
                          )
                        : Center(
                            child: Text(
                            "No Data",
                            style: TextStyle(
                              fontSize: 20,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                          )
                        ],
                      )
                    )
                  )
                )
              ),
              ]
            ) ,
          ),
        );
        } 
        else{
          return Center(
                child: CircularProgressIndicator() 
              );
          }
        }
      )
    );
  }
}

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  StepsScreenState createState() => StepsScreenState();
}

class StepsScreenState extends State<StepsScreen> {
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<Map<String, String>> stepsList = [];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Tracker')
      ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        hintText: 'Select Date',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                      readOnly: true,
                      onTap: () {
                        selectDate(context);
                         if (dateController.text.isNotEmpty && stepsController.text.isNotEmpty) {
                          int steps = int.tryParse(stepsController.text) ?? 0;
                          DateTime selectedDate = DateTime.parse(dateController.text);
                          String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                          
                            bool dateExists = stepsList.any((entry) => entry['date'] == formattedDate);if(dateExists){
                            setState(() {
                              int index = stepsList.indexWhere((entry) => entry['date'] == formattedDate);
                              stepsList[index] = {'date' : formattedDate, 'steps': steps.toString()};
                            });                          
                            DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(formattedDate);
                            Provider.of<FitnessProvider>(context, listen: false).updateSteps(steps, selectedDate); 
                          } else{
                              setState((){
                              stepsList.add({'date': formattedDate, 'steps': steps.toString()});
                              });
                            }
                         Provider.of<FitnessProvider>(context, listen: false).addSteps(steps, selectedDate);
                        }                          
                      }
                   ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                   child: TextField(
                      controller:stepsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Steps",
                        filled: true,
                       enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      )
                    )
                  )
                ],
              )
            ),
            const SizedBox(
              height: 10
            ),
            ElevatedButton(
              onPressed: () {
                if (dateController.text.isNotEmpty && stepsController.text.isNotEmpty) {
                  int steps = int.tryParse(stepsController.text) ?? 0;
                  String formattedDate = dateController.text;
                  
                  bool dateExists = stepsList.any((entry) => entry['date'] == formattedDate);
                  
                  if (dateExists) {
                    setState(() {
                      int index = stepsList.indexWhere((entry) => entry['date'] == formattedDate);
                      stepsList[index] = {'date': formattedDate, 'steps': steps.toString()};
                    });
                    DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(formattedDate);
                    Provider.of<FitnessProvider>(context, listen: false).updateSteps(steps, selectedDate);
                  } else {
                    setState(() {
                      stepsList.add({'date': formattedDate, 'steps': steps.toString()});
                    });
                    DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(formattedDate);
                    Provider.of<FitnessProvider>(context, listen: false).addSteps(steps, selectedDate);
                  }
                }
                // Clear the controllers after adding
                dateController.clear();
                stepsController.clear();
              },
              child: const Text('Add Steps'),
            ),
            const SizedBox(
              height: 20
            ),
            Expanded(
              child: ListView.builder(
                itemCount: stepsList.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text('Date: ${stepsList[index]['date']}'),
                    subtitle: Text('Steps: ${stepsList[index]['steps']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: (){
                        setState(() {
                          String date = stepsList[index]['date'] ?? '';
                          int steps = int.tryParse(stepsList[index]['steps'] ?? '0') ?? 0;
                          stepsList.removeAt(index);                         
                          DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(date); 
                          Provider.of<FitnessProvider>(context, listen: false).deleteSteps(selectedDate, steps);
                        });
                      }
                    )
                  );
                }
              )  
            )
          ],
        )
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );
    
    if(picked != null){
      setState(() {
        dateController.text = DateFormat('dd-MMMM-yyyy').format(picked);
      });
    }
  }
}

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  WaterScreenState createState() => WaterScreenState();
}

class WaterScreenState extends State<WaterScreen> {
  final TextEditingController waterController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<Map<String, String>> waterList = [];

   @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Tracker')
      ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        hintText: 'Select Date',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue)),
                      ),
                      readOnly: true,
                      onTap: () {
                        selectDate(context);
                         if (dateController.text.isNotEmpty && waterController.text.isNotEmpty) {
                          double water = double.tryParse(waterController.text) ?? 0;
                          DateTime selectedDate = DateTime.parse(dateController.text);
                          String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                          
                            bool dateExists = waterList.any((entry) => entry['date'] == formattedDate);if(dateExists){
                            setState(() {
                              int index = waterList.indexWhere((entry) => entry['date'] == formattedDate);
                              waterList[index] = {'date' : formattedDate, 'water': water.toString()};
                            });
                            
                          DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(formattedDate);
                            Provider.of<FitnessProvider>(context, listen: false).updateWater(water, selectedDate); 
                          } else{
                              setState((){
                              waterList.add({'date': formattedDate, 'water': water.toString()});
                              });
                            }
                         Provider.of<FitnessProvider>(context, listen: false).addWater(water, selectedDate);
                        }                          
                      }
                   ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                   child: TextField(
                      controller:waterController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter water",
                        filled: true,
                       enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      )
                    )
                  )
                ],
              )
            ),
            const SizedBox(
              height: 10
            ),
            ElevatedButton(
              onPressed: () {
                if (dateController.text.isNotEmpty && waterController.text.isNotEmpty) {
                  double water = double.tryParse(waterController.text) ?? 0;
                  String formattedDate = dateController.text;
                  
                  bool dateExists = waterList.any((entry) => entry['date'] == formattedDate);
                  
                  if (dateExists) {
                    setState(() {
                      int index = waterList.indexWhere((entry) => entry['date'] == formattedDate);
                      waterList[index] = {'date': formattedDate, 'water': water.toString()};
                    });    
                    DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(formattedDate);
                    Provider.of<FitnessProvider>(context, listen: false).updateWater(water, selectedDate);
                  } else {
                
                    setState(() {
                      waterList.add({'date': formattedDate, 'water': water.toString()});
                    });
                    
                    DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(formattedDate);
                    Provider.of<FitnessProvider>(context, listen: false).addWater(water, selectedDate);
                  }
                }
                // Clear the controllers after adding
                dateController.clear();
                waterController.clear();
              },
              child: const Text('Add water'),
            ),
            const SizedBox(
              height: 20
            ),
            Expanded(
              child: ListView.builder(
                itemCount: waterList.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text('Date: ${waterList[index]['date']}'),
                    subtitle: Text('water: ${waterList[index]['water']} L'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: (){
                        setState(() {
                          String date = waterList[index]['date'] ?? '';
                          double water = double.tryParse(waterList[index]['water'] ?? '0') ?? 0;
                          waterList.removeAt(index);
                          DateTime selectedDate = DateFormat('dd-MMMM-yyyy').parse(date);
                          Provider.of<FitnessProvider>(context, listen: false).deleteWater(selectedDate, water);
                        });
                      }
                    )
                  );
                }
              )  
            )
          ],
        )
      ),
    );
  }

   Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );
    
    if(picked != null){
      setState(() {
        dateController.text = DateFormat('dd-MMMM-yyyy').format(picked);
      });
    }
  }
}
