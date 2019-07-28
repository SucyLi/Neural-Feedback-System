
public class DataProcessor {
	
	//check if the game is using data
	//this should check if data is properly loaded and if so, return true
	//can also add an option in the main menu asking the player whether to use data or input when data is loaded
	public boolean isUsingData() {
		return false;
	}
	
	//should return true if input was successful
	//this runs every frame so should only return data every once in a while
	public boolean getData() {
		return true;
	}
}
