import java.util.Scanner;
import java.util.InputMismatchException;

public class HW5 {

	public static void main(String[] args) {
		// Assignment 5.1
		System.out.println("Welcome to sorting program");
		System.out.print("\n");
		System.out.println("          1. Title");
		System.out.println("          2. Rank");
		System.out.println("          3. Date");
		System.out.println("          4. Stars");
		System.out.println("          5. Likes");
		
		System.out.print("\n");
		System.out.print("\n");
		
		
		int [] choice = {1, 2, 3, 4, 5};//intialize 5 elements in an array
		int num;
		int tmp;
		
		
		do {
			System.out.print("Enter your choice between 1 and 5 only: ");
			num = 0; // initialize num variable to 0
			try{
				Scanner readInput = new Scanner (System.in);//initialize scanner every single time
				num = readInput.nextInt(); // read the variable entered by user
				tmp = choice[num-1]; // if the var is a num
			} catch (InputMismatchException e) {
				System.out.println("You have entered an invalid choice. Try again."); // if var not number, then output this exception
			} catch (ArrayIndexOutOfBoundsException e) {
				System.out.println("You have not entered a number between 1 and 5. Try again."); // if var out of bound, then output this exception
			}
		} while ((num > 5) || (num < 1));
		
		System.out.print("\n");
		System.out.printf("You entered valid choice %d\n", num);
		System.out.println("Thank you for giving your choice\n");
	
		
		//Assignment 5.2	
		System.out.println("Welcome to get two floats program");
		
		Float firstN = null; 
		Float secondN = null;
		
		
		System.out.print("\n");
		
		do{
			System.out.printf("Enter two floats separated by a space: ");
			try {
				Scanner readInput = new Scanner (System.in);
				firstN = readInput.nextFloat();
				secondN = readInput.nextFloat();
			} catch (InputMismatchException e) {
				System.out.println("You have entered an invalid input. Try again.");
			} 
		} while ((firstN == null) || (secondN == null)) ;
		
		System.out.print("\n");
		System.out.printf("You entered two valid floats: %.1f and %.1f\n", firstN, secondN);
		System.out.println("Thank you for giving two floats\n");

		
		//Assignment 5.3
		int weeklyTemp [] =  {69, 70, 71, 68, 66, 71, 70 };
		int i, max = 0, min = 0;
		float total = 0, average;
		
        //print the daily temperatures 
		int day;
		for (day = 0; day < weeklyTemp.length; day++) 
			System.out.printf("The temperature on day %d was %d:\n", day+1, weeklyTemp[day]);
		
		
		System.out.print("\n");
		//Find and print the minimum and maximum temperature of the week
		min = weeklyTemp[0];
		for (day = 0; day < weeklyTemp.length; day++) {
			if (min > weeklyTemp[day])
				min = weeklyTemp[day];
		}
		System.out.printf("The Minimum temperature is: %d\n", min);
		

		max = weeklyTemp[0];
		for (day = 0; day < weeklyTemp.length; day++) {
			if (max <= weeklyTemp[day]) 
				max = weeklyTemp[day];
		} 
		System.out.printf("The Maximum temperature is: %d\n", max);
		
			
		
		//calculate and print the average temperature of the week
		for (day = 0; day < weeklyTemp.length; day++) {
			total += weeklyTemp[day];	
		}

		System.out.printf("The average temperature for the week is: %7.5f\n", total / 7);
		
		System.out.print("\n");
		System.out.print("Thank you for using my homework #5 solution");		
		
	}

}

