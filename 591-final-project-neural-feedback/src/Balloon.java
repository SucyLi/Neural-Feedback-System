
public class Balloon {
	final float BALLOON_SPEED = 0.3f;
	final float BALLOON_FALL = 0.2f;
	final float BALLOON_SCALE = 0.1f;
	final int BALLOON_BOTTOM_LIMIT = SetupGame.SCREEN_Y - 100;
	int elevation;
	long elevationTimer;
	float x;
	float y;
	float speed;
	
	/*
	 * Balloon constructor that takes its position and speed
	 */
	public Balloon(int x, int y) {
		this.x = x;
		this.y = y;
		this.speed = BALLOON_SPEED;
		this.elevationTimer = 0;
	}
}
		
