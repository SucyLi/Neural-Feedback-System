public class GameLauncher {
	static int milliseconds;
	static boolean bActivate;
	
	public static void main(String[] args) throws InterruptedException{
		Thread threadClinician = new ThreadClinician();	
		Thread threadGame = new ThreadGame();
		
		threadClinician.start();
		Thread.sleep(6000);
		threadGame.start();
	}	
	
}
