import java.util.InputMismatchException;
import java.util.Scanner;

public class HW6 {

	public static void main(String[] args) {
		int choice; // create a variable for the choice from user
		float[] answer = {0, 0};//initialize the array with two floats
		
		System.out.println("Welcome to sorting program");
		System.out.print("\n");
		System.out.println("          1. Title");
		System.out.println("          2. Rank");
		System.out.println("          3. Date");
		System.out.println("          4. Stars");
		System.out.println("          5. Likes");
		
		System.out.print("\n");
		System.out.print("\n");
		
		Scanner GetInput = new Scanner (System.in); //create a scanner 
		
		choice = getUserChoice(GetInput);//pass the scanner to the method getUserChoice 
		
		System.out.print("\n");
		System.out.printf("You entered valid choice %d\n", choice);
		System.out.println("Thank you for giving your choice\n");
		
		
		System.out.println("Welcome to bonus get two floats program");
		
		answer = getTwoFloats(GetInput, answer);//pass the scanner to the method getTwoFloats 
		
		System.out.printf("You entered %.2f and  %.2f successfully!\n", answer[0], answer[1]);
		System.out.print("\n");
		System.out.println("	Press enter key to continue ...\n");
		
	}
		
		// Assignment 6.1 
	static int getUserChoice(Scanner var){			
		int num; 
		int tmp;
		int [] choice = {1, 2, 3, 4, 5};
		
		do {
			System.out.print("Enter your choice between 1 and 5 only: ");
			num = 0;
			try{
				num = var.nextInt(); // read the variable entered by user
				tmp = choice[num-1]; // see if the input choice is out of bound 
			} catch (InputMismatchException e) {
				System.out.println("You have entered an invalid choice. Try again."); // if var not number, then output this exception
			} catch (ArrayIndexOutOfBoundsException e) {
				System.out.println("You have not entered a number between 1 and 5. Try again.");// if var out of bound, then output this exception
			}
			
			var.nextLine();//clear the scanner
			
		} while ((num > 5) || (num < 1));
		
		return num;
		
	}
	
	//Assignment 6.2
	static float[] getTwoFloats(Scanner var, float[] tempArray){		
		Float firstN = null; 
		Float secondN = null;
		
		
		System.out.print("\n");
		
		do{
			System.out.printf("Enter two floats separated by a space: ");
			try {
				firstN = var.nextFloat();
				secondN = var.nextFloat();
			} catch (InputMismatchException e) {
				System.out.println("You have entered an invalid input. Try again.");
			} 
			
			var.nextLine(); // clear the scanner 
			
		} while ((firstN == null) || (secondN == null)) ;
		
		tempArray[0] = firstN; //add the first input var to array
		tempArray[1] = secondN;//add the second input var to array
		
       return tempArray;
	}
}
