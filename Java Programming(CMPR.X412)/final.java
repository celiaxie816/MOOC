import java.util.ArrayList;
import java.util.*;

class CompareBoxNames implements Comparator {
	public int compare(Object s1, Object s2) {
	 	String str1 = ((NewBox)s1).getBoxName();
	 	String str2 = ((NewBox)s2).getBoxName();
	 	
	 return (str1.compareTo(str2)) ;	 
}
	public boolean equals(Object s1, Object s2) {
	 	String str1 = ((NewBox)s1).getBoxName();
	 	String str2 = ((NewBox)s2).getBoxName();
	 	return (str1.equalsIgnoreCase(str2));
	}
}

class NewBox implements Comparable{
	//state
	private int 	width = 20;
	private int 	height = 10;
	private String  hStr = "-";
	private String  vStr = "|";
	private String  boxName = "Default Name";

	public int getHeight() {
		return height;
	}
	public void setHeight(int height) {
		this.height = height;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public String gethStr() {
		return hStr;
	}
	public void sethStr(String hStr) {
		this.hStr = hStr;
	}
	public String getvStr() {
		return vStr;
	}
	public void setvStr(String vStr) {
		this.vStr = vStr;
	}
	public String getBoxName() {
		return boxName;
	}
	public void setBoxName(String boxName) {
		this.boxName = boxName;
	}
	public NewBox(int width, int height) {
		super();
		this.width = width;
		this.height = height;
	}
	public NewBox(String boxName) {
		super();
		this.boxName = boxName;
	}
	public NewBox(String boxName, int height, int width) {
		super();
		this.width = width;
		this.height = height;
		this.boxName = boxName;
	}
	public NewBox(int width, int height, String hStr, String vStr, String boxName) {
		super();
		this.width = width;
		this.height = height;
		this.hStr = hStr;
		this.vStr = vStr;
		this.boxName = boxName;
	}
	
	public int compareTo(Object o) {
		int area1 = ((NewBox)o).height * ((NewBox)o).width;
		int area2 = height * width;
		
		if(area1 < area2)
			return 1;
		else if (area1 > area2)
			return -1;
		else 
			return 0;
	}
}

public class TestCollection {
	
	public static void testIntArray() {
		int [] weeklyTemp = {69, 70, 71, 63, 65, 71, 70};
		//instead of 
		for (int day=0; day<weeklyTemp.length; day++) {
			System.out.printf("The temperature of day %d was %d\n", day+1, weeklyTemp[day]);
			System.out.println();
		}
	}
	
	public static void testObjectArray() {
		NewBox [] myNewBox = {new NewBox("My New Box1", 10, 20), new NewBox("My New Box2", 20, 20), 
							  new NewBox("My New Box2", 30, 20), new NewBox("My New Box2", 20, 20)};
		
		for (int i=0; i<myNewBox.length; i++) {
			System.out.printf("Size of box %s is %d and %d\n", myNewBox[i].getBoxName(),
			                                                   myNewBox[i].getHeight(), 
			                                                   myNewBox[i].getWidth());
			System.out.println();
		}	
		
	}
	
	public static void testArrayList() {
		ArrayList listofValues1 = new ArrayList();
		listofValues1.add(1);
		listofValues1.add(2);
		listofValues1.add(3);
		System.out.println(listofValues1);
		
		//listofValues1.get(2));
		//listofValues1.clear()		
	}
	
	public static void testlinkedList() {
		LinkedList LinkedListValues = new LinkedList();
		
		LinkedListValues.addFirst("John");
		LinkedListValues.addLast("Jill");
		LinkedListValues.addFirst("Jack");
		LinkedListValues.add("Kerry");
		LinkedListValues.addLast("Sarah");
		System.out.println(LinkedListValues);
	}
	
	public static void testSorting() {
		NewBox box1 = new NewBox("New Box 3", 10, 20);
		NewBox box2 = new NewBox("New Box 4", 10, 20);
		NewBox box3 = new NewBox("New Box 2", 10, 20);
		NewBox box4 = new NewBox("New Box 1", 10, 20);
		
		
		//list of the order of the creation
		NewBox[] lotsOfBoxes = new NewBox[] {box1, box2, box3, box4};
		
		for (int i=0; i<lotsOfBoxes.length; i++) {
			System.out.println(lotsOfBoxes[i].getBoxName());
		}	
		
		//sort naturally - provided by the object
	    Arrays.sort(lotsOfBoxes);
	    for (int a=0; a<lotsOfBoxes.length; a++) {
			System.out.println(((NewBox)lotsOfBoxes[a]).getBoxName() + "Area: " + ((NewBox)lotsOfBoxes[a]).getHeight() *  ((NewBox)lotsOfBoxes[a]).getWidth());

			
		//sort by any other means, list in the order by comparable
		Arrays.sort(lotsOfBoxes, new CompareBoxNames());
		for (int b=0; b<lotsOfBoxes.length; b++) {
			System.out.println(lotsOfBoxes[b].getBoxName());
			
		}
			
			
			
		//sort by the order of Comparator sorting implementation
		//Collection.sort
		
			
		}
	}
	
	public static void testEnhancedForLoop(String [] args) {
		//traditonal way 
		for (int i=0; i<args.length; i++) {
			System.out.print("Argument " + (i+1) + "| ");
			System.out.println(args[i]);
		}
		
		//using enhanced for loop
		int i = 0;
		for (String strArgument: args ) {
			System.out.print("Argument " + ++i + ": ");
			System.out.println(strArgument);
		}
		
		//enhanced for loop
		int [] weeklyTemp = {69, 70, 71, 68, 66, 71, 70};
		
		int day = 0;
		for (int dayTemp : weeklyTemp)
			System.out.printf("The temperature on day %d was %d\n", ++day, dayTemp);
		System.out.println();
		
	}
/*	
	public static boolean contains(Integer[] array, Integer anyObject) {
		for (Integer value: array) {
			if (anyObject.equals(value))
				return true;
		}
		return false;
	}
	
	public static boolean contains(String[] array, String anyObject) {
		for (String value: array) {
			if (anyObject.equals(value))
				return true;
		}
		return false;
	}
*/	
	//generics and methods 
	public static <T> boolean contains(T[] array, T anyObject) {
		for (T value: array) {
			if (anyObject.equals(value))
				return true;
		}
		return false;
	}
	
	public static void testContains() {
		Integer[] array = new Integer[5];
		for (int j = 0; j < 5; j++) {
			array[j] = j * j;
		}
		if (contains(array, new Integer(15))) {
			System.out.println("Found the value");
		}else {
			System.out.println("Value not found");
		}
		
		//string example
		String[] strArray = new String[5];
		String strTemp;
		for (int i =0; i < 5; i++) {
			strTemp = String.format("This is string %d", i*i);
			strArray[i] = strTemp;		
		}
		if (contains(strArray, new String("This is string 16"))) {
			System.out.println("Found the string");
		} else {
			System.out.println("String not found");
		}
		
	}
	
	public static void testGenericCollections() {
		NewBox box_1 = new NewBox("New Box 3", 10, 20);
		NewBox box_2 = new NewBox("New Box 4", 20, 28);
		NewBox box_3 = new NewBox("New Box 2", 20, 20);
		NewBox box_4 = new NewBox("New Box 1", 29, 20);
		
		ArrayList<NewBox> arrayOfBoxes = new ArrayList<NewBox>();
		
		arrayOfBoxes.add(box_1);
		arrayOfBoxes.add(box_2);
		arrayOfBoxes.add(box_3);
		arrayOfBoxes.add(box_4);
		
		//sort naturally - provided by the object
	    Collections.sort(arrayOfBoxes);
	    for (int a=0; a<arrayOfBoxes.size(); a++) {
	        NewBox nBox = arrayOfBoxes.get(a);
			System.out.println(nBox.getBoxName() + "Area: " + nBox.getHeight() *  nBox.getWidth());
	    }	
		//comparator sorting implementation
		Collections.sort(arrayOfBoxes, new CompareBoxNames());
		for (int i =0; i < arrayOfBoxes.size(); i++) {
			NewBox mBox = arrayOfBoxes.get(i); 
			System.out.println(mBox.getBoxName() + "Area: " + mBox.getHeight() * mBox.getWidth());
		}
		
		
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
//        testIntArray();
//        testObjectArray();
//        testArrayList();
//        testlinkedList();
//        testSorting();
//        testEnhancedForLoop(args);
//        testContains();
        testGenericCollections();
	}
	
}

