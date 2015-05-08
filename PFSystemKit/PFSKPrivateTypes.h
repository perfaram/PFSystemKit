//
//  PFSKPrivateTypes.h
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 03/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//
#ifndef PFSystemKit_PFSKPrivateTypes_h
#define PFSystemKit_PFSKPrivateTypes_h
#import "PFSKTypes.h"
#include <set>
#include <map>
#include <string>

constexpr CGFloat operator "" _MB(unsigned long long bytes)
{
	return static_cast<CGFloat>(bytes * 1048576);
}

inline int safe(int i)
{
	return i >= 0 ? i : -i;
}
 
std::map<int, char const*> PFSystemKitDeviceFamilyStrings = {
	{ PFSKDeviceFamilyUnknown, "Unknown" },
	{ PFSKDeviceFamilyiMac, "iMac" },
	{ PFSKDeviceFamilyMacMini, "Mac Mini" },
	{ PFSKDeviceFamilyMacPro, "Mac Pro" },
	{ PFSKDeviceFamilyMacBook, "MacBook" },
	{ PFSKDeviceFamilyMacBookAir, "MacBook Air" },
	{ PFSKDeviceFamilyMacBookPro, "MacBook Pro" },
	{ PFSKDeviceFamilyXserve, "XServe" },
	{ PFSKDeviceFamilyiPhone, "iPhone" },
	{ PFSKDeviceFamilyiPad, "iPad" },
	{ PFSKDeviceFamilyiPod, "iPod" },
	{ PFSKDeviceFamilySimulator, "Simulator" }
};

#endif
