TARGET_DIR=/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest

mkdir -p $TARGET_DIR

sudo apt update
sudo apt install -y g++ cmake make git libgtk2.0-dev pkg-config

cd $TARGET_DIR
git clone https://github.com/opencv/opencv.git source       # đổi tên thành source cho dễ phân biệt với 2 thư mục build và install

mkdir -p build
cd build

# cờ -D CMAKE_INSTALL_PREFIX chỉ định thư mục cài đặt ở bước `make install`
cmake -D CMAKE_INSTALL_PREFIX=$TARGET_DIR/install \
    ../source

make -j4

make install
