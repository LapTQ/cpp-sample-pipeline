#include "Loader.h"

#include <iostream>
#include <opencv2/videoio.hpp>
#include <string_view>

// constructor
app::Loader::Loader(std::string_view video_path) {
    m_cap = cv::VideoCapture{std::string(video_path)};

    if (!m_cap.isOpened()) {
        throw std::runtime_error("Could not open video");
    } else {
        std::cout << "Video opened successfully"
                  << "\n";
    }
}

bool app::Loader::read_frame(cv::Mat& frame) {
    bool ret = m_cap.read(frame);
    return ret;
}
