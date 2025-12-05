import '../models/service_model.dart';

final Map<String, List<ServiceModel>> servicesData = {
  'Electrician': [
    const ServiceModel(
      title: 'Switch/Socket Installation',
      description: 'Installation and repair of electrical switches and sockets',
      rating: 4.6,
      reviews: 654,
      duration: '30 min',
      price: '₹179 - ₹229',
      category: 'Electrician',
    ),
    const ServiceModel(
      title: 'Fan Installation',
      description: 'Ceiling fan installation and repair services',
      rating: 4.7,
      reviews: 432,
      duration: '45 min',
      price: '₹250 - ₹299',
      category: 'Electrician',
    ),
  ],
  'Plumber': [
    const ServiceModel(
      title: 'Tap Repair',
      description: 'Fixing leaking taps and general tap maintenance',
      rating: 4.5,
      reviews: 320,
      duration: '30 min',
      price: '₹120 - ₹149',
      category: 'Plumber',
    ),
    const ServiceModel(
      title: 'Pipe Leakage',
      description: 'Identification and repair of water pipe leakages',
      rating: 4.8,
      reviews: 150,
      duration: '1 hr',
      price: '₹350 - ₹399',
      category: 'Plumber',
    ),
  ],
  'Carpenter': [
    const ServiceModel(
      title: 'Furniture Assembly',
      description: 'Assembly of tables, chairs, and other furniture',
      rating: 4.6,
      reviews: 210,
      duration: '1 hr',
      price: '₹450 - ₹499',
      category: 'Carpenter',
    ),
  ],
  // Add more categories and services here easily
};
