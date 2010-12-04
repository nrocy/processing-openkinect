
import king.kinect.*;

PImage img, depth;

void setup()
{
  size(1280, 480);
  
  NativeKinect.init();
  NativeKinect.start();
  
  img = createImage(640,480,RGB);
  depth = createImage(640,480,RGB);
}

void draw()
{
  img.pixels = NativeKinect.getVideo();
  img.updatePixels();
  image(img,0,0,640,480);

  depth.pixels = NativeKinect.getDepthMap();
  depth.updatePixels();
  image(depth,640,0,640,480);
}


