//코인 환율 모델
class CoinRateModel {
  final int rate;

  CoinRateModel.fromJson(Map<String, dynamic> json) : rate = json['rate'];
}
