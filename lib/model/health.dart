import 'package:cloud_firestore/cloud_firestore.dart';

/// [健康状態のモデル]
class Health {
  int? diet; // 食事
  int? sleep; // 睡眠
  int? exercise; // 運動
  int? mentalState; // 精神状態
  Timestamp? createdAt; // 作成日時

  Health({
    this.diet,
    this.sleep,
    this.exercise,
    this.mentalState,
    this.createdAt,
  });
  // JSONからHealthを生成
  factory Health.fromJson(Map<String, dynamic> json) {
    return Health(
      diet: json['diet'],
      sleep: json['sleep'],
      exercise: json['exercise'],
      mentalState: json['mentalState'],
      createdAt: json['createdAt'],
    );
  }
  // HealthをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'diet': diet,
      'sleep': sleep,
      'exercise': exercise,
      'mentalState': mentalState,
      'createdAt': createdAt,
    };
  }
}
