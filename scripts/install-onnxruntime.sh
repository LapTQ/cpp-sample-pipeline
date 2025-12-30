TARGET_VERSION=1.23.2
TARGET_DIR=/Users/user/Downloads/cpp-sample-pipeline/libs/onnxruntime

mkdir -p $TARGET_DIR

cd $TARGET_DIR
wget -c https://github.com/microsoft/onnxruntime/releases/download/v${TARGET_VERSION}/onnxruntime-osx-x86_64-${TARGET_VERSION}.tgz

tar -xvf onnxruntime-osx-x86_64-${TARGET_VERSION}.tgz
mv onnxruntime-osx-x86_64-${TARGET_VERSION} ${TARGET_VERSION}