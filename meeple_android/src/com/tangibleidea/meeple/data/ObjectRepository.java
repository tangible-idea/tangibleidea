package com.tangibleidea.meeple.data;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.StreamCorruptedException;

public final class ObjectRepository {
		
	public static void saveObject(Object object , String fileName) throws FileNotFoundException, IOException {
		ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(fileName));
		os.writeObject(object);
		os.flush();
		os.close();
	}
	
	public static Object readObject (String fileName) throws StreamCorruptedException, FileNotFoundException, IOException, ClassNotFoundException {
		ObjectInputStream is = new ObjectInputStream(new FileInputStream(fileName));
		
		Object object = is.readObject();
		
		is.close();
		return object;
	}
}
