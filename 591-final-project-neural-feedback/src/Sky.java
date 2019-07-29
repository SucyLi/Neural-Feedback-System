
public class Sky {
	final float SCROLL_SPEED = 0.3f;
	//sky
	float x;
	float y;
	
	public Sky(int x, int y) {
		this.x = x;
		this.y = y;
	}
	
	public void scroll(int mod) {
		this.y += SCROLL_SPEED * mod;
		
		if (this.y >= SetupGame.SCREEN_Y) {
			this.y =  ((-SetupGame.SKY_DIMENSION_Y * 2) + SetupGame.SCREEN_Y);
		}
	}
}
