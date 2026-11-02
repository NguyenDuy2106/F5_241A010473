import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F5 - Danh sách và lưới',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0468D7)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class SanPham {
  const SanPham({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.gia,
    required this.anh,
  });

  final int id;
  final String ten;
  final String moTa;
  final int gia;
  final String anh;
}

const List<SanPham> duLieuMau = [
  SanPham(
    id: 1,
    ten: 'Áo thun VHU',
    moTa: 'Cotton 100%, in logo trường',
    gia: 180000,
    anh: 'assets/images/anh (1).jpg',
  ),
  SanPham(
    id: 2,
    ten: 'Bình giữ nhiệt',
    moTa: 'Inox 500ml, giữ nóng 6 giờ',
    gia: 250000,
    anh: 'assets/images/anh (2).jpg',
  ),
  SanPham(
    id: 3,
    ten: 'Sổ tay sinh viên',
    moTa: '200 trang, bìa cứng',
    gia: 75000,
    anh: 'assets/images/anh (3).jpg',
  ),
  SanPham(
    id: 4,
    ten: 'Balo laptop',
    moTa: 'Chống nước, ngăn 15.6 inch',
    gia: 420000,
    anh: 'assets/images/anh (4).jpg',
  ),
  SanPham(
    id: 5,
    ten: 'Móc khóa gỗ',
    moTa: 'Khắc laser tên trường',
    gia: 35000,
    anh: 'assets/images/anh (5).jpg',
  ),
  SanPham(
    id: 6,
    ten: 'Cốc sứ in hình',
    moTa: 'Dung tích 350ml',
    gia: 95000,
    anh: 'assets/images/anh (6).jpg',
  ),
];

String dinhDangGia(int gia) {
  final chuoiGia = gia.toString();
  final ketQua = StringBuffer();
  for (var i = 0; i < chuoiGia.length; i++) {
    if (i > 0 && (chuoiGia.length - i) % 3 == 0) {
      ketQua.write('.');
    }
    ketQua.write(chuoiGia[i]);
  }
  return '${ketQua.toString()} đ';
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  final GlobalKey<_ProductListTabState> _productTabKey =
      GlobalKey<_ProductListTabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tab == 0 ? 'Danh sách sản phẩm' : 'Album ảnh'),
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          ProductListTab(key: _productTabKey),
          const AlbumTab(),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: () => _productTabKey.currentState?._them(),
              tooltip: 'Thêm sản phẩm',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Danh sách'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Lưới'),
        ],
      ),
    );
  }
}

class ProductListTab extends StatefulWidget {
  const ProductListTab({super.key});

  @override
  State<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends State<ProductListTab> {
  final List<SanPham> _ds = List.of(duLieuMau);
  final TextEditingController _searchController = TextEditingController();
  String _tuKhoa = '';
  int _dem = 0;
  int _idTiepTheo = 7;

  List<SanPham> get _ketQuaTimKiem {
    final tuKhoa = _tuKhoa.trim().toLowerCase();
    if (tuKhoa.isEmpty) return _ds;
    return _ds
        .where((sanPham) => sanPham.ten.toLowerCase().contains(tuKhoa))
        .toList();
  }

  void _them() {
    setState(() {
      _dem++;
      _ds.insert(
        0,
        SanPham(
          id: _idTiepTheo++,
          ten: 'Sản phẩm mới $_dem',
          moTa: 'Sản phẩm vừa được thêm',
          gia: 50000 * _dem,
          anh: duLieuMau.first.anh,
        ),
      );
    });
  }

  void _xoa(SanPham sanPham) {
    setState(() => _ds.removeWhere((item) => item.id == sanPham.id));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Đã xóa ${sanPham.ten}')));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final danhSach = _ketQuaTimKiem;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            key: const ValueKey('product-search'),
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Tìm theo tên sản phẩm',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _tuKhoa.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Xóa tìm kiếm',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _tuKhoa = '');
                      },
                      icon: const Icon(Icons.clear),
                    ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _tuKhoa = value),
          ),
        ),
        Expanded(
          child: danhSach.isEmpty
              ? Center(
                  child: Text(
                    _ds.isEmpty ? 'Danh sách trống' : 'Không tìm thấy sản phẩm',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: danhSach.length,
                  itemBuilder: (context, index) {
                    final sanPham = danhSach[index];
                    return Dismissible(
                      key: ValueKey<int>(sanPham.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _xoa(sanPham),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: AnhSanPham(
                            duongDan: sanPham.anh,
                            kichThuoc: 56,
                          ),
                          title: Text(
                            sanPham.ten,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            sanPham.moTa,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            dinhDangGia(sanPham.gia),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    ProductDetailPage(sanPham: sanPham),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.sanPham, super.key});

  final SanPham sanPham;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AnhSanPham(duongDan: sanPham.anh, kichThuoc: 280),
          ),
          const SizedBox(height: 16),
          Text(sanPham.ten, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            dinhDangGia(sanPham.gia),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mô tả sản phẩm',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(sanPham.moTa),
        ],
      ),
    );
  }
}

class AlbumTab extends StatelessWidget {
  const AlbumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: duLieuMau.length,
      itemBuilder: (context, index) {
        final sanPham = duLieuMau[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: AnhSanPham(duongDan: sanPham.anh)),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sanPham.ten,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dinhDangGia(sanPham.gia),
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnhSanPham extends StatelessWidget {
  const AnhSanPham({required this.duongDan, this.kichThuoc, super.key});

  final String duongDan;
  final double? kichThuoc;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      duongDan,
      width: kichThuoc,
      height: kichThuoc,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: kichThuoc,
        height: kichThuoc,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}
