class Levels {
  static final List<Level> lvls = [
    Level(1, 100),
    Level(2, 250),
    Level(3, 400),
    Level(4, 550),
    Level(5, 750),
    Level(6, 950),
    Level(7, 1250),
    Level(8, 1600),
    Level(9, 2000),
    Level(10, 2500),
  ];

  static Level getLevelFrom(double experience) {
    for (Level lvl in lvls) {
      if (experience <= lvl.maxExp) return lvl;
    }
    return lvls[lvls.length - 1];
  }
}

class Level {
  final int number;
  final double maxExp;

  Level(this.number, this.maxExp);

  @override
  String toString() {
    return "LVL. ${this.number}";
  }
}
