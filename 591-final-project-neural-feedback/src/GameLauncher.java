public class GameLauncher {
	
	/**
	 * This main method is to launch the game
	 * @param args
	 * @throws InterruptedException
	 */
	public static void main(String[] args) throws InterruptedException{
		Thread threadGame = new ThreadGame();
		threadGame.start();
	}	
	
}
