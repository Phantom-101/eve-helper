import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Progress {
  ValueNotifier<int> progress;
  ValueNotifier<int> target;
  ValueNotifier<ProgressState> state;

  Progress() {
    progress = ValueNotifier(0);
    target = ValueNotifier(1);
    state = ValueNotifier(ProgressState.Ready);
  }

  Widget getWidget(double size) {
    return Container(
      height: size,
      width: size,
      child: AnimatedBuilder(
        animation: Listenable.merge([progress, target, state]),
        builder: (context, child) {
          update();
          if (state.value == ProgressState.Ready || state.value == ProgressState.Done) {
            return CircularProgressIndicator(
              strokeWidth: 4,
              value: 1,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            );
          } else if (state.value == ProgressState.Loading) {
            return CircularProgressIndicator(
              strokeWidth: 4,
              value: progress.value.toDouble() / max(1, target.value),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              backgroundColor: Colors.grey,
            );
          } else {
            return CircularProgressIndicator(
              strokeWidth: 4,
              value: 1,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            );
          }
        }
      ),
    );
  }

  void start(int t) {
    if (busy()) return;
    progress.value = 0;
    target.value = t;
    state.value = ProgressState.Loading;
  }

  void update() {
    if (progress.value >= target.value && state.value == ProgressState.Loading) {
      state.value = ProgressState.Done;
    }
  }

  void err() {
    state.value = ProgressState.Error;
  }

  bool busy() {
    update();
    if (state.value == ProgressState.Loading) return true;
    return false;
  }
}

enum ProgressState {
  Ready,
  Loading,
  Done,
  Error,
}
