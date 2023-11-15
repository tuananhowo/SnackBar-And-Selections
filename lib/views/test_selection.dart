import 'package:flutter/material.dart';

class TestSelection extends StatelessWidget {
  const TestSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: CheckBoxWidget(),
          ),
          SizedBox(
            height: 20,
          ),
          ChipWidget(),
          SizedBox(
            height: 20,
          ),
          DatePickerWidget(restorationId: 'main'),
          SizedBox(
            height: 20,
          ),
          PopupMenuWidget(),
          SizedBox(
            height: 20,
          ),
          RadioSampleWidget(),
          SliderAppWidget(),
          SizedBox(
            height: 20,
          ),
          SwitchWidget(),
          SizedBox(
            height: 20,
          ),
          ShowTimePicker()
        ],
      ),
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Check Box',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(
                () {
                  isChecked = value!;
                },
              );
            },
            fillColor: MaterialStateProperty.resolveWith(getColor),
          ),
        ],
      ),
    );
  }
}

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text(
        'The Chip',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      avatar: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 187, 11, 11),
        child: Text(
          'Qatari',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key, this.restorationId});

  final String? restorationId;
  //define id

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 12, 12));
  // track and restore the state of the selected date

  // 'RestorableRouteFuture' track and restore state of 'DatePickerDialog' when app close or open
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  // 'route' constructor is used to display 'DatePickerDialog'
  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  //override to register objects that need to be tracked and recovered
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  //When the user selects a date in the dialog
  // update the '_selectedDate' state and display a 'SnackBar' announcing the selected date
  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _restorableDatePickerRouteFuture.present();
        // display dialog
      },
      child: const Text('Click To Show Date'),
    );
  }
}

class PopupMenuWidget extends StatefulWidget {
  const PopupMenuWidget({super.key});

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  SampleItem? selectedMenu;
  String selectText = '';

  final Map<SampleItem, String> itemTextMap = {
    SampleItem.itemOne: 'Item 1',
    SampleItem.itemTwo: 'Item 2',
    SampleItem.itemThree: 'Item 3',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(selectText),
        PopupMenuButton<SampleItem>(
          initialValue: selectedMenu, //gia tri ban dau
          onSelected: (SampleItem item) {
            setState(() {
              selectedMenu = item;
              selectText = item.toString();
              // select value 'item' in popup menu
              selectText = itemTextMap[item] ?? '';
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            const PopupMenuItem(
              value: SampleItem.itemOne,
              child: Text('Item 1'),
            ),
            const PopupMenuItem(
              value: SampleItem.itemTwo,
              child: Text('Item 2'),
            ),
            const PopupMenuItem(
              value: SampleItem.itemThree,
              child: Text('Item 3'),
            )
          ],
        ),
      ],
    );
  }
}

class RadioSampleWidget extends StatefulWidget {
  const RadioSampleWidget({super.key});

  @override
  State<RadioSampleWidget> createState() => _RadioSampleWidgetState();
}

enum SingingCharacter { boy, woman }

class _RadioSampleWidgetState extends State<RadioSampleWidget> {
  SingingCharacter? _character = SingingCharacter.boy;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: const Text('Boy'),
          leading: Radio<SingingCharacter>(
            groupValue: _character,
            value: SingingCharacter.boy,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Girl'),
          leading: Radio<SingingCharacter>(
            groupValue: _character,
            value: SingingCharacter.woman,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        )
      ],
    );
  }
}

class SliderAppWidget extends StatefulWidget {
  const SliderAppWidget({super.key});

  @override
  State<SliderAppWidget> createState() => _SliderAppWidgetState();
}

class _SliderAppWidgetState extends State<SliderAppWidget> {
  double _currentSliderValue = 80;
  @override
  Widget build(BuildContext context) {
    return Slider(
        value: _currentSliderValue,
        max: 100,
        divisions: 100,
        label: _currentSliderValue.round().toString(),
        //display rank

        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        });
  }
}

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({super.key});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool active = true;
  @override
  Widget build(BuildContext context) {
    return Switch(
        thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) {
          if (states.contains(MaterialState.selected)) {
            return const Icon(Icons.check);
          }
          return const Icon(Icons.close);
        }),
        value: active,
        onChanged: (bool value) {
          setState(() {
            active = value;
          });
        });
  }
}

class ShowTimePicker extends StatefulWidget {
  const ShowTimePicker({super.key});

  @override
  State<ShowTimePicker> createState() => _ShowTimePickerState();
}

class _ShowTimePickerState extends State<ShowTimePicker> {
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 12, minute: 12);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          ' ${_timeOfDay.format(context).toString()}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 20,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            showTimePicker(context: context, initialTime: TimeOfDay.now())
                .then((value) {
              if (value != null) {
                setState(() {
                  _timeOfDay = value;
                });
              }
            });
          }
          // _showTimePicker
          ,
          color: Colors.purple,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Pick Time Here',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
