import org.newdawn.slick.Image;

public class Balloon {
	final static float BALLOON_SPEED = 0.3f;
	final float BALLOON_FALL = 0.2f;
	final float BALLOON_SCALE = 0.1f;
	final int BALLOON_BOTTOM_LIMIT = SetupGame.SCREEN_Y - 100;
	int elevation;
	//allows elevation to be incremented over time instead of per frame
	long elevationTimer;
	float x;
	float y;
	float speed;
	float scale;
	Image img;
	
	
	public Balloon(int x, int y, float speed, float scale, Image img) {
		this.x = x;
		this.y = y;
		this.speed = speed;
		this.elevationTimer = 0;
		this.scale = scale;
		this.img = img;
	}
}
		
