import 'package:flutter/material.dart';
import 'package:repairman/utils.dart';
import 'package:repairman/components/text_input.dart';

class DatePicker extends StatefulWidget {
  final String labelText;
  final Function onChanged;
  final DateTime? initialDate;
  const DatePicker({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.initialDate,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? date;
  final controller = TextEditingController();
  final String emptyText = '';

  @override
  void initState() {
    super.initState();
    date = widget.initialDate;
    widget.onChanged(date);
    controller.text = dateAsString(date) ?? emptyText;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextFormField(
        controller: controller,
        readOnly: true,

        decoration: defaultDecoration(context).copyWith(
          labelText: widget.labelText,
          suffixIcon: date != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      date = null;
                    });
                    widget.onChanged(null);
                    controller.text = emptyText;
                  },
                  icon: Icon(Icons.cancel_outlined),
                )
              : Icon(null),
        ),
        onTap: () async {
          final newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          setState(() {
            date = newDate;
          });
          controller.text = dateAsString(newDate) ?? emptyText;
          widget.onChanged(newDate);
        },
      ),
    );
  }
}

// class _DatePickerState extends State<DatePicker> {
//   DateTime? date;

//   @override
//   void initState() {
//     super.initState();
//     date = widget.initialDate;
//     widget.onChanged(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(12),
//       child: Card(
//         clipBehavior: Clip
//             .antiAlias, // Ensures the splash color matches the rounded corners
//         child: InkWell(
//           onTap: () async {
//             final newDate = await showDatePicker(
//               context: context,
//               initialDate: date,
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );
//             setState(() {
//               date = newDate;
//             });
//             widget.onChanged(newDate);
//           },
//           splashColor: Theme.of(context).colorScheme.surfaceDim,
//           child: Padding(
//             padding: EdgeInsets.all(12),
//             child: Center(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Text(widget.labelText),
//                         Text(
//                           date != null
//                               ? DateFormat("dd/MM/yyyy").format(date!)
//                               : 'Selecionar',
//                           style: Theme.of(context).textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         date = null;
//                       });
//                       widget.onChanged(null);
//                     },
//                     icon: Icon(Icons.cancel_outlined),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
