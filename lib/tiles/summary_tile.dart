import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SummaryTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final double amount;
  final String label;

  const SummaryTile({
    Key key,
    @required this.onTap,
    @required this.iconData,
    @required this.amount,
    @required this.label,
  })  : assert(onTap != null),
        assert(iconData != null),
        assert(amount != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Icon(iconData),
        ),
      ),
      title: Text(amount.toString()),
      subtitle: Text(
        label,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
