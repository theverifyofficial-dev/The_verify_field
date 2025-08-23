import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double currentProgress = 50; // Current value
  double target = 100;       // Target value

  @override
  Widget build(BuildContext context) {
    double progressPercentage = currentProgress / target;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Target Progress Bar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Progress: ${currentProgress.toInt()} / ${target.toInt()}',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressPercentage, // Between 0 and 1
                backgroundColor: Colors.white,
                color: Colors.red,
                minHeight: 10,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentProgress += 1;
                    if (currentProgress > target) {
                      currentProgress = target;
                    }
                  });
                },
                child: Text('Increase Progress'),
              ),

              SizedBox(height: 20,),

              Text(
                'Progress: ${currentProgress.toInt()} / ${target.toInt()}',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressPercentage, // Between 0 and 1
                backgroundColor: Colors.white,
                color: Colors.red,
                minHeight: 10,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentProgress += 1;
                    if (currentProgress > target) {
                      currentProgress = target;
                    }
                  });
                },
                child: Text('Increase Progress'),
              ),

              SizedBox(height: 20,),

              Text(
                'Progress: ${currentProgress.toInt()} / ${target.toInt()}',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressPercentage, // Between 0 and 1
                backgroundColor: Colors.white,
                color: Colors.red,
                minHeight: 10,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentProgress += 1;
                    if (currentProgress > target) {
                      currentProgress = target;
                    }
                  });
                },
                child: Text('Increase Progress'),
              ),

              SizedBox(height: 20,),

              Text(
                'Progress: ${currentProgress.toInt()} / ${target.toInt()}',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressPercentage, // Between 0 and 1
                backgroundColor: Colors.white,
                color: Colors.red,
                minHeight: 10,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentProgress += 1;
                    if (currentProgress > target) {
                      currentProgress = target;
                    }
                  });
                },
                child: Text('Increase Progress'),
              ),

              SizedBox(height: 20,),

              Text(
                'Progress: ${currentProgress.toInt()} / ${target.toInt()}',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressPercentage, // Between 0 and 1
                backgroundColor: Colors.white,
                color: Colors.red,
                minHeight: 10,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentProgress += 1;
                    if (currentProgress > target) {
                      currentProgress = target;
                    }
                  });
                },
                child: Text('Increase Progress'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
