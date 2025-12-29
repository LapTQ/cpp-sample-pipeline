# g++ /Users/user/Downloads/cpp-sample-pipeline/drafts/d2.cpp -o /Users/user/Downloads/cpp-sample-pipeline/outputs/trivials/d2 \
#   -I/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/include/opencv4 \
#   -L/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib \
#   -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_videoio -lopencv_imgcodecs \
#   -std=c++17 \

# # Trên macOS, biến môi trường là DYLD_LIBRARY_PATH chứ KHÔNG phải LD_LIBRARY_PATH (của Linux)
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib

# /Users/user/Downloads/cpp-sample-pipeline/outputs/trivials/d2


cd /Users/user/Downloads/cpp-sample-pipeline/outputs/trivials
cmake /Users/user/Downloads/cpp-sample-pipeline/drafts -D OpenCV_DIR=/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib/cmake/opencv4
make
/Users/user/Downloads/cpp-sample-pipeline/outputs/trivials/d2
