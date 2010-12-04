
package king.kinect;

public class NativeKinect
{
	static 
	{
		System.loadLibrary("kinect");
	}
	
	private static native boolean initNative();
	private static native void setLedNative(int color);
	private static native int[] getVideoNative(int[] buf);
	private static native int[] getDepthNative(int[] buf);
	
	private static int[] rgb;
	private static int[] depth;
	
	public static boolean init()
	{
		boolean success = false;
		
		if( (success = initNative()) ) {
		}

		rgb = new int[640*480];
		depth = new int[640*480];
		
		return success;
	}
	
	public static void setLed(int color) {
		setLedNative(color);
	}
	
	public static int[] getVideo() {
		return getVideoNative(rgb);
	}
	
	public static int[] getDepth() {
		return getDepthNative(depth);
	}
	
}