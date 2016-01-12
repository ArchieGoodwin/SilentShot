//===-- EvpEventDelegate.hpp - EvpEventDelegate class definition -------*- C++ -*-===//
//
//                     EyeVerify Codebase
//
//===----------------------------------------------------------------------===//
///
/// @file
/// @brief This file contains the declaration of the EvpEventDelegate class.
///
//===----------------------------------------------------------------------===//

#import <evp/EvpEventDispatch.h>
#import <evp/WebServiceProcessor.h>

using evp::EvpEventSubscription;
using evp::EvpPublisherSubscriber;

class EvpEventDelegate :
public EvpPublisherSubscriber,
public evp::WebServiceDelegate
{
public:
    EvpEventDelegate();
    
    virtual void initialize() {}
    virtual void handleEvent(evp::EvpEvent* event);
    
    virtual void handleWebService(const std::string & address,
                                  int timeout,
                                  std::vector <std::pair <std::string, std::string> >& request_params,
                                  const std::vector<unsigned char>& request_data,
                                  std::vector<unsigned char>& response_data);
    virtual const char* getClassName() const { return "EvpEventDelegate"; }
};
