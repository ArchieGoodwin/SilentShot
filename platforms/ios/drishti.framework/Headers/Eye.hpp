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
//  Eye.hpp
//  drishtisdk

#ifndef __drishtisdk__Eye__
#define __drishtisdk__Eye__

#include "drishti/drishti_sdk.hpp"
#include "drishti/drishti_sdk.hpp"
#include "drishti/Image.hpp"

#include <vector>
#include <iostream>

_DRISHTI_SDK_BEGIN

/*
 * Eye type
 */

class DRISHTI_EXPORTS Eye
{
public:
    struct Ellipse
    {
        Vec2f center = {0.f,0.f};
        Vec2f size = {0.f,0.f};
        float angle = 0.f;
    };

    Eye();
    Eye(const Eye &src);
    
    void setIris(const Ellipse &src) { iris = src; }
    void setPupil(const Ellipse &src) { pupil = src; }
    void setMask(const Image1b &src) { mask = src; }
    void setEyelids(const std::vector<Vec2f>& src) { eyelids = src; }
    void setCorners(const Vec2f &inner, const Vec2f &outer) { innerCorner = inner; outerCorner = outer; }
    void setSize(const Vec2i &dimensions) { size = dimensions; }
    
    const Ellipse& getIris() const { return iris; }
    const Ellipse& getPupil() const { return pupil; }
    const Image1b &getMask() const { return mask; }
    const std::vector<Vec2f> &getEyelids() const { return eyelids; }
    const Vec2f & getInnerCorner() const { return innerCorner; }
    const Vec2f & getOuterCorner() const { return outerCorner; }
    const Vec2i & getSize() const { return size; }
    
protected:
    Image1b mask;
    
    Ellipse iris;
    Ellipse pupil;
    std::vector<Vec2f> eyelids;
    Vec2f innerCorner;
    Vec2f outerCorner;
    Vec2i size;
};

struct DRISHTI_EXPORTS EyeStream
{
    enum Format { XML, JSON };
    EyeStream(const Eye &eye, Format format) : eye(eye), format(format) {}
    std::string ext() const;
    const Eye &eye;
    Format format = XML;
};

std::ostream& operator<<(std::ostream &os, const EyeStream &eye) DRISHTI_EXPORTS;

_DRISHTI_SDK_END
 
#endif // __drishtisdk__Eye__

