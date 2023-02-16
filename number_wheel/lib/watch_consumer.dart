import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class WatchConsumer<T> extends StatelessWidget {
  final ProviderListenable<T> watch;
  final Widget Function(BuildContext context, WidgetRef ref, T provider)
      builder;

  const WatchConsumer({
    Key? key,
    required this.watch,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) => builder(
        context,
        ref,
        ref.watch(watch),
      ),
    );
  }
}
