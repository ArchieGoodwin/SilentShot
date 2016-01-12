// Elucideye, Inc. ("COMPANY") CONFIDENTIAL
// Unpublished Copyright (c) 2015 Elucideye, Inc.
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of COMPANY. The intellectual and technical concepts
// contained herein are proprietary to COMPANY and may be covered by
// U.S. and Foreign Patents, patents in process, and are protected by
// trade secret or copyright law.  Dissemination of this information
// or reproduction of this material is strictly forbidden unless prior
// written permission is obtained from COMPANY.  Access to the source
// code contained herein is hereby forbidden to anyone except current
// COMPANY employees, managers or contractors who have executed
// Confidentiality and Non-disclosure agreements explicitly covering
// such access.
//
// The copyright notice above does not evidence any actual or intended
// publication or disclosure of this source code, which includes
// information that is confidential and/or proprietary, and is a trade
// secret, of COMPANY.  ANY REPRODUCTION, MODIFICATION, DISTRIBUTION,
// PUBLIC PERFORMANCE, OR PUBLIC DISPLAY OF OR THROUGH USE OF THIS
// SOURCE CODE WITHOUT THE EXPRESS WRITTEN CONSENT OF COMPANY IS
// STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE LAWS AND
// INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF THIS SOURCE
// CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
// TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO
// MANUFACTURE, USE, OR SELL ANYTHING THAT IT MAY DESCRIBE, IN WHOLE
// OR IN PART.
//
//  drishti_cv.hpp
//  drishtisdk

#ifndef __drishtisdk__cv__
#define __drishtisdk__cv__

// TODO: preprocessor test for opencv?

#include "drishti/Image.hpp"
#include "drishti/drishti_sdk.hpp"
#include "drishti/Eye.hpp"

#include <algorithm>

_DRISHTI_SDK_BEGIN

template <typename T1, typename T2>
cv::Mat_<T2> drishtiToCv(const Image<T1> &src)
{
    return cv::Mat_<T2>(int(src.getRows()), int(src.getCols()), const_cast<T2*>(src.template ptr<T2>()), src.getStride());
}

template <typename T1, typename T2>
Image<T2> cvToDrishti(const cv::Mat_<T1> &src)
{
    return Image<T2>(src.rows, src.cols, const_cast<T2*>(src.template ptr<T2>()), src.step[0]);
}

inline cv::Point2f drishtiToCv(const drishti::sdk::Vec2f &v) { return cv::Point2f(v[0], v[1]); }

inline drishti::sdk::Vec2f cvToDrishti(const cv::Point2f &p) { return drishti::sdk::Vec2f(p.x, p.y); }

inline cv::RotatedRect drishtiToCv(const drishti::sdk::Eye::Ellipse &src)
{
    cv::RotatedRect ellipse;
    ellipse.center = { src.center[0], src.center[1] };
    ellipse.size = { src.size[0], src.size[1] };
    ellipse.angle = src.angle * 180.f / float(M_PI);
    return ellipse;
}

inline drishti::sdk::Eye::Ellipse cvToDrishti(const cv::RotatedRect &src)
{
    drishti::sdk::Eye::Ellipse ellipse;
    ellipse.center = { src.center.x, src.center.y };
    ellipse.size = { src.size.width, src.size.height };
    ellipse.angle = src.angle * float(M_PI) / 180.f;
    return ellipse;
}

_DRISHTI_SDK_END

#endif // __drishtisdk__cv__
