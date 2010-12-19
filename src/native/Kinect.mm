//
//  Kinect.mm
//  Kinect
//
//  Created by Paul King on 30/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include "Kinect.h"

static freenect_context *ctx = nil;
static freenect_device *dev = nil;
static int device_number = 0;
static int num_devices = 0;

static uint8_t *rgb_buf = nil;
static uint16_t *depth_buf = nil;
static pthread_t freenect_thread;
static freenect_video_format current_format = FREENECT_VIDEO_RGB;

void *freenect_threadfunc(void *arg) {
	if( num_devices > 0 ) {
		freenect_set_video_format(dev, current_format);
		freenect_set_depth_format(dev, FREENECT_DEPTH_11BIT);

		freenect_set_video_buffer(dev, rgb_buf);
		freenect_set_depth_buffer(dev, depth_buf);
		
		freenect_start_video(dev);
		freenect_start_depth(dev);
		
		while(freenect_process_events(ctx) >= 0) {}
	}
	return NULL;
}

JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_setVideoRGBNative(JNIEnv *, jclass)
{
	current_format = FREENECT_VIDEO_RGB;
}

JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_setVideoIRNative(JNIEnv *, jclass)
{
	current_format = FREENECT_VIDEO_IR_8BIT;
}

JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_startNative(JNIEnv *, jclass)
{
	if(current_format == FREENECT_VIDEO_RGB )
		rgb_buf = (uint8_t *)malloc(FREENECT_VIDEO_RGB_SIZE);
	else
		rgb_buf = (uint8_t *)malloc(FREENECT_VIDEO_IR_8BIT_SIZE);
	
	depth_buf = (uint16_t *)malloc(FREENECT_DEPTH_11BIT_SIZE);
	
	if(pthread_create(&freenect_thread, NULL, freenect_threadfunc, NULL)) {
		fprintf(stderr,"ERR: pthread_create failed.\n");
	}	
}

JNIEXPORT jboolean JNICALL Java_king_kinect_NativeKinect_initNative(JNIEnv *, jclass)
{
	if(!ctx) 
		if( freenect_init(&ctx, NULL) < 0 ) {
			fprintf(stderr,"Failed to init libfreenect\n");
			return false;
		}
		
		num_devices = freenect_num_devices(ctx);
		fprintf(stderr, "Found %d device(s)\n", num_devices);
	
		if( !dev && num_devices > 0 ) {
			if( freenect_open_device(ctx, &dev, device_number) < 0 ) {
				fprintf(stderr, "Couldn't open device %d\n", device_number);
				return false;
			}
			else {
				fprintf(stderr, "Device %d initialised\n", device_number);
			}

			return true; 
		}

	return false;
}

// TODO: This can be removed once the algorithm for getVideo is updated to the correct-endianness (school boy error)
uint32_t flip( uint32_t d ) {
	uint8_t b1,b2,b3,b4;

	b1 = (d & 0xff000000) >> 24;
	b2 = (d & 0x00ff0000) >> 16;
	b3 = (d & 0x0000ff00) >> 8;
	b4 = (d & 0x000000ff);
	
	return (b4 << 24) + (b3 << 16) + (b2 << 8) + b1;
}

// TODO: Should really have a mutex around update/read buffers
JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_getVideoNative(JNIEnv *env, jclass, jintArray buf)
{
	jboolean is_copy = JNI_FALSE;
	jint *data = env->GetIntArrayElements(buf,&is_copy);

	uint32_t d;
	uint32_t rem1, rem2;
	
	int inofs = 0, outofs = 0;
	
	if(current_format == FREENECT_VIDEO_RGB ) {
		while( inofs < FREENECT_FRAME_PIX )	{
			d = ((uint32_t*)rgb_buf)[outofs++];
			d = flip(d);
			
			rem1 = d & 0xff;
			d = d >> 8;
			data[inofs++] = 0xff000000 | d;
			
			d = ((uint32_t*)rgb_buf)[outofs++];
			d = flip(d);

			rem2 = d & 0xffff;
			d = d >> 16;
			data[inofs++] = 0xff000000 | (rem1 << 16) | d; 

			d = ((uint32_t*)rgb_buf)[outofs++];
			d = flip(d);
			
			data[inofs++] = 0xff000000 | (rem2 << 8) | (d >> 24);
			data[inofs++] = 0xff000000 | d;
		}
	} else {
		for( int i = 0 ; i < FREENECT_FRAME_PIX ; i++ ) {
			d = ((uint8_t*)rgb_buf)[i];
			data[i] = d;
			data[i] = 0xff000000 | (d << 16) | (d << 8) | d;
		}
	}
	 
	env->ReleaseIntArrayElements(buf,data,0);
}

JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_getDepthMapNative(JNIEnv *env, jclass, jintArray buf)
{
	jboolean is_copy = JNI_FALSE;
	jint *data = env->GetIntArrayElements(buf,&is_copy);
	
	uint32_t ds = 0;	
	for(int i = 0 ; i < FREENECT_FRAME_PIX ; i++ ) {
		ds = depth_buf[i];
		// Experimental bodge to avoid dbz
		if( ds == 2048 )
			ds = 2047;
		
		ds = ((2048 * 256) / (2048 - ds)) & 0xff;
		ds = 256 - ds;
		data[i] = 0xff000000 | (ds << 16) | (ds << 8) | ds;
	}
	
	env->ReleaseIntArrayElements(buf,data,0);
}

JNIEXPORT void JNICALL Java_king_kinect_NativeKinect_setLedNative(JNIEnv *, jclass, jint color)
{
	freenect_set_led(dev, (freenect_led_options)color);
}
