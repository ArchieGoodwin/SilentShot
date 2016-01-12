//===-- WebService.hpp - WebService class definition --------===//
//
// EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the WebService class.
///
//===----------------------------------------------------------------------===//

#import "WebService.h"

#include <opencv2/core.hpp>

#import <Foundation/Foundation.h>

class WebService {
    
public:
    static void execute(const std::string& address, const int timeout, const std::vector <std::pair <std::string, std::string> >& request_params, const std::vector<uchar>& request_data, std::vector<unsigned char>& response_data);
    
};
