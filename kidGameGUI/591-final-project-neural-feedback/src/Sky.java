
public class Sky {
	//sky
	float x;
	float y;
	
	public Sky(int x, int y) {
		this.x = x;
		this.y = y;
	}
	
	public void scroll() {
		this.x -= 0.1;
		
		if (this.x <= -SetupGame.SCREEN_X) {
			this.x = SetupGame.SCREEN_X;
		}
	}
}
