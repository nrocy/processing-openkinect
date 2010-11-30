
package king.kinect;

public class NativeKinect
{
	static 
	{
		System.loadLibrary("kinect");
	}
	
	private static native int initNative();
	private static native void setLedNative(int color);
	
	public static int init()
	{
		return initNative();
	}
	
	public static void setLed(int color)
	{
		setLedNative(color);
	}
}