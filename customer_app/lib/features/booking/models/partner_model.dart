class PartnerModel {
  final String id;
  final String name;
  final String imagePath;
  final double rating;
  final int reviewCount;
  final int jobCount;
  final double distance;
  final String duration;
  final String price;
  final bool isTopPro;
  final bool isPremium;

  const PartnerModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.reviewCount,
    required this.jobCount,
    required this.distance,
    required this.duration,
    required this.price,
    this.isTopPro = false,
    this.isPremium = false,
  });
}
