import java.util.InputMismatchException;
import java.util.Scanner;

public class HW8_TempAndBox {
	// HW8-PART 1-Process temperature data
	// a) create method getTemperatures
	static int weeklyTemp[] = new int[7]; // initialize the array;
	static int i;
	static Scanner getInput = new Scanner(System.in);
	static float total, average;

	static void getTemperatures() {
		i = 0;
		System.out.print("Please enter 7 temperatures for the week, separated by a space:");
		do {
			try {
				for (i = 0; i < 7; i++) {
					weeklyTemp[i] = getInput.nextInt();// get 7 temperatures
				}
			} catch (InputMismatchException e) {// print error message
				System.out.print("\nYou have entered invalid input. Try again:");
			}
			getInput.nextLine();
		} while ((i < 7) && (i >= 0));
	}

	// b) print temperatures
	static void printTemperatures() {
		int day = 0;
		for (int dayTemp : weeklyTemp) {// print temperature day by day in order
			System.out.printf("The temperature on day %d " + "was: %d\n", ++day, dayTemp);
		}
		System.out.printf("\n");
	}

	// c)find the maximum temperature
	static int getMax() {
		int max = 0;
		for (int dayTemp : weeklyTemp) {
			if (dayTemp > max)
				max = dayTemp;
		}
		return max;
	}

	// d)get the minimum temperature
	static int getMin() {
		int min = 0;
		for (int dayTemp : weeklyTemp) {
			if (dayTemp < min)
				min = dayTemp;
		}
		return min;
	}

	// e)get the average temperature
	static float getAverage() {
		total = 0;
		for (int dayTemp : weeklyTemp) {
			total += dayTemp;// get total weekly temperatures
			average = total / weeklyTemp.length;// get average weekly temperature
		}
		return average;
	}

	static void printStatistics() {
		System.out.printf("The minimum temperature of the week is %d\n", getMin());
		System.out.printf("The maximum temperature of the week is %d\n", getMax());
		System.out.printf("The average temperature of the week is %f\n", getAverage());

	}

	// HW8-PART2-Create box
	static int x, y, a, b;
	static char hChar1, vChar1, fChar1;
	static int ht1, wd1;
	static char answer = 'y';
	static Scanner input1 = new Scanner(System.in);

	// a)create drawHorizontalLine
	static void drawHorizontalLine() {
		wd1 = 11;
		hChar1 = '-';
		// input1.nextLine();//clean the buffer
		// draw horizontal line '-----------'
		for (x = 1; x <= wd1; x++) {
			System.out.print("" + hChar1);
		}
		System.out.print("\n");
	}

	// b)create drawVerticalLine that draws vertical lines | |
	static void drawVerticalLine() {
		ht1 = 5;
		vChar1 = '|';

		for (x = 1; x <= ht1 - 2; x++) {
			System.out.print("" + vChar1);
			for (y = 1; y <= wd1 - 2; y++)
				System.out.print(" ");
			System.out.print("" + vChar1 + "\n");
		}
	}

	// create Drawbox method to call horizontal line and vertical line methods
	static void drawBox() {
		do {
			drawHorizontalLine();
			drawVerticalLine();
			drawHorizontalLine();

			System.out.print("\n");

			System.out.print("Continue? Type 'y' for yes:");
			answer = getInput.next().charAt(0);
		} while (answer == 'y');

		System.out.println("\nThank you for using my draw box program");
	}

	public static void main(String[] args) {
		getTemperatures();
		printTemperatures();
		getMax();
		getMin();
		getAverage();
		printStatistics();
		drawBox();

	}

}