import java.util.HashMap;
import java.util.InputMismatchException;
import java.util.Map;
import java.util.Scanner;

public class OOPCalculator {

	private int menuChoice;//create a global variable of menuchoice
	private float firstFloat = Integer.MAX_VALUE;//initialize firstfloat
	private float secondFloat = Integer.MAX_VALUE;//initialize secondfloat
	private int[] choice = { 1, 2, 3, 4, 5 };//for evaluating whether the Menuchoice given by user is out of bound
	private Scanner getInput = new Scanner(System.in);//create scanner getInput

	public OOPCalculator() {

	}

	public int askCalcChoice() {
		String str_choice;
		int check_choice;
		Map menuDict = new HashMap();//to match user input to menu options
		menuDict.put("a", 1);
		menuDict.put("s", 2);
		menuDict.put("m", 3);
		menuDict.put("d", 4);
		menuDict.put("x", 5);
		menuDict.put("1", 1);
		menuDict.put("2", 2);
		menuDict.put("3", 3);
		menuDict.put("4", 4);
		menuDict.put("5", 5);

		System.out.println("\nWelcome to <Sisi Xie's> Handy Calculator\n");
		System.out.println("\n\t1. Addition\n\t2. Subtraction\n\t3. Multiplication\n\t4. Division\n\t5. Exit");

		System.out.print("\tWhat would you like to do? ");

		do {
			menuChoice = 0;
			try {
				str_choice = getInput.nextLine();
				menuChoice = (int) menuDict.get(str_choice.toLowerCase());

				check_choice = choice[menuChoice - 1]; // see if the input choice is out of bound
			} catch (NullPointerException e) {
				System.out.print("\n\tYou have entered invalid input. Try again:");// see if user input is invalid
																						
			}

		} while ((menuChoice > 5) || (menuChoice < 1)); // if user enters invalid choice like characters or integers out of bound, repeat the process in the loop

		return menuChoice;

	}

	public void askTwoValues() {
		int special_case; // create a variable for the case when the second float = 0
		int tmp = 1; // create a temp variable for firstN when the second float = 0, since only float(0) will not thrown an exception, only int / int(0) type will do.
		int temp = 1; // create a temp variable for secondN, since only float / float(0) will not thrown an exception, only int / int(0) type will do.
		Map dict2 = new HashMap();
		firstFloat = Integer.MAX_VALUE;//initialize fF and sF in case the scanner passes old values to display results
		secondFloat = Integer.MAX_VALUE;
		dict2.put(1, "add");
		dict2.put(2, "subtract");
		dict2.put(3, "multiply");
		dict2.put(4, "divide");

		System.out.print("\n\tPlease enter two floats to " + dict2.get(menuChoice) + " separated by a space:");// get choice from getUserChoice method and ask user to give two floats

		// handle the user choice with two scenarios: smaller than 4 and equal to 4
		if (menuChoice < 4) {
			do {
				try {
					firstFloat = getInput.nextFloat();
					secondFloat = getInput.nextFloat();
				} catch (InputMismatchException k) {
					System.out.print("\tYou have entered invalid input. please re-enter:");
				}

				getInput.nextLine(); // clear the scanner

			} while ((firstFloat == Integer.MAX_VALUE) || (secondFloat == Integer.MAX_VALUE));
		} else if (menuChoice == 4) {
			do {
				try {
					firstFloat = getInput.nextFloat();
					secondFloat = getInput.nextFloat();
					if (secondFloat == 0.0) // when the second input = 0
						temp = Math.round(firstFloat);// turn the first input to integer
					tmp = Math.round(secondFloat);// turn the second input to integer
					special_case = temp / tmp;// provoke the arithmeticException, note that float / float(0) will not
												// thrown an exception, only int / int(0) type will do.
				} catch (InputMismatchException e) {
					System.out.print("\tYou have entered invalid inputs. please re-enter:");// when input is char,
																								// prop this error
				} catch (ArithmeticException e) {
					System.out.print("\tYou can't divide by zero please re-enter both floats:");// when the second input
																								// = 0, prop this error
				}
				getInput.nextLine(); // clear the scanner

			} while ((firstFloat == Integer.MAX_VALUE) || (secondFloat == Integer.MAX_VALUE) || (secondFloat == 0)); // if the user enters invalid inputs, repeat the process in loop
		}

	}

	public void displayResults() {

		if (menuChoice == 1) {
			System.out.printf("\tResult of adding %.2f and %.2f is %.2f.\n", firstFloat, secondFloat,
					firstFloat + secondFloat);
		} else if (menuChoice == 2) {
			System.out.printf("\tResult of subtracting %.2f and %.2f is %.2f.\n", firstFloat, secondFloat,
					firstFloat - secondFloat);
		} else if (menuChoice == 3) {
			System.out.printf("\tResult of multiplying %.2f and %.2f is %.2f.\n", firstFloat, secondFloat,
					firstFloat * secondFloat);
		} else {
			System.out.printf("\tResult of dividing  %.2f and %.2f is %.2f.\n", firstFloat, secondFloat,
					firstFloat / secondFloat);
		}

		System.out.println("\n\tPress enter key to continue....");

		getInput.nextLine();//wait user to press enter
	}

	public void displayBye() {
		System.out.println("\nThank you for using <Sisi Xie's> Handy Calculator");
		getInput.close(); // safely close the scanner when done
	}

	public static void main(String[] args) {
		OOPCalculator calc = new OOPCalculator();
		while (calc. askCalcChoice () != 5){ //it will set choice
		calc. askTwoValues (); //it will set two values
		calc.displayResults(); //do calc, display result
		//and wait on press enter key
		}
		calc.displayBye();

	}
}
