# OpenKinect library for Processing

Currently OSX only, please feel free to help remove that dependency.

### Methods available:

NativeKinect.init() - _initialize the Kinect_<br />
NativeKinect.setVideoIR() - _output RGB video (default)_<br />
NativeKinect.setVideoIR() - _output IR video_<br />
NativeKinect.start() - _tell the Kinect to start streaming data to the library_<br />
NativeKinect.getVideo() - _pull the latest video frame_<br />
NativeKinect.getDepthMap() - _pull the latest depthMap frame_<br />
NativeKinect.setLed(int) - _change the Kinect LED colour (0-6)_

### Example:

	import king.kinect.*;

	PImage img, depth;

	void setup()
	{
		size(1280, 480);
		
		img = createImage(640,480,RGB);
		depth = createImage(640,480,RGB);
		
		NativeKinect.init();
		NativeKinect.start();
	}

	void draw()
	{
		img.pixels = NativeKinect.getVideo();
		img.updatePixels();

		depth.pixels = NativeKinect.getDepthMap();
		depth.updatePixels();

		image(img,0,0,640,480);
		image(depth,640,0,640,480);
	}

### Build Requirements:

Processing on OSX doesn't support 64-bit, so build the libraries as 32-bit.

- libusb built as per libfreenect instructions (as a 32-bit library)
- libfreenect (built as a 32-bit library)

### Build Instructions:

Coming soon.

### TODO:

- Add prebuild Processing library with all dependencies
- Implement motor control methods
- Implement accelerometer methods
- Remove OSX/XCode specific dependencies

