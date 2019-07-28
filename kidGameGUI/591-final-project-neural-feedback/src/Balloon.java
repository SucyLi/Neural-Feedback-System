
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
	
	public Balloon(int x, int y) {
		this.x = x;
		this.y = y;
		this.speed = BALLOON_SPEED;
		this.elevationTimer = 0;
	}
	
//	public void move() {
//		//only allow movement that does not cause balloon to go off screen
//		if ((this.y < BALLOON_BOTTOM_LIMIT) && (this.y > 0)){
//			this.y -= this.speed;
//			elevation += 1;
//		}
//		else if (this.y <= 0){
//			this.y += this.speed;
//		}
//	}
//	
//	public void fall() {
//		this.y += this.BALLOON_FALL;
//	}
}
		
