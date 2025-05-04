-- MEMBUAT DATABASE
CREATE DATABASE testDB;
USE testDB;

-- MEMBUAT TABEL
CREATE TABLE products (
    id VARCHAR(10) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category TEXT,
    price INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- INSERT data
INSERT INTO products(id, category, name, price, quantity)
VALUES ('P0006', 'Makanan', 'Bakso Rusuk', 25000, 200),
       ('P0007', 'Minuman', 'Es Jeruk', 10000, 300),
       ('P0008', 'Minuman', 'Es Campur', 15000, 500),
       ('P0009', 'Minuman', 'Es Teh Manis', 5000, 400),
       ('P0010', 'Lain-Lain', 'Kerupuk', 2500, 1000),
       ('P0011', 'Lain-Lain', 'Keripik Udang', 10000, 300),
       ('P0012', 'Lain-Lain', 'Es Krim', 5000, 200),
       ('P0013', 'Makanan', 'Mie Ayam Jamur', 20000, 50),
       ('P0014', 'Makanan', 'Bakso Telor', 20000, 150),
       ('P0015', 'Makanan', 'Bakso Jando', 25000, 300);

-- Membuat tabel baru dengan nama 'wishlist'
-- Kolom 'id' sebagai primary key bertipe INT dan auto increment
-- Kolom 'id_product' bertipe VARCHAR(10) dan tidak boleh null
-- Kolom 'description' bertipe TEXT untuk keterangan tambahan
-- Menetapkan 'id' sebagai primary key tabel
-- Menambahkan foreign key 'id_product' yang merujuk ke kolom 'id' pada tabel 'products'
CREATE TABLE wishlist
(
    id          INT         NOT NULL AUTO_INCREMENT,
    id_product  VARCHAR(10) NOT NULL,
    description TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_wishlist_product
        FOREIGN KEY (id_product) REFERENCES products (id)
);

-- Menghapus constraint foreign key 'fk_wishlist_product' dari tabel 'wishlist'
-- Constraint tersebut sebelumnya menghubungkan kolom 'id_product' dengan kolom 'id' pada tabel 'products'
ALTER TABLE wishlist
    DROP CONSTRAINT fk_wishlist_product;

-- Menambahkan kembali constraint foreign key 'fk_wishlist_product' pada tabel 'wishlist'
-- Menghubungkan kolom 'id_product' dengan kolom 'id' pada tabel 'products'
-- Menetapkan aksi ON DELETE CASCADE untuk menghapus baris terkait secara otomatis saat data di tabel 'products' dihapus
-- Menetapkan aksi ON UPDATE CASCADE untuk mengupdate data terkait secara otomatis saat data pada tabel 'products' berubah
ALTER TABLE wishlist
    ADD CONSTRAINT fk_wishlist_product
        FOREIGN KEY (id_product) REFERENCES products (id)
            ON DELETE CASCADE ON UPDATE CASCADE;

-- Menambahkan data ke tabel 'wishlist' dengan id_product 'P0001' dan deskripsi 'Makanan Kesukaan'
-- Asumsinya, nilai 'P0001' sudah ada di tabel 'products' sehingga foreign key valid
-- Baris ini akan gagal dimasukkan
INSERT INTO wishlist(id_product, description)
VALUES ('P0001', 'Makanan Kesukaan');

-- Menambahkan data ke tabel 'wishlist' dengan id_product 'SALAH' dan deskripsi 'Makanan Kesukaan'
-- Nilai 'SALAH' diasumsikan tidak ada di tabel 'products'
-- Baris ini akan gagal karena MELANGGAR constraint foreign key
INSERT INTO wishlist(id_product, description)
VALUES ('SALAH', 'Makanan Kesukaan');

-- Mengambil semua data dari tabel 'wishlist' dan 'products'
-- Melakukan join berdasarkan kolom 'id_product' dari 'wishlist' dan kolom 'id' dari 'products'
-- Hanya baris yang cocok (match) antara kedua tabel yang akan ditampilkan
SELECT *
FROM wishlist
         JOIN products ON (wishlist.id_product = products.id);

-- Mengambil kolom 'id' dan 'name' dari tabel 'products'
-- Mengambil kolom 'description' dari tabel 'wishlist'
-- Melakukan join antara tabel 'wishlist' dan 'products' berdasarkan 'id_product' dan 'id'
SELECT products.id, products.name, wishlist.description
FROM wishlist
JOIN products ON (wishlist.id_product = products.id);


-- Membuat tabel baru bernama 'customers'
-- Kolom 'id' akan menjadi primary key, bertipe INT, tidak boleh NULL, dan auto increment
-- Kolom 'email' bertipe VARCHAR(100), tidak boleh NULL
-- Kolom 'first_name' bertipe VARCHAR(100), tidak boleh NULL
-- Kolom 'last_name' bertipe VARCHAR(100), boleh NULL
-- Menetapkan kolom 'id' sebagai primary key
-- Menambahkan constraint UNIQUE pada kolom 'email' agar email pelanggan tidak ada yang sama
CREATE TABLE customers
(
    id         INT          NOT NULL AUTO_INCREMENT,
    email      VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100),
    PRIMARY KEY (id),
    UNIQUE KEY email_unique (email)
);

-- Menambahkan kolom baru 'id_customer' bertipe INT pada tabel 'wishlist'
-- Kolom ini akan digunakan untuk menyimpan referensi ke tabel 'customers'
ALTER TABLE wishlist
ADD COLUMN id_customer INT;

-- Menambahkan constraint foreign key 'fk_wishlist_customer' pada kolom 'id_customer'
-- Foreign key ini menghubungkan kolom 'id_customer' di tabel 'wishlist' dengan kolom 'id' di tabel 'customers'
-- Ini memastikan bahwa setiap nilai 'id_customer' di 'wishlist' harus ada di tabel 'customers'
ALTER TABLE wishlist
ADD CONSTRAINT fk_wishlist_customer
FOREIGN KEY (id_customer) REFERENCES customers(id);

-- Mengupdate kolom 'id_customer' di tabel 'wishlist' menjadi 1
-- Baris yang diubah adalah yang memiliki 'id_product' = 'P0009'
-- Mengupdate kolom 'id_customer' di tabel 'wishlist' menjadi 1
-- Baris yang diubah adalah yang memiliki 'id_product' = 'P0014'
UPDATE wishlist SET id_customer = 1 WHERE id_product = 'P0009';
UPDATE wishlist SET id_customer = 1 WHERE id_product = 'P0014';

-- Mengambil data email dari tabel 'customers'
-- Mengambil id dan nama produk dari tabel 'products'
-- Mengambil deskripsi dari tabel 'wishlist'
-- Melakukan join antara tabel 'wishlist' dan 'products' berdasarkan 'id_product' dan 'id'
-- Melakukan join antara tabel 'wishlist' dan 'customers' berdasarkan 'id_customer' dan 'id'
-- Hanya baris yang memiliki kecocokan di ketiga tabel yang akan ditampilkan
SELECT customers.email, products.id, products.name, wishlist.description
FROM wishlist
JOIN products ON (products.id = wishlist.id_product)
JOIN customers ON (customers.id = wishlist.id_customer);


-- ONE TO ONE RELATIONSHIP ------------------------------------------------------------------------------------------------

-- Membuat tabel baru bernama 'wallet' untuk menyimpan saldo dompet pelanggan
-- Kolom 'id' sebagai primary key, bertipe INT, tidak boleh NULL, dan auto increment
-- Kolom ini menjadi identifikasi unik untuk setiap wallet
-- Kolom 'id_customer' bertipe INT, tidak boleh NULL
-- Kolom ini digunakan untuk menghubungkan wallet dengan pelanggan di tabel 'customers'
-- Kolom 'balance' bertipe INT, tidak boleh NULL, dengan nilai default 0
-- Kolom ini menyimpan jumlah saldo yang dimiliki pelanggan
-- Menetapkan 'id' sebagai primary key
-- Menambahkan constraint UNIQUE agar satu pelanggan hanya memiliki satu wallet
-- Menambahkan foreign key yang menghubungkan 'id_customer' dengan 'id' di tabel 'customers'
CREATE TABLE wallet
(
    id          INT NOT NULL AUTO_INCREMENT,
    id_customer INT NOT NULL,
    balance     INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY id_customer_unique (id_customer),
    FOREIGN KEY fk_wallet_customer (id_customer) REFERENCES customers (id)
);


-- ONE TO MANY RELATIONSHIP ------------------------------------------------------------------------------------------------

-- Membuat tabel baru bernama 'categories' untuk menyimpan data kategori produk
-- Kolom 'id' bertipe VARCHAR(10), tidak boleh NULL
-- Kolom ini menjadi primary key dan berfungsi sebagai identifikasi unik untuk setiap kategori
-- Kolom 'name' bertipe VARCHAR(100), tidak boleh NULL
-- Kolom ini digunakan untuk menyimpan nama kategori
-- Menetapkan kolom 'id' sebagai primary key
CREATE TABLE categories
(
    id   VARCHAR(10)  NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

-- Menampilkan struktur tabel 'categories' untuk memastikan kolom dan tipe data sudah sesuai
DESCRIBE categories;

-- Menghapus kolom 'category' dari tabel 'products' karena akan digantikan dengan relasi ke tabel 'categories'
ALTER TABLE products
DROP COLUMN category;

-- Menambahkan kolom baru 'id_category' ke tabel 'products' bertipe VARCHAR(10)
-- Kolom ini akan berfungsi sebagai foreign key untuk menghubungkan produk ke kategori
ALTER TABLE products
ADD COLUMN id_category VARCHAR(10);

-- Menambahkan constraint foreign key bernama 'fk_products_categories'
-- Constraint ini menghubungkan 'id_category' di tabel 'products' dengan 'id' di tabel 'categories'
-- Ini memastikan bahwa nilai 'id_category' harus sesuai dengan kategori yang tersedia
ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (id_category) REFERENCES categories (id);

-- MANY TO MANY RELATIONSHIP ------------------------------------------------------------------------------------------------

-- Membuat tabel baru bernama 'orders' untuk menyimpan data pesanan
-- Kolom 'id' bertipe INT, tidak boleh NULL, dan auto increment
-- Kolom ini berfungsi sebagai primary key untuk mengidentifikasi setiap pesanan
-- Kolom 'total' bertipe INT dan tidak boleh NULL
-- Kolom ini menyimpan jumlah total nilai dari suatu pesanan
-- Kolom 'order_date' bertipe DATETIME dan tidak boleh NULL
-- Nilainya secara default akan diisi dengan waktu saat data dimasukkan (CURRENT_TIMESTAMP)
-- Menetapkan kolom 'id' sebagai primary key
CREATE TABLE orders
(
    id         INT      NOT NULL AUTO_INCREMENT,
    total      INT      NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Membuat tabel baru bernama 'orders_detail' untuk menyimpan detail setiap pesanan
-- Kolom 'id_product' bertipe VARCHAR(10), tidak boleh NULL
-- Kolom ini menyimpan ID produk yang dipesan
-- Kolom 'id_order' bertipe INT, tidak boleh NULL
-- Kolom ini menyimpan ID dari pesanan yang terkait
-- Kolom 'price' bertipe INT, tidak boleh NULL
-- Kolom ini menyimpan harga produk pada saat pemesanan
-- Kolom 'quantity' bertipe INT, tidak boleh NULL
-- Kolom ini menyimpan jumlah produk yang dipesan
-- Menetapkan kombinasi 'id_product' dan 'id_order' sebagai primary key
-- Setiap kombinasi unik merepresentasikan satu item dalam satu pesanan
CREATE TABLE orders_detail
(
    id_product VARCHAR(10) NOT NULL,
    id_order   INT         NOT NULL,
    price      INT         NOT NULL,
    quantity   INT         NOT NULL,
    PRIMARY KEY (id_product, id_order)
);

-- Menambahkan foreign key pada tabel 'orders_detail' untuk kolom 'id_product'
-- Menghubungkan 'id_product' di tabel 'orders_detail' ke kolom 'id' di tabel 'products'
-- Ini memastikan bahwa setiap produk dalam detail pesanan harus ada dalam tabel 'products'
ALTER TABLE orders_detail
ADD CONSTRAINT fk_orders_detail_product
FOREIGN KEY (id_product) REFERENCES products (id);

-- Menambahkan foreign key pada tabel 'orders_detail' untuk kolom 'id_order'
-- Menghubungkan 'id_order' di tabel 'orders_detail' ke kolom 'id' di tabel 'orders'
-- Ini memastikan bahwa setiap detail pesanan terhubung ke pesanan yang sah dalam tabel 'orders'
ALTER TABLE orders_detail
ADD CONSTRAINT fk_orders_detail_orders
FOREIGN KEY (id_order) REFERENCES orders (id);

-- JENIS JENIS JOIN ------------------------------------------------------------------------------------------------

-- persiapan dan isi data

-- Menambahkan data ke dalam tabel 'categories'
-- Menambahkan lima kategori
INSERT INTO categories(id, name)
VALUES ('C0001', 'Makanan'),
       ('C0002', 'Minuman'),
       ('C0003', 'Lain-Lain');

INSERT INTO categories(id, name)
VALUES ('C0004', 'Oleh-Oleh'),
       ('C0005', 'Gadget');

INSERT INTO products(id, name, price, quantity)
VALUES ('P0999', 'Yupi', 100, 10);

-- Mengupdate kolom 'id_category' di tabel 'products' untuk produk dengan ID tertentu
-- Menetapkan kategori 'Makanan' (C0001) untuk produk dengan ID P0001 hingga P0015 (sesuai dengan ID yang diberikan)
UPDATE products
SET id_category = 'C0001'
WHERE id IN ('P0001', 'P0002', 'P0003', 'P0004', 'P0005', 'P0006', 'P0013', 'P0014', 'P0015');

-- Mengupdate kolom 'id_category' di tabel 'products' untuk produk dengan ID tertentu
-- Menetapkan kategori 'Minuman' (C0002) untuk produk dengan ID P0007 hingga P0009
UPDATE products
SET id_category = 'C0002'
WHERE id IN ('P0007', 'P0008', 'P0009');

-- Mengupdate kolom 'id_category' di tabel 'products' untuk produk dengan ID tertentu
-- Menetapkan kategori 'Lain-Lain' (C0003) untuk produk dengan ID P0010 hingga P0016
UPDATE products
SET id_category = 'C0003'
WHERE id IN ('P0010', 'P0011', 'P0012', 'P0016');

-- Menampilkan seluruh data dari tabel 'categories' dan 'products'
-- Menggabungkan kedua tabel menggunakan INNER JOIN berdasarkan kecocokan 'id_category' di tabel 'products'
-- dengan 'id' di tabel 'categories'
SELECT *
FROM categories
         INNER JOIN products ON (products.id_category = categories.id);

-- Menampilkan seluruh data dari tabel 'categories' dan data yang cocok dari tabel 'products'
-- Menggunakan LEFT JOIN untuk memastikan semua kategori ditampilkan
-- Meskipun tidak ada produk yang terkait dengan kategori tersebut, data kategori tetap ditampilkan
SELECT *
FROM categories
         LEFT JOIN products ON (products.id_category = categories.id);

-- Menampilkan seluruh data dari tabel 'products' dan data yang cocok dari tabel 'categories'
-- Menggunakan RIGHT JOIN untuk memastikan semua produk ditampilkan
-- Meskipun tidak ada kategori yang terkait dengan produk tersebut, data produk tetap ditampilkan
SELECT *
FROM categories
         RIGHT JOIN products ON (products.id_category = categories.id);

-- Menampilkan hasil perkalian silang (cartesian product) antara tabel 'categories' dan 'products'
-- Setiap baris di tabel 'categories' akan dipasangkan dengan setiap baris di tabel 'products'
-- Tidak menggunakan kondisi penggabungan, sehingga jumlah baris hasil = jumlah baris categories × jumlah baris products
SELECT *
FROM categories
         CROSS JOIN products;

-- SUBQUERIES ------------------------------------------------------------------------------------------------

-- Menampilkan seluruh produk dari tabel 'products' yang memiliki harga di atas rata-rata
-- Menggunakan subquery untuk menghitung nilai rata-rata harga dari semua produk
-- Hanya produk dengan harga lebih tinggi dari nilai rata-rata tersebut yang ditampilkan
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Mengambil harga maksimum (MAX) dari hasil join antara tabel 'categories' dan 'products'
-- Subquery digunakan untuk mengambil semua harga (price) dari hasil INNER JOIN berdasarkan 'id_category'
-- Hasil subquery diberi alias 'cp', lalu fungsi agregat MAX digunakan pada kolom 'price'
SELECT MAX(price)
FROM (
    SELECT price
    FROM categories
    INNER JOIN products
    ON (products.id_category = categories.id)
) AS cp;












