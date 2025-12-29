#include <stdio.h>

#include <opencv2/opencv.hpp>

using namespace cv;

int main(int argc, char** argv) {
    Mat image;
    image = imread("/Users/user/Downloads/diffusion-scale-1.png", IMREAD_COLOR);

    if (!image.data) {
        printf("No image data \n");
        return -1;
    }
    namedWindow("Display Image", WINDOW_AUTOSIZE);
    imshow("Display Image", image);

    waitKey(0);

    return 0;
}
