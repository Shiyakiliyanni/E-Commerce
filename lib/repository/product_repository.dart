
import 'package:cart_project/models/product_model.dart';

class ProductRepository {
  static List<Product> getProducts() {
    return [
      Product(
        id: 1,
        name: 'Smartphone',
        description: 'A high-quality smartphone with great features.',
        price: 699.99,
        imageUrl: 'assets/images/smartphone.jpg',
      ),
      Product(
        id: 2,
        name: 'Headphones',
        description: 'Noise-cancelling over-ear headphones.',
        price: 199.99,
        imageUrl: 'assets/images/headphone.jpg',
      ),
      Product(
        id: 3,
        name: 'Laptop',
        description: 'Powerful laptop for all your needs.',
        price: 1299.99,
        imageUrl: 'assets/images/laptop.jpg',
      ),
      Product(
        id: 4,
        name: 'Speaker',
        description: 'A high-performance bookshelf speaker with a sleek design and rich, balanced sound, ideal for home audio systems.',
        price: 999.99,
        imageUrl: 'assets/images/speaker.jpg',
      ),
      Product(
        id: 5,
        name: 'Alexa',
        description: 'A voice-activated smart speaker with advanced features, capable of playing music, controlling smart home devices, and providing information and assistance.',
        price: 2999.99,
        imageUrl: 'assets/images/alexa.jpg',
      ),
      Product(
        id: 6,
        name: 'Earbuds',
        description: 'Wireless earbuds with ergonomic design and immersive sound, perfect for on-the-go listening.',
        price: 1699.99,
        imageUrl: 'assets/images/earbuds.jpg',
      ),
      Product(
        id: 7,
        name: 'Monitor',
        description: 'A high-resolution monitor with a sleek design and wide viewing angle, ideal for productivity and entertainment.',
        price: 1899.99,
        imageUrl: 'assets/images/monitor.jpg',
      ),
      Product(
        id: 8,
        name: 'Modem',
        description: 'A high-speed broadband modem with advanced features, providing reliable internet connectivity for your home or office.',
        price: 699.99,
        imageUrl: 'assets/images/modem.jpg',
      ),
    ];
  }
}
