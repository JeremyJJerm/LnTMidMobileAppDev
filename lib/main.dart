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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Fitness Summary'),
        ),
      ),
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
            DateTime today = DateTime.now();
          String formattedToday = DateFormat('EEEE, dd-MMMM-yyyy').format(today);

          var todayStepsData = provider.stepsData.firstWhere(
            (entry) => DateFormat('EEEE, dd-MMMM-yyyy').format(entry['date']) == formattedToday,
            orElse: () => {'date': today, 'steps': 0},
          );

          var todayWaterData = provider.waterData.firstWhere(
            (entry) => DateFormat('EEEE, dd-MMMM-yyyy').format(entry['date']) == formattedToday,
            orElse: () => {'date': today, 'water': 0.0},
          );
            
        int totalSteps = provider.stepsData.fold(0, (sum, entry) => sum + (entry['steps'] as int));
        double totalWater = provider.waterData.fold(0.0, (sum, entry) => sum + (entry['water'] as double));
          
return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    formattedToday,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Title(
                                            color: Colors.black,
                                            child: Text(
                                              "Today's Steps",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[700],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: provider.stepsData.isNotEmpty
                                                ? Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          '${todayStepsData['steps']} Steps',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.teal[800],
                                                          ),
                                                        ),
                                                        if (todayStepsData['steps'] < 4000)
                                                          Text(
                                                            "Bad",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.red[300],
                                                            ),
                                                          )
                                                        else if (todayStepsData['steps'] >= 4000 && todayStepsData['steps'] <= 8000)
                                                          Text(
                                                            "Average",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.yellow[600],
                                                            ),
                                                          )
                                                        else
                                                          Text(
                                                            "Good",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.green[600],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                : Center(
                                                    child: Text(
                                                      "None",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Title(
                                            color: Colors.black,
                                            child: Text(
                                              "Today's Litre of Water",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color : Colors.blueGrey[700],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: provider.waterData.isNotEmpty
                                                ? Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          '${todayWaterData['water']} Litre',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.teal[800],
                                                          ),
                                                        ),
                                                        if (todayWaterData['water'] < 1.5)
                                                          Text(
                                                            "Bad",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.red[300],
                                                            ),
                                                          )
                                                        else if (todayWaterData['water'] >= 1.5 && todayWaterData['water'] <= 2)
                                                          Text(
                                                            "Average",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.yellow[600],
                                                            ),
                                                          )
                                                        else
                                                          Text(
                                                            "Good",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.green[600],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                : Center(
                                                    child: Text(
                                                      "None",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Title(
                                            color: Colors.black,
                                            child: Text(
                                              "Total Steps",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[700],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '$totalSteps Steps',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.teal[800],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Title(
                                            color: Colors.black,
                                            child: Text(
                                              "Total Water Intake",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[700],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '$totalWater Liters',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.teal[800],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  final FocusNode stepsFocusNode = FocusNode();

  @override
  void dispose() {
    stepsFocusNode.dispose();
    super.dispose();
  }


  void sortDescList(){
    stepsList.sort((a, b) {
      DateTime dateA = DateFormat('EEEE, dd-MMMM-yyyy').parse(a['date']!);
      DateTime dateB = DateFormat('EEEE, dd-MMMM-yyyy').parse(b['date']!);
      return dateB.compareTo(dateA);
    });
  }

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
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
            child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Steps",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  Consumer<FitnessProvider>(
                    builder: (context, provider, child) {
                      int totalSteps = provider.stepsData.fold(0, (sum, entry) => sum + (entry['steps'] as int));
                      return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$totalSteps Steps',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal[800],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (totalSteps < 4000)
                        Text(
                          "Bad",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.red[300],
                          ),
                        )
                      else if (totalSteps >= 4000 && totalSteps <= 8000)
                        Text(
                          "Average",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.yellow[600],
                          ),
                        )
                      else
                        Text(
                          "Good",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.green[600],
                          )
                  ),
                ],
              );
                    }
            ),
                ]
          ),
        ),
            ),
            ),
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
                          String formattedDate = DateFormat('EEEE, dd-MMMM-yyyy').format(selectedDate);
                          
                            bool dateExists = stepsList.any((entry) => entry['date'] == formattedDate);if(dateExists){
                            setState(() {
                              int index = stepsList.indexWhere((entry) => entry['date'] == formattedDate);
                              stepsList[index] = {'date' : formattedDate, 'steps': steps.toString()};
                            });                          
                            DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(formattedDate);
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
                      controller: stepsController,
                      focusNode: stepsFocusNode, 
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
                  String formattedDate = DateFormat('EEEE, dd-MMMM-yyyy').format(
                  DateFormat('dd-MMMM-yyyy').parse(dateController.text),
                );

                  
                  bool dateExists = stepsList.any((entry) => entry['date'] == formattedDate);
                  
                  if (dateExists) {
                    setState(() {
                      int index = stepsList.indexWhere((entry) => entry['date'] == formattedDate);
                      stepsList[index] = {'date': formattedDate, 'steps': steps.toString()};
                    });
                    DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(formattedDate);
                    Provider.of<FitnessProvider>(context, listen: false).updateSteps(steps, selectedDate);
                  } else {
                    setState(() {
                      stepsList.add({'date': formattedDate, 'steps': steps.toString()});
                    });
                  }
                  
                  sortDescList();

                  DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(formattedDate);
                  Provider.of<FitnessProvider>(context, listen: false).addSteps(steps, selectedDate);

                  
                }

                dateController.clear();
                stepsController.clear();
              },
              child: const Text('Add Steps'),
            ),
            const SizedBox(height: 10),
            
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: stepsList.length,
              itemBuilder: (context, index) {
                int steps = int.tryParse(stepsList[index]['steps'] ?? '0') ?? 0;
                String status = _getStepsStatus(steps);

                return ListTile(
                  title: Text('Date: ${stepsList[index]['date']}'),
                  subtitle: Row(
                    children: [
                    Text('Steps: ${stepsList[index]['steps']}'),
                    const SizedBox(width: 10),
                    Text(
                      status,
                        style: TextStyle(
                          color: _getStatusColor(steps),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                           setState(() {
                            dateController.text = DateFormat('dd-MMMM-yyyy').format(
                              DateFormat('EEEE, dd-MMMM-yyyy').parse(stepsList[index]['date']!),
                            );
                            stepsController.text = stepsList[index]['steps']!;
                          });
                          FocusScope.of(context).requestFocus(stepsFocusNode);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            String date = stepsList[index]['date'] ?? '';
                            int steps = int.tryParse(stepsList[index]['steps'] ?? '0') ?? 0;
                            stepsList.removeAt(index);
                            DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(date);
                            Provider.of<FitnessProvider>(context, listen: false).deleteSteps(selectedDate, steps);
                          });
                        }
                      )
                    ]
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

  String _getStepsStatus(int steps) {
    if (steps < 4000) {
      return "Bad";
    } else if (steps >= 4000 && steps <= 8000) {
      return "Average";
    } else {
      return "Good";
    }
  }

  // Helper method to get the steps status color
  Color _getStatusColor(int steps) {
    if (steps < 4000) {
      return Colors.red;
    } else if (steps >= 4000 && steps <= 8000) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
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

  final FocusNode waterFocusNode = FocusNode();

  @override
  void dispose() {
    waterFocusNode.dispose();
    super.dispose();
  }
    void sortDescList(){
    waterList.sort((a, b) {
      DateTime dateA = DateFormat('EEEE, dd-MMMM-yyyy').parse(a['date']!);
      DateTime dateB = DateFormat('EEEE, dd-MMMM-yyyy').parse(b['date']!);
      return dateB.compareTo(dateA);
    });
  }

   @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake Tracker')
      ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
            child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Water Intake",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  Consumer<FitnessProvider>(
                    builder: (context, provider, child) {
                      double totalWater = provider.waterData.fold(0.0, (sum, entry) => sum + (entry['water'] as double));
                      return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$totalWater Liters',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal[800],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (totalWater < 1.5)
                        Text(
                          "Bad",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.red[300],
                          ),
                        )
                      else if (totalWater >= 1.5 && totalWater <= 2)
                        Text(
                          "Average",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.yellow[600],
                          ),
                        )
                      else
                        Text(
                          "Good",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                  );
                    }
                ),
                ]
              ),
            ),
            ),
          ),
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
                          String formattedDate = DateFormat('EEEE, dd-MMMM-yyyy').format(selectedDate);
                          
                            bool dateExists = waterList.any((entry) => entry['date'] == formattedDate);if(dateExists){
                            setState(() {
                              int index = waterList.indexWhere((entry) => entry['date'] == formattedDate);
                              waterList[index] = {'date' : formattedDate, 'water': water.toString()};
                            });
                            
                          DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(formattedDate);
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
                      controller: waterController,
                      focusNode: waterFocusNode, 
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Litre",
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
                  String formattedDate = DateFormat('EEEE, dd-MMMM-yyyy').format(
                  DateFormat('dd-MMMM-yyyy').parse(dateController.text),
                  );
                  
                  bool dateExists = waterList.any((entry) => entry['date'] == formattedDate);
                  
                  if (dateExists) {
                    setState(() {
                      int index = waterList.indexWhere((entry) => entry['date'] == formattedDate);
                      waterList[index] = {'date': formattedDate, 'water': water.toString()};
                    });    
                    DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(formattedDate);
                    Provider.of<FitnessProvider>(context, listen: false).updateWater(water, selectedDate);
                  } else {
                
                    setState(() {
                      waterList.add({'date': formattedDate, 'water': water.toString()});
                    });
                    
                  }

                  sortDescList();

                  DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(formattedDate);
                  Provider.of<FitnessProvider>(context, listen: false).addWater(water, selectedDate);

                }
                dateController.clear();
                waterController.clear();
              },
              child: const Text('Add water'),
            ),
            const SizedBox(height: 10),
            
          Expanded(
            child: ListView.builder(
              itemCount: waterList.length,
              itemBuilder: (context, index) {
                double water = double.tryParse(waterList[index]['water'] ?? '0') ?? 0;
                String status = _getWaterStatus(water);

                return ListTile(
                  title: Text('Date: ${waterList[index]['date']}'),
                  subtitle: Row(
                    children: [
                    Text('Water: ${waterList[index]['water']} L'),
                    const SizedBox(width: 10),
                    Text(
                      status,
                        style: TextStyle(
                          color: _getStatusColor(water),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                           setState(() {
                            dateController.text = DateFormat('dd-MMMM-yyyy').format(
                              DateFormat('EEEE, dd-MMMM-yyyy').parse(waterList[index]['date']!),
                            );
                            waterController.text = waterList[index]['water']!;
                          });
                          FocusScope.of(context).requestFocus(waterFocusNode);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            String date = waterList[index]['date'] ?? '';
                            double water = double.tryParse(waterList[index]['water'] ?? '0') ?? 0;
                            waterList.removeAt(index);
                            DateTime selectedDate = DateFormat('EEEE, dd-MMMM-yyyy').parse(date);
                            Provider.of<FitnessProvider>(context, listen: false).deleteWater(selectedDate, water);
                          });
                        }
                      )
                    ]
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

  String _getWaterStatus(double water) {
    if (water < 2.0) {
      return "Bad";
    } else if (water >= 2.0 && water <= 3.0) {
      return "Average";
    } else {
      return "Good";
    }
  }

  // Helper method to get the water status color
  Color _getStatusColor(double water) {
    if (water < 2.0) {
      return Colors.red;
    } else if (water >= 2.0 && water <= 3.0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
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
