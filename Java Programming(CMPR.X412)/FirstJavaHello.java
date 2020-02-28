import java.util.Scanner;

public class FirstJavaHello {
	public static void main(String[] args) {
		// Assignment 3.1
				int yourAge;
				
				Scanner readInput = new Scanner (System.in);
				System.out.printf("How old are you?: ");
				yourAge = readInput.nextInt();
				if (yourAge < 13)
					System.out.printf("You are a kid\n");
				else if (yourAge <= 19)
					System.out.printf("You are a teenager\n");
				else
					System.out.printf("You are an adult\n");
					
				// Assignment 3.2
				float firstN;
				float secondN;
				char operator; 
				
				
				char charResponse =' ';
				do{
					
					System.out.printf("Type a number, operator, number --"
							             + "separated by a space: ");		
					firstN = readInput.nextFloat();
					operator = readInput.next().charAt(0);
					secondN = readInput.nextFloat();
					
					//" and ' have different uses 
					if (operator == '+')
						System.out.printf("%.2f + %.2f = %.2f",
								firstN, secondN, firstN + secondN);
					else if (operator == '-')
						System.out.printf("%.2f - %.2f = %.2f",
								firstN, secondN, firstN - secondN);
					else if (operator == '*')
						System.out.printf("%.2f * %.2f = %.2f",
					            firstN, secondN, firstN * secondN);
					else if (operator == '/')
						System.out.printf("%.2f / %.2f = %.2f",
					            firstN, secondN, firstN / secondN);
					else if (operator == '%')
						System.out.printf("%.2f %% %.2f = %.2f",
								firstN, secondN, firstN % secondN);	
					else 
						System.out.printf("unknown operator");
					
					System.out.println("\n");
					System.out.print("Continue? Type 'y' for yes: ");
					charResponse = readInput.next().charAt(0);
				} while (charResponse != 'n');
				System.out.printf("\n\n");
				
				//Assignment 3.3
				int a;
				int b;
				int c;
				int max;

				do{
				
				 	System.out.println("Enter three integer numbers to find max of them--"
						             + "separated by a space: ");		
				    a = readInput.nextInt();
				    b = readInput.nextInt();
				    c = readInput.nextInt();
				 	
					max = (a > b)? a : b;
					max = (max > c)? max : c;
					
					System.out.printf("The Max is: %d", max);
					
					System.out.println("\n");
					System.out.print("Continue? Type 'y' for yes: ");
					charResponse = readInput.next().charAt(0);
				} while (charResponse != 'n');
				System.out.printf("Thank you for using my max program");
				System.out.println("\n");
				System.out.printf("Press any key to continue...");
					
					
	}

}
