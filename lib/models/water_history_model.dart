class WaterHistoryModel {
  final String date;
  final int glasses;
  final int milliliters;

  const WaterHistoryModel({
    required this.date,
    required this.glasses,
    required this.milliliters,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "glasses": glasses,
      "milliliters": milliliters,
    };
  }

  factory WaterHistoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WaterHistoryModel(
      date: json["date"]?.toString() ?? "",
      glasses: json["glasses"] is int
          ? json["glasses"] as int
          : int.tryParse(
        json["glasses"]?.toString() ?? "0",
      ) ??
          0,
      milliliters: json["milliliters"] is int
          ? json["milliliters"] as int
          : int.tryParse(
        json["milliliters"]?.toString() ?? "0",
      ) ??
          0,
    );
  }

  WaterHistoryModel copyWith({
    String? date,
    int? glasses,
    int? milliliters,
  }) {
    return WaterHistoryModel(
      date: date ?? this.date,
      glasses: glasses ?? this.glasses,
      milliliters:
      milliliters ?? this.milliliters,
    );
  }
}