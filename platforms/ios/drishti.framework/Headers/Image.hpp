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
//  Image.hpp
//  drishtisdk

#ifndef __drishtisdk__Image__
#define __drishtisdk__Image__

#include "drishti/drishti_sdk.hpp"
#include <cstdint>
#include <type_traits>
#include <stdlib.h>

_DRISHTI_SDK_BEGIN

/*
 * Vec types
 */

template <typename T, int D> struct Vec 
{ 
public:
    Vec() {}
    
    template <typename... Tail>
    Vec(typename std::enable_if<sizeof...(Tail)+1 == D, T>::type head, Tail... tail) : val{ head, T(tail)... } {}
    
    T & operator [](int i) { return val[i]; }
    const T & operator [](int i) const { return val[i]; }
protected:
    T val[D];
};

typedef Vec<uint8_t, 3> Vec3b;
typedef Vec<float, 2> Vec2f;
typedef Vec<float, 3> Vec3f;
typedef Vec<int, 2> Vec2i;
typedef Vec<int, 3> Vec3i;

/*
 * Image types
 */


template <typename T> class DRISHTI_EXPORTS Image
{
public:
    Image();
    Image(const Image &src);
    Image(size_t rows, size_t cols, T *data, size_t stride, bool keep = false);
    ~Image();
    size_t getRows() const { return rows; }
    size_t getCols() const { return cols; }
    size_t getStride() const { return stride; } // bytes
    template<typename T2> const T2* ptr() const { return reinterpret_cast<T2*>(data); }
    Image<T> clone();
protected:
    size_t rows = 0;
    size_t cols = 0;
    T *storage = 0, *data = 0;
    size_t stride = 0; // byte
};

typedef Image<uint8_t> Image1b;
typedef Image<Vec3b> Image3b;
typedef Image<float> Image1f;
typedef Image<Vec3f> Image3f;

_DRISHTI_SDK_END

#endif // __drishtisdk__Image__
