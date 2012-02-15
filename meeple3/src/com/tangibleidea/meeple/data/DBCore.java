package com.tangibleidea.meeple.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.tangibleidea.meeple.util.Global;

class DBCore
{

	protected DataBaseHelper DBhelper;
	
	protected SQLiteDatabase DB;
	
	protected DBCore(Context _context)
	{
		DBhelper= new DataBaseHelper(_context);
		
//		try
//{
		DB = DBhelper.getWritableDatabase();
//}
//		catch(Exception e) // 권한이나 디스크 공간문제로 오류가 날 수 있으므로 방어코드로 Readable을 넣는다.
//		{
//			DB = DBhelper.getReadableDatabase();
//		}
		
		Log.d(Global.LOG_TAG, " --> DB open");
	}

	/**
	 * 데이터를 가져온다.
	 * @param _strCol : 원하는 데이터의 칼럼.
	 * @return : 원하는 데이터의 커서가 리턴됨.
	 */
	protected Cursor GetCursorFromDB(String _strTable, String[] _strCol)
	{		
		Cursor CS= DB.query(_strTable, _strCol, null, null, null, null, null);
		
		return CS;
	}
	
	/**
	 * 문자열 데이터를 가져온다.
	 * @return
	 */
	public String GetStrDataFromDB(String _strTable, String strLabel, int nIdx)
	{
		String strRes = null;
		String[] strCol= {strLabel.toString()};
		
		Cursor CS= this.GetCursorFromDB(_strTable, strCol);
		
		//CS.moveToFirst(); 
		CS.move(nIdx);
		strRes= CS.getString(0);
		
		CS.close();
		
		return strRes;
	}
	
	/**
	 * 문자열 데이터를 가져온다.
	 * @return
	 */
	public String GetStrDataFromDB2(String _strTable, String strLabel, int nIdx)
	{
		String strRes = null;
		String[] strCol= {strLabel.toString()};
		
		Cursor CS= this.GetCursorFromDB(_strTable, strCol);
		
		CS.moveToFirst(); 
		CS.move(nIdx);
		strRes= CS.getString(0);
		
		CS.close();
		
		return strRes;
	}
	
	/**
	 * 문자열 데이터를 가져온다. (데이터가 한개인 경우)
	 * @return
	 */
	public String GetStrDataFromDB(String _strTable, String strLabel)
	{
		String strRes = null;
		String[] strCol= {strLabel.toString()};
		
		Cursor CS= this.GetCursorFromDB(_strTable, strCol);
		
		while( CS.moveToNext() )
			strRes= CS.getString(0);
		
		return strRes;
	}
	
	/**
	 * 정수형 데이터를 가져온다.
	 * @param _strTable
	 * @param strLabel
	 * @param nIdx
	 * @return
	 */
	public int GetIntDataFromDB(String _strTable, String strLabel, int nIdx)
	{
		int nRes = 0;		
		String[] strCol= {strLabel.toString()};
		
		Cursor CS= this.GetCursorFromDB(_strTable, strCol);
		
		CS.moveToFirst();
		CS.move(nIdx);
		
		try
		{
		nRes= CS.getInt(0);
		}catch(Exception e){	// 오류 발생율이 높다.
			Log.e(Global.LOG_TAG, e.toString());
			return 0;
		}
		
		CS.close();	// 이게 오류가 아닐까 추가해봄
		
		return nRes;
	}
	
	/**
	 * 문자열 데이터를 넣는다.
	 * @param strLabel : key값을 넣는다. (_id, level, money 등...)
	 * @param strData : 정보값을 넣는다.
	 */
	public void DBInsert(String _strTable, String strLabel, String strData)
	{
		ContentValues CV= new ContentValues();
		CV.put(strLabel, strData);
		
		Long lRow= DB.insert(_strTable, "0", CV);
		
		if (lRow < 0)
			Log.e(Global.LOG_TAG,"DBInsert error!");
		
		CV.clear();
	}
	
	/**
	 * 정수 데이터를 넣는다.
	 * @param strLabel : key값을 넣는다. (_id, level, money 등...)
	 * @param strData : 정보값을 넣는다.
	 */
	public void DBInsert(String _strTable, String strLabel, int nData)
	{
		ContentValues CV= new ContentValues();
		CV.put(strLabel, nData);
		
		DB.insert(_strTable, "0", CV);
		
		CV.clear();
	}
	
	/**
	 * ContentValues 객체를 insert 한다.
	 * @param _strTable : 대상 테이블
	 * @param _CV : ContentsValues
	 */
	public void DBInsertCV(String _strTable, ContentValues _CV)
	{
		DB.insert(_strTable, null, _CV);
	}
	
	/**
	 * ContentValues 객체를 update 한다.
	 * @param _strTable : 대상 테이블
	 * @param _cv : ContentsValues
	 */
	public void DBUpdateCV(String _strTable, ContentValues _cv, int nWhere)
	{
		DB.update(_strTable, _cv, "_id = "+nWhere, null);
	}
	
	/**
	 * 문자열 데이터를 수정한다.
	 * @param strLabel : key값을 넣는다. (_id, level, money 등...)
	 * @param strData : 정보값을 넣는다.
	 */
	public void DBUpdate(String _strTable, String strLabel, String strData)
	{
		ContentValues CV= new ContentValues();
		CV.put(strLabel, strData);
		
		DB.update(_strTable, CV, null, null);
		
		CV.clear();
	}
	
	/**
	 * 조건에 맞는 문자열 데이터를 수정한다.
	 * @param strLabel : key값을 넣는다. (_id, level, money 등...)
	 * @param strData : 정보값을 넣는다.
	 * @param strWhere : 조건식
	 */
	public void DBUpdate(String _strTable, String strLabel, String strData, String strWhere)
	{
		ContentValues CV= new ContentValues();
		CV.put(strLabel, strData);
		
		DB.update(_strTable, CV, strWhere, null);
		
		CV.clear();
	}
	
	/**
	 * 정수 데이터를 수정한다.
	 * @param strLabel : key값을 넣는다. (_id, level, money 등...)
	 * @param strData : 정보값을 넣는다.
	 */
	public void DBUpdate(String _strTable, String strLabel, int nData)
	{
		ContentValues CV= new ContentValues();
		CV.put(strLabel, nData);
		
		DB.update(_strTable, CV, null, null);
		
		CV.clear();
	}
	
	public void DBUpdate(String _strTable, String strLabel, int nData, String strWhere)
	{
		ContentValues CV= new ContentValues();
		CV.put(strLabel, nData);
		
		DB.update(_strTable, CV, strWhere, null);
		
		CV.clear();
	}
	
	public int CountDBRows(String _strTable, String strLabel)
	{
		String[] strCol= {strLabel.toString()};
		Cursor CS= this.GetCursorFromDB(_strTable, strCol);
		
		return CS.getCount();
	}
	
	/**
	 * DB작업을 마치고 닫아준다.
	 */
	public void DBClose()
	{
		if( this.DBhelper != null )
			DBhelper.close();
		
		Log.d(Global.LOG_TAG, ":::MEEPLE::: --> DB close");
	}
	
	//public void DBopen()
	
	
	public void CreateNewChatTable(String _strTableName)
	{
		//_DB.execSQL("CREATE TABLE "+DB_NAME+" ("+
		DB.execSQL("CREATE TABLE IF NOT EXISTS "+ _strTableName +" ("+	// 채팅 테이블을 만든다.
				"_id INTEGER PRIMARY KEY AUTOINCREMENT, " + // _id(int,기본키,자동증가값)
				"chat TEXT, " +								// 채팅내용 (String)
				"senderid TEXT, " +							// 보낸사람ID (String)
				"receverid TEXT, " +						// 받는사람ID (String)
				"date TEXT" +								// 시간(String)
				")");

		
	}
	
	
	public void CreateNewMessageTable(String _strTableName)
	{
		//_DB.execSQL("CREATE TABLE "+DB_NAME+" ("+
		DB.execSQL("CREATE TABLE IF NOT EXISTS "+ _strTableName +" ("+	// 메세지 테이블을 만든다.
				"_id INTEGER PRIMARY KEY AUTOINCREMENT, " + // _id(int,기본키,자동증가값)
				"chat TEXT, " +								// 메세지내용 (String)
				"senderid TEXT, " +							// 보낸사람ID (String)
				"receverid TEXT, " +						// 받는사람ID (String)
				"date TEXT" +								// 시간(String)
				")");

		
	}
	
	
	protected class DataBaseHelper extends SQLiteOpenHelper
	{

		protected DataBaseHelper(Context context)
		{
			super(context, Global.DB_NAME, null, Global.DB_VERSION);
		}

		/**
		 * DB가 처음 만들어질 때 호출된다.
		 */
		@Override
		public void onCreate(SQLiteDatabase _DB)
		{
			//CreateMyInfoTable(_DB);
			
			Log.d(Global.LOG_TAG, "Call DB TABLE onCreate Complete");
		}



		/*
		 * DB버전이 올라가면 호출된다.(non-Javadoc)
		 * @see android.database.sqlite.SQLiteOpenHelper#onUpgrade(android.database.sqlite.SQLiteDatabase, int, int)
		 */
		@Override
		public void onUpgrade(SQLiteDatabase _DB, int oldVer, int newVer) 
		{
			Log.w(Global.LOG_TAG, "Upgrading database : " + oldVer + " to "+newVer + ", which will destroy all old data");

		}
		
		@Override
		public void onOpen(SQLiteDatabase db)
		{
			super.onOpen(db);
		}
		
		@Override
		public synchronized void close()
		{
			super.close();
		}
		
		
		
//		private void CreateMyInfoTable(SQLiteDatabase _DB)
//		{
//			//_DB.execSQL("CREATE TABLE IF NOT EXISTS "+DB_NAME+" ("+
//			_DB.execSQL("CREATE TABLE "+Global.DB_TABLE_MYINFO+" ("+	// 나의 정보 테이블을 만든다.
//					"_id INTEGER PRIMARY KEY AUTOINCREMENT, " + // _id(int,기본키,자동증가값)
//					"account TEXT, " +					// 계정
//					"mentor char(1), " +				// 멘토인가?
//					"name TEXT, " +						// 이름
//					"email TEXT, " +					// 이메일
//					"school TEXT, " +					// 학교 (멘티)
//					"grade TEXT, " +					// 학년(멘티)
//					"univ TEXT," +						// 대학(멘토)
//					"major TEXT,"+						// 전공(멘토)
//					"promo TEXT," +						// 학번(멘토)
//					"gender TEXT" +						// 성별					
//					")");
//			
//		}
		
		

		
	}
			
			
}

