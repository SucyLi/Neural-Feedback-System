public class GameLauncher {
	static int milliseconds;
	static boolean bActivate;
	
	public static void main(String[] args){
		Thread threadClinician = new ThreadClinician();	
		Thread threadGame = new ThreadGame();
		
		threadClinician.start();
		threadGame.start();
	}	
	
}
