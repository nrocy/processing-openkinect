//
//  Kinect.mm
//  Kinect
//
//  Created by Paul King on 30/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Kinect.h"
#import <JavaNativeFoundation/JavaNativeFoundation.h>

@implementation Kinect

JNIEXPORT jint JNICALL Java_king_kinect_NativeKinect_initNative(JNIEnv *, jclass)
{
	return 0;
}

JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_setLedNative(JNIEnv *, jclass, jint color)
{
	freenect_context *ctx;
	freenect_device *dev;

	if( freenect_init(&ctx, NULL) < 0 ) {
		NSLog( @"Failed to init kinect" );
	} else {
		NSLog( @"%d devices found", freenect_num_devices(ctx) );
	}
	
	if( freenect_open_device(ctx, &dev, 0) < 0 ) {
		NSLog( @"Couldn't open device" );
	} else {
		NSLog( @"Device opened" );
		freenect_set_led(dev, (freenect_led_options)color);
	}
}

@end
