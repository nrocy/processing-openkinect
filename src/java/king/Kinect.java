
import king.kinect.NativeKinect;

public class Kinect {
	public static void main( final String[] args ) {
		if( NativeKinect.init() ) {
			int[] buf = NativeKinect.getVideo();
			
			System.out.println( buf.length );
			
			System.out.println( "All good" );
		} 
	}
}
