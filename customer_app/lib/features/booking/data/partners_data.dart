import '../models/partner_model.dart';

final Map<String, List<PartnerModel>> partnersData = {
  'Switch/Socket Installation': [
    const PartnerModel(
      id: 'p1',
      name: 'Priya Sharma',
      imagePath: 'assets/images/partner_priya.png', // Placeholder
      rating: 4.9,
      reviewCount: 234,
      jobCount: 567,
      distance: 1.8,
      duration: '~20 min',
      price: '₹200 - ₹250',
      isTopPro: true,
      isPremium: true,
    ),
    const PartnerModel(
      id: 'p2',
      name: 'Sneha Reddy',
      imagePath: 'assets/images/partner_sneha.png', // Placeholder
      rating: 4.9,
      reviewCount: 312,
      jobCount: 689,
      distance: 2.1,
      duration: '~25 min',
      price: '₹180 - ₹230',
      isTopPro: true,
      isPremium: true,
    ),
    const PartnerModel(
      id: 'p3',
      name: 'Rajesh Kumar',
      imagePath: 'assets/images/partner_rajesh.png', // Placeholder
      rating: 4.8,
      reviewCount: 156,
      jobCount: 342,
      distance: 2.5,
      duration: '~30 min',
      price: '₹150 - ₹200',
      isTopPro: true,
    ),
  ],
  // Fallback / Generic electrician list if service not found
  'Electrician': [
    const PartnerModel(
      id: 'p4',
      name: 'Amit Verma',
      imagePath: 'assets/images/partner_amit.png', 
      rating: 4.7,
      reviewCount: 120,
      jobCount: 200,
      distance: 3.0,
      duration: '~35 min',
      price: '₹150 - ₹180',
    ),
  ],
};
