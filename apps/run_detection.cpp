
#include <onnxruntime_cxx_api.h>

#include <opencv2/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <vector>

#include "Config.h"
#include "Loader.h"
#include "inference.h"

int main() {
    app::Config config{};
    config.video_path =
        "/Users/user/Downloads/code-shoplift-record/day2/cuongdh--Basket_carry_by_hand--Handbag--back--standing.mp4";
    config.model_path = "/Users/user/Downloads/cpp-sample-pipeline/outputs/yolo11n.onnx";

    app::Loader loader{config.video_path};

    YOLO_V8* detector{new YOLO_V8};

    detector->classes = {
        "person",        "bicycle",    "car",           "motorbike",     "aeroplane",    "bus",
        "train",         "truck",      "boat",          "traffic light", "fire hydrant", "stop sign",
        "parking meter", "bench",      "bird",          "cat",           "dog",          "horse",
        "sheep",         "cow",        "elephant",      "bear",          "zebra",        "giraffe",
        "backpack",      "umbrella",   "handbag",       "tie",           "suitcase",     "frisbee",
        "skis",          "snowboard",  "sports ball",   "kite",          "baseball bat", "baseball glove",
        "skateboard",    "surfboard",  "tennis racket", "bottle",        "wine glass",   "cup",
        "fork",          "knife",      "spoon",         "bowl",          "banana",       "apple",
        "sandwich",      "orange",     "broccoli",      "carrot",        "hot dog",      "pizza",
        "donut",         "cake",       "chair",         "sofa",          "pottedplant",  "bed",
        "diningtable",   "toilet",     "tvmonitor",     "laptop",        "mouse",        "remote",
        "keyboard",      "cell phone", "microwave",     "oven",          "toaster",      "sink",
        "refrigerator",  "book",       "clock",         "vase",          "scissors",     "teddy bear",
        "hair drier",    "toothbrush"};
    DL_INIT_PARAM params{};
    params.rectConfidenceThreshold = 0.1;
    params.iouThreshold            = 0.5;
    params.modelPath               = config.model_path;
    params.imgSize                 = {640, 640};
    params.modelType               = YOLO_DETECT_V8;
    params.cudaEnable              = false;

    detector->CreateSession(params);

    cv::Mat    frame;
    cv::Scalar color{0, 255, 0};
    while (true) {
        bool ret = loader.read_frame(frame);
        if (!ret) {
            break;
        }

        std::vector<DL_RESULT> result{};
        detector->RunSession(frame, result);

        for (auto& object : result) {
            if (object.classId != 0) {
                continue;
            }
            cv::rectangle(frame, object.box, color, 3);
        }

        cv::imshow("Video", frame);
        if (cv::waitKey(1) == 27) {
            break;
        }
    }

    return 0;
}