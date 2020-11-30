import java.util.*;
import java.io.*;

public class HW9_commandLines {

	
	//Part 9.1 
	public static void processCLArguments(String[] args) {

		InputStream inStream;

		if (args.length < 2) { //check if the length of command line arguments is less than 2
			System.out.print("Usage: java Exercise5 inputFile outputFile");//display this message when < 2
		} else {
			System.out.println("Input will be read from: " + args[0]);//display the first arg of command line
			System.out.println("Output will be written into: " + args[1]);//display the second arg of command line
		}
	}

	//Part 9.2
	public static void processInputOutputFiles(String[] args) {
		PrintWriter textPrintStream = null;
		String outfileName = args[1];
		File inputFile = new File(args[0]);
		ArrayList lineList = new ArrayList();
		ArrayList txtList = new ArrayList();
		BufferedReader finalInStream;
		int student_id;

		// print the content in input_final.txt
		student_id = 0;//initialize student id 
		try {
			FileReader fileReader = new FileReader("input_final.txt");
			finalInStream = new BufferedReader(fileReader);//get buffer to read my text doc
			String s;
			while ((s = finalInStream.readLine()) != null) {
				System.out.printf("Student #: %d %s\n", ++student_id, s);//print txt doc as required 
				List<String> strsToList = Arrays.asList(s.split("\\,"));//convert each line to a list, separated by comma
				txtList.add(strsToList);//add each converted line(list) to the text list
			}
			finalInStream.close();//safely close the bufferedreader when done
		  //error messages
		} catch (FileNotFoundException e) {
			System.out.println("File: " + args[0] + "not found");
		} catch (IOException e) {
			System.out.println("Error Reading from file: " + args[0] + e.getMessage());
		} catch (Exception e) {
			System.out.println(e);
		}

		// print output on the disk file whose name is given in the 2nd
		try {//read file
			FileReader fileStream = new FileReader(inputFile);
			finalInStream = new BufferedReader(fileStream);
			textPrintStream = new PrintWriter(new FileOutputStream(outfileName, true));
			String name;
            
			//write each formatted line in the input_file to the output_file
			student_id = 0;
			for (Object o : txtList) {
				name = (String) ((List) o).get(0);
				textPrintStream.printf("Student #%d is: \"%s\" whose raw scores are: %s: %s: %s: %s: %s: %s: %s:\n",
						++student_id, name, ((List) o).get(1), ((List) o).get(2), ((List) o).get(3), ((List) o).get(4),
						((List) o).get(5), ((List) o).get(6), ((List) o).get(7));
			}
			textPrintStream.close();//safely close the PrintWrirer when done
		//error messages when reading input files
		} catch (FileNotFoundException e) {
			System.out.println("File: " + args[0] + "not found");
		} catch (IOException e) {
			System.out.println("Error Reading from file: " + args[0] + e.getMessage());
		} catch (Exception e) {
			System.out.println(e);
		}
	}

	public static void main(String[] args) {
		processCLArguments(args);
		processInputOutputFiles(args);

	}

}
