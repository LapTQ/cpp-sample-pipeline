#ifndef LOADER_H
#define LOADER_H

#include <opencv2/videoio.hpp>
#include <string>
#include <string_view>

namespace app {
class Loader {
private:
    cv::VideoCapture m_cap {};

   public:
    Loader(std::string_view video_path);  // For function parameters, prefer std::string_view over const std::string&
    bool read_frame(cv::Mat& frame);
    
    // Rule of three. Tạm thời cho đơn giản thì cấm copy
    Loader(const Loader&) = delete;
    Loader& operator=(const Loader&) = delete;

    // không cần m_cap.release() vì bản thân VideoCapture (không phải con trỏ) đã tuân thủ RAII
};
}  // namespace app
#endif