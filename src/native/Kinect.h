//
//  Kinect.h
//  Kinect
//
//  Created by Paul King on 30/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JavaNativeFoundation/JavaNativeFoundation.h>

#include "king_kinect_NativeKinect.h"

#include "libfreenect.h"

@interface Kinect : NSObject {
	freenect_context *ctx;
	freenect_device *dev;
}

@end
