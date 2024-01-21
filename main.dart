import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: GradeCalculator(),
    theme: ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 76, 175, 153),
      primaryColor: Color.fromARGB(255, 18, 18, 18),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 16, 16, 15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 8, 8, 8),
        ),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: const Color(0xFFFFFFFF),
        ),
      ),
    ),
  ));
}

class GradeCalculator extends StatefulWidget {
  @override
  _GradeCalculatorState createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  List<Course> courses = [];

  void _addCourse(
      String name, double test1, double test2, double finalExam, double ms) {
    if (name.isNotEmpty &&
        test1 >= 0 &&
        test1 <= 100 &&
        test2 >= 0 &&
        test2 <= 100 &&
        finalExam >= 0 &&
        finalExam <= 100 &&
        ms >= 0 &&
        ms <= 100) {
      setState(() {
        Course course = Course(name, test1, test2, finalExam, ms);
        courses.add(course);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('خطأ'),
            content: Text('يرجى تحقق من البيانات المدخلة'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('حسناً'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حساب الدرجات'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddCourseDialog((name, test1, test2, finalExam, ms) {
                      _addCourse(name, test1, test2, finalExam, ms);
                      Navigator.of(context).pop();
                    });
                  },
                );
              },
              child: Text('إضافة المادة'),
            ),
            SizedBox(height: 100.0),
            Text(
              'المادة\t\tالدرجة\tالتقدير',
              style: TextStyle(fontSize: 30.0),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  Course course = courses[index];
                  return ListTile(
                    title: Text(course.name),
                    subtitle: Text(
                        'Mark: ${course.calculateAverage().toStringAsFixed(2)}\tGrade: ${course.calculateGrade()}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Course {
  String name;
  double test1;
  double test2;
  double finalExam;
  double ms;

  Course(this.name, this.test1, this.test2, this.finalExam, this.ms);

  double calculateAverage() {
    return (test1 + test2 + finalExam + ms);
  }

  String calculateGrade() {
    double average = calculateAverage();
    if (average >= 95) {
      return 'A+';
    } else if (average >= 90) {
      return 'A';
    } else if (average >= 85) {
      return 'B+';
    } else if (average >= 80) {
      return 'B';
    } else if (average >= 75) {
      return 'C+';
    } else if (average >= 70) {
      return 'C';
    } else if (average >= 65) {
      return 'D+';
    } else if (average >= 60) {
      return 'D';
    } else {
      return 'راسب';
    }
  }
}

class AddCourseDialog extends StatefulWidget {
  final Function(String, double, double, double, double) onAddCourse;

  AddCourseDialog(this.onAddCourse);

  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  String name = '';
  double test1 = 0.0;
  double test2 = 0.0;
  double finalExam = 0.0;
  double ms = 0.0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة المادة'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'اسم المادة'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الاختبار الأول'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                test1 = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الاختبار الثاني'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                test2 = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الاختبار النهائي'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                finalExam = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'درجه الواجبات و المشاركه'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                ms = double.tryParse(value) ?? 0.0;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onAddCourse(name, test1, test2, finalExam, ms);
          },
          child: Text('اضف'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('إلغاء'),
        ),
      ],
    );
  }
}
