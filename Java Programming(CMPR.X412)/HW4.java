
import java.util.Scanner;

class Box {
	static void drawHLine(int h, String hStr) {
		int i = 0;
		while (i++ < h)
			System.out.print(hStr);
	}

	static void drawVLine(int h, int v, String hStr, String vStr) {
		int i = 0, j = 0;
		while (i++ < v - 2) {
			System.out.print(vStr);
			drawHLine(h - 2, hStr);
			System.out.println(vStr);
		}

	}

	static void drawBox(int h, int v, String hStr, String vStr, String fillerStr) {

		// default box
		drawHLine(h, hStr);
		System.out.printf("\n");
		drawVLine(h, v, fillerStr, vStr);
		drawHLine(h, hStr);
		System.out.printf("\n");
	}

}

public class HW4 {
	public static void main(String[] args) {
		// Assignment 4.1
		// Assignment 4.1a: this loop is executed 10 times
		int i = 0;
		while (i++ < 10) {
			System.out.println("Hello World: " + i);
		}

		// Assignment 4.1b: this loop is executed 9 times
		i = 0;
		while (++i < 10) {
			System.out.println("Hello World: " + i);
		}

		// Assignment 4.1c: this loop is executed 0 times
		while (++i < 10) {
			System.out.println("Hello World: " + i);
		}

		// Assignment 4.2
		int hSize = 20;
		int vSize = 10;

//      System.out.println("------------------------");		
		int count = 0;
		while (count++ < hSize)
			System.out.print("-");
		System.out.printf("\n");

//       System.out.println("|                    |")		    
		int count2 = 0;
		while (count2++ < vSize - 2) {
			System.out.print("|");
			count = 0;
			while (count++ < hSize - 2)
				System.out.print(" ");
			System.out.println("|");
		}

//       System.out.println("----------------------");
		count = 0;
		while (count++ < hSize)
			System.out.print("-");
		System.out.printf("\n");

		// Assignment 4.3
//	      System.out.println("------------------------");
		count = 0;
		do {
			System.out.print("-");
		} while (++count < hSize);
		System.out.printf("\n");

//	       System.out.println("|                    |")		    
		count2 = 0;
		do {
			System.out.print("|");
			count = 0;
			do {
				System.out.print(" ");
			} while (++count < hSize - 2);
			System.out.println("|");
		} while (++count2 < vSize - 2);

//	       System.out.println("----------------------");
		count = 0;
		do {
			System.out.print("-");
		} while (++count < hSize);
		System.out.printf("\n");

		// Assignment 4.4
		// System.out.println("------------------------");
		for (count = 0; count < hSize; count++) {
			System.out.print("-");
		}
		System.out.printf("\n");

		// System.out.println("| |")
		count2 = 0;
		for (count2 = 0; count2 < vSize - 2; count2++) {
			System.out.print("|");
			count = 0;
			for (count = 0; count < hSize - 2; count++) {
				System.out.print(" ");
			}
			System.out.println("|");
		}

		// System.out.println("------------------------");
		for (count = 0; count < hSize; count++) {
			System.out.print("-");
		}
		System.out.printf("\n");
//		 
//				
		// Assignment 4.5
		hSize = 0;
		vSize = 0;
		String hStr;
		String vStr;

		Scanner readInput = new Scanner(System.in);
		// you can ask the user to give you the h/v size and h/v characters

		System.out.printf("Enter the horizontal size of your box:");
		hSize = readInput.nextInt();
		System.out.printf("Enter the vertical size of your box:");
		vSize = readInput.nextInt();
		System.out.printf("Enter the horizontal character of your box:");
		hStr = readInput.next();
		System.out.printf("Enter the vertical character of your box:");
		vStr = readInput.next();

		// DIY BOX
		Box.drawBox(hSize, vSize, hStr, vStr, " ");

		// Assignment 4.6
		char charResponse = 'y';
		while (charResponse != 'n'){
			// you can ask the user to give you the h/v size and h/v characters
			System.out.printf("Enter the horizontal size of your box:");
			hSize = readInput.nextInt();
			System.out.printf("Enter the vertical size of your box:");
			vSize = readInput.nextInt();
			System.out.printf("Enter the horizontal character of your box:");
			hStr = readInput.next();
			System.out.printf("Enter the vertical character of your box:");
			vStr = readInput.next();

			Box.drawBox(hSize, vSize, hStr, vStr, " ");

			System.out.print("Continue? Type 'y' for yes: ");
			charResponse = readInput.next().charAt(0);
		} 
		System.out.print("Thank you for using my program.");
	}

}
