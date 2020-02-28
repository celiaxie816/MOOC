
import java.util.InputMismatchException;
import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;

public class Calculator {

	public static void main(String[] args) {
		int choice;// create an int var for the choice input from user
		Map dict = new HashMap();// create a dictionary to match user choice and operator name
		float[] answer = { 0, 0 };// initialize the array with two floats
		String res = "";// for testing whether user press enter to continue

		// put key and values into the dictionary
		dict.put(1, "add");
		dict.put(2, "subtract");
		dict.put(3, "multiply");
		dict.put(4, "divide");

		do {
			System.out.println("Welcome to <Sisi Xie's> Handy Calculator\n");
			System.out.println("\n\t1. Addition\n\t2. Subtraction\n\t3. Multiplication\n\t4. Division\n\t5. Exit\n\n");

			System.out.print("What would you like to do? ");
			Scanner GetInput = new Scanner(System.in);
			choice = getUserChoice(GetInput);// assign the input from user to the integer variable 'choice'

			System.out.println("\n");

			// if choice smaller than 5, then continue to get two floats, otherwise print
			// the ending words
			if (choice < 5) {
				System.out.print("Please enter two floats to " + dict.get(choice) + " separated by a space:");// get choice from getUserChoice method and ask user to give two floats
				answer = getTwoFloats(GetInput, answer, choice);//pass scanner,initialized answer array{0,0} and input choice to the method to get 2 valid floats from users 
				getResult(choice, answer[0], answer[1]);//pass answer choice and two floats to print the operation results from two floats
				System.out.println("\nPress enter key to continue....");
				res = GetInput.nextLine();// press enter to continue
			} else {
				System.out.println("Thank you for using <Sisi Xie's> Handy Calculator");
		        GetInput.close();//done with the scanner, safely close it
			}

		} while (choice < 5);//as long as user does not choose 5 to exit, repeat the process in the loop
		
	}

	// get choice from user
	static int getUserChoice(Scanner var) {
		int num;
		int tmp;
		int[] choice = { 1, 2, 3, 4, 5 };

		do {
			num = 0;
			try {
				num = var.nextInt(); // read the variable entered by user
				tmp = choice[num - 1]; // see if the input choice is out of bound
			} catch (InputMismatchException k) {
				System.out.println("You have entered an invalid choice. Try again."); // if the input from user is not an integer, then output this exception
			} catch (ArrayIndexOutOfBoundsException k) {
				System.out.println("You have not entered a number between 1 and 5. Try again.");// if the integer out of range from 1 to 5, then output this exception
			}

			var.nextLine();// clear the buffer

		} while ((num > 5) || (num < 1)); // if user enters invalid choice like characters or integers out of bound, repeat the process in the loop

		return num;
	}

	//create a method get two valid floats from users 
	static float[] getTwoFloats(Scanner var, float[] tempArray, int num) {
		Float firstN = null; // initialize the first float input from user
		Float secondN = null;// initialize the second float input from user
		int result; // create a variable for the case when the second float = 0
		int tmp = 1;// create a temp variable for firstN when the second float = 0, since only float / float(0) will not thrown an exception, only int / int(0) type will do.
		int temp = 1;// create a temp variable for secondN when the second float = 0, since only float / float(0) will not thrown an exception, only int / int(0) type will do.

		// handle the user choice with two scenarios: smaller than 4 and equal to 4
		if (num < 4) {
			do {
				try {
					firstN = var.nextFloat();
					secondN = var.nextFloat();
				} catch (InputMismatchException k) {
					System.out.println("You have entered an invalid input. please re-enter.");
				}

				var.nextLine(); // clear the scanner

			} while ((firstN == null) || (secondN == null));
		} else if (num == 4) {
			do {
				try {
					firstN = var.nextFloat();
					secondN = var.nextFloat();
					if (secondN == 0.0) // when the second input = 0
						temp = Math.round(firstN);// turn the first input to integer
					tmp = Math.round(secondN);// turn the second input to integer
					result = temp / tmp;// provoke the arithmeticException, note that float / float(0) will not thrown an exception, only int / int(0) type will do.
				} catch (InputMismatchException e) {
					System.out.print("You have entered an invalid floats. please re-enter:");// when input is char, prop this error
				} catch (ArithmeticException e) {
					System.out.print("You can't divide by zero please re-enter both floats:");// when the second input = 0, prop this error
				}

				var.nextLine(); // clear the scanner

			} while ((firstN == null) || (secondN == null) || (secondN == 0)); // if the user enters characters or invalid ints, repeat the process in loop
		}

		tempArray[0] = firstN; // add the first input float to temparray
		tempArray[1] = secondN;// add the second input float to temparray
		return tempArray;//return the two floats input array

	}

	// method for printing the operation result, pass userchoice and two floats inputs to conduct the operation.
	static void getResult(int num, float a, float b) {
		if (num == 1) {
			System.out.printf("Result of adding %.2f and %.2f is %.2f.\n", a, b, a + b);
		} else if (num == 2) {
			System.out.printf("Result of subtracting %.2f and %.2f is %.2f.\n", a, b, a - b);
		} else if (num == 3) {
			System.out.printf("Result of multiplying %.2f and %.2f is %.2f.\n", a, b, a * b);
		} else {
			System.out.printf("Result of dividing  %.2f and %.2f is %.2f.\n", a, b, a / b);
		}
	}

}
