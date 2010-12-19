
package king.kinect;

public class NativeKinect
{
	static 
	{
		System.loadLibrary("kinect");
	}
	
	private static native boolean initNative();
	private static native void setLedNative(int color);
	private static native void getVideoNative(int[] buf);
	private static native void getDepthMapNative(int[] buf);
	private static native void disposeNative();
	private static native void setVideoRGBNative();
	private static native void setVideoIRNative();	
	private static native void startNative();
	
	private static int[] rgb;
	private static int[] depthMap;
	
	public static boolean init()
	{
		boolean success = false;
		
		success = initNative();

		rgb = new int[640*480];
		depthMap = new int[640*480];

		return success;
	}
	
	public static void setLed(int color) {
		setLedNative(color);
	}
	
	public static int[] getVideo() {
		getVideoNative(rgb);
		return rgb;
	}
	
	public static int[] getDepthMap() {
		getDepthMapNative(depthMap);
		return depthMap;
	}

	public static void setVideoRGB() {
		setVideoRGBNative();
	}
	
	public static void setVideoIR() {
		setVideoIRNative();
	}
	
	public static void start() {
		startNative();
	}
	
	public void dispose() {
		disposeNative();
	}
	
}