package com.tangibleidea.meeple.data;

import android.content.Context;



public class DBManager extends DBCore
{
	private Context context;
	
	public DBManager(Context _context)
	{
		super(_context);
		context= _context;
	}
}