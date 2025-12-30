TARGET_VERSION=8.3.243
TARGET_DIR=/Users/user/Downloads/cpp-sample-pipeline/libs/yolov8onnx/$TARGET_VERSION

mkdir -p $TARGET_DIR

cd $TARGET_DIR
wget -c https://github.com/ultralytics/ultralytics/archive/refs/tags/v${TARGET_VERSION}.tar.gz

tar -xvf v${TARGET_VERSION}.tar.gz
mv ultralytics-${TARGET_VERSION}/examples/YOLOv8-ONNXRuntime-CPP ./
mv YOLOv8-ONNXRuntime-CPP source
rm -r ultralytics-${TARGET_VERSION}