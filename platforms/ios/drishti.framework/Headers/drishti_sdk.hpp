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
//  drishti_sdk.hpp
//  drishtisdk

#ifndef __drishtisdk__SDK__
#define __drishtisdk__SDK__

#if (defined WIN32 || defined _WIN32 || defined WINCE || defined __CYGWIN__) && defined CVAPI_EXPORTS
#  define DRISHTI_EXPORTS __declspec(dllexport)
#elif (defined __GNUC__ && __GNUC__ >= 4) || defined(__clang__)
#  define DRISHTI_EXPORTS __attribute__ ((visibility ("default")))
#else
#  define DRISHTI_EXPORTS
#endif

#define _DRISHTI_BEGIN namespace drishti { 
#define _DRISHTI_END }

#define _DRISHTI_SDK_BEGIN _DRISHTI_BEGIN namespace sdk {
#define _DRISHTI_SDK_END _DRISHTI_END }

#include <string> // move out

int getMajorVersion();
int getMinorVersion();
int getPatchVersion();
std::string getVersion();

#endif // __drishtisdk__SDK__
