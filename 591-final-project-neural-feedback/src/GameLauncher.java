import java.util.Timer;
import java.util.TimerTask;

public class GameLauncher {
	static int milliseconds;
	static boolean bActivate;
	
	public static void main(String[] args){
		
		Thread threadClinician = new Thread(new ThreadClinician());
		Thread threadGame = new Thread(new ThreadGame());
	
		
		Timer timer = new Timer();
		
		TimerTask timerTask = new TimerTask() {
	        @Override
	        public void run() { 
	            bActivate = true;
	        }
	    };
	    
	    //this gets set for only one loop of main, need to make sure all
	    //sub-loops that require bActivate are hit.
		timer.scheduleAtFixedRate(timerTask, 2432, 1);
		
		threadClinician.start();
		threadGame.start();
	}	
	
}
