import 'package:flutter/material.dart';

void main() {
  runApp(const ChineseEatsApp());
}

class ChineseEatsApp extends StatelessWidget {
  const ChineseEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinese Eats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFD32F2F),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          primary: const Color(0xFFD32F2F),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// Model Makanan
class FoodItem {
  final String id;
  final String name;
  final String description;
  final int price;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Status State Aplikasi
  bool _isLoggedIn = false; // Default false (Tampilkan Halaman Login dulu)
  bool _isStudentVerified = false; // Status Verifikasi Pelajar di Profil
  bool _isVoucherClaimed = false; // Status Aktif Voucher
  int _currentIndex = 0;

  final TextEditingController _emailController = TextEditingController();
  String _userName = "Alfonso";

  // Data Menu Makanan
  final List<FoodItem> _foodList = [
    FoodItem(
      id: '1',
      name: 'Bebek Peking',
      description: 'Bebek panggang khas dengan saus hoisin',
      price: 150000,
    ),
    FoodItem(
      id: '2',
      name: 'Ayam Kung Pao',
      description: 'Potongan ayam pedas dengan kacang mete',
      price: 75000,
    ),
    FoodItem(
      id: '3',
      name: 'Dimsum Platter',
      description: 'Kombinasi Hakau, Siomay, dan Mantau',
      price: 65000,
    ),
    FoodItem(
      id: '4',
      name: 'Mapo Tofu',
      description: 'Tahu sutra pedas dengan daging cincang',
      price: 55000,
    ),
  ];

  // Keranjang Pesanan
  final Map<FoodItem, int> _cart = {};

  void _addToCart(FoodItem item) {
    setState(() {
      _cart[item] = (_cart[item] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} ditambahkan ke pesanan'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int get _subtotal {
    int total = 0;
    _cart.forEach((item, qty) {
      total += item.price * qty;
    });
    return total;
  }

  // Calculation: Hanya jika terverifikasi DAN voucher diaktifkan
  int get _discount {
    if (_isStudentVerified && _isVoucherClaimed && _subtotal > 0) {
      return (_subtotal * 0.15).round();
    }
    return 0;
  }

  int get _totalPrice => _subtotal - _discount;

  @override
  Widget build(BuildContext context) {
    // Jika belum login, tampilkan Screen Login
    if (!_isLoggedIn) {
      return _buildLoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        titleSpacing: 16,
        title: const Row(
          children: [
            Icon(Icons.rice_bowl, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Chinese Eats',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildMenuScreen();
      case 1:
        return _buildPesananScreen();
      case 2:
        return _buildProfilScreen();
      default:
        return _buildMenuScreen();
    }
  }

  // --- 1. HALAMAN LOGIN ---
  Widget _buildLoginScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rice_bowl, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Chinese Eats',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFD32F2F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selamat Datang',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
                hintText: 'Masukkan Email Anda',
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Silakan masukkan email Anda!')),
                    );
                    return;
                  }
                  setState(() {
                    _isLoggedIn = true;
                    if (_emailController.text.contains('@')) {
                      _userName = _emailController.text.split('@')[0];
                    } else {
                      _userName = _emailController.text;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. HALAMAN MENU ---
  Widget _buildMenuScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _foodList.length,
            itemBuilder: (context, index) {
              final item = _foodList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF4F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE8E8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flatware,
                        color: Color(0xFFD32F2F),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${item.price}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _addToCart(item),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFFD32F2F),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Panel Bawah Total Sementara & Tombol Voucher
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Sementara:',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Text(
                    'Rp $_subtotal',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  if (!_isStudentVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verifikasi status pelajar Anda di menu Profil terlebih dahulu!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // Pindah otomatis ke tab profil
                    setState(() {
                      _currentIndex = 2;
                    });
                  } else {
                    setState(() {
                      _isVoucherClaimed = !_isVoucherClaimed;
                    });
                  }
                },
                icon: Icon(
                  Icons.local_offer_outlined,
                  size: 18,
                  color: _isStudentVerified ? const Color(0xFFD32F2F) : Colors.grey,
                ),
                label: Text(
                  !_isStudentVerified
                      ? 'Klaim Voucher Pelajar (Verifikasi di Profil)'
                      : (_isVoucherClaimed
                          ? 'Voucher Pelajar Aktif (Diskon 15%)'
                          : 'Klaim Voucher Pelajar (Diskon 15%)'),
                  style: TextStyle(
                    color: _isStudentVerified ? const Color(0xFFD32F2F) : Colors.grey,
                    fontSize: 13,
                    fontWeight: _isVoucherClaimed ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  side: BorderSide(
                    color: _isStudentVerified ? const Color(0xFFD32F2F) : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 3. HALAMAN PESANAN ---
  Widget _buildPesananScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Rincian Pesanan:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _cart.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada pesanan',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    final item = _cart.keys.elementAt(index);
                    final qty = _cart[item]!;
                    final itemTotal = item.price * qty;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Rp ${item.price} x $qty',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Rp $itemTotal',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // Rincian Pembayaran Bawah
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text('Rp $_subtotal', style: const TextStyle(color: Colors.black87, fontSize: 13)),
                ],
              ),
              if (_discount > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Diskon Pelajar (15%):',
                      style: TextStyle(color: Colors.green, fontSize: 13),
                    ),
                    Text(
                      '- Rp $_discount',
                      style: const TextStyle(color: Colors.green, fontSize: 13),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'Rp $_totalPrice',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _cart.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pesanan berhasil dibuat!')),
                          );
                          setState(() {
                            _cart.clear();
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Buat Pesanan Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. HALAMAN PROFIL (TEMPAT VERIFIKASI PELAJAR) ---
  Widget _buildProfilScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.edit, size: 16, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text.isNotEmpty ? _emailController.text : 'gmail',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // KARTU VERIFIKASI DISKON PELAJAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _isStudentVerified ? Colors.green.shade300 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: _isStudentVerified ? Colors.green : Colors.grey,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isStudentVerified
                                ? 'Status: Pelajar Aktif (Terverifikasi)'
                                : 'Status: Pelajar Belum Terverifikasi',
                            style: TextStyle(
                              color: _isStudentVerified ? Colors.green : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isStudentVerified
                                ? 'Voucher pelajar siap digunakan'
                                : 'Verifikasi status untuk mengaktifkan diskon 15%',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isStudentVerified)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 22,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Tombol aksi untuk mengubah status verifikasi
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isStudentVerified = !_isStudentVerified;
                        if (_isStudentVerified) {
                          _isVoucherClaimed = true; // Otomatis mengaktifkan voucher jika terverifikasi
                        } else {
                          _isVoucherClaimed = false;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isStudentVerified
                                ? 'Status Pelajar Berhasil Diverifikasi!'
                                : 'Verifikasi Pelajar Dibatalkan',
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isStudentVerified ? Colors.red : Colors.green,
                      side: BorderSide(
                        color: _isStudentVerified ? Colors.red : Colors.green,
                      ),
                    ),
                    child: Text(
                      _isStudentVerified ? 'Batalkan Verifikasi' : 'Verifikasi Sekarang',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Tombol Log Out
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoggedIn = false;
                  _isStudentVerified = false;
                  _isVoucherClaimed = false;
                  _currentIndex = 0;
                  _cart.clear();
                });
              },
              icon: const Icon(Icons.logout, color: Colors.white, size: 20),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF424242),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
