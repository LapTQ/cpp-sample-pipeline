g++ \
  -I/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/include/opencv4 \
  -L/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib \
  -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_videoio -lopencv_imgcodecs \
  -I/Users/user/Downloads/cpp-sample-pipeline/libs/onnxruntime/1.23.2/include \
  -L/Users/user/Downloads/cpp-sample-pipeline/libs/onnxruntime/1.23.2/lib \
  -lonnxruntime \
  -I/Users/user/Downloads/cpp-sample-pipeline/libs/yolov8onnx/8.3.243/source \
  -lopencv_dnn \
  -std=c++17 \
  -I/Users/user/Downloads/cpp-sample-pipeline/include \
  -o /Users/user/Downloads/cpp-sample-pipeline/outputs/trivials/run_detection \
  /Users/user/Downloads/cpp-sample-pipeline/apps/run_detection.cpp \
  /Users/user/Downloads/cpp-sample-pipeline/src/**.cpp \
  /Users/user/Downloads/cpp-sample-pipeline/libs/yolov8onnx/8.3.243/source/inference.cpp

# Trên macOS, biến môi trường là DYLD_LIBRARY_PATH chứ KHÔNG phải LD_LIBRARY_PATH (của Linux)
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib:/Users/user/Downloads/cpp-sample-pipeline/libs/onnxruntime/1.23.2/lib

/Users/user/Downloads/cpp-sample-pipeline/outputs/trivials/run_detection