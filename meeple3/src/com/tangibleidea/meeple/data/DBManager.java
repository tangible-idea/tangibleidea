package com.tangibleidea.meeple.data;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.util.Log;

import com.tangibleidea.meeple.layout.ChatEntry;
import com.tangibleidea.meeple.server.Chat;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;



public class DBManager extends DBCore
{
	private Context context;
	
	public DBManager(Context _context)
	{
		super(_context);
		context= _context;
	}
	
	
	public void PutChatDB(String strTableName, List<Chat> _chat)
	{
		if(_chat==null)
			return;
		
		for(Chat C : _chat)
		{
			ContentValues CV= new ContentValues();
			CV.put("chat", C.getChat());
			CV.put("senderid", C.getSenderAccount());
			CV.put("receverid", C.getReceiverAccount());
			CV.put("date", C.getDateTime());
			
			Long lRow= DB.insert(strTableName, "0", CV);
			
			if (lRow < 0)
				Log.e(Global.LOG_TAG,"DBInsert error!");
			
			CV.clear();
		}
		
	}
	
	/**
	 * 채팅을 가져온다.
	 * @param strTableName : 테이블
	 * @param nRow : 목록번호
	 * @return : 채팅 한줄
	 */
	public Chat GetChatDB(String strTableName, int nRow)
	{
		Chat res=null;
	
		String[] strCol= {"senderid", "receverid", "chat", "date", "_id"};
		
		Cursor CS= this.GetCursorFromDB(strTableName, strCol);
		
		//CS.moveToFirst(); 
		CS.move(nRow);
		res= new Chat( CS.getString(0), CS.getString(1), CS.getString(2), CS.getString(3), CS.getString(4) ); 
		
		CS.close();
		
		return res;
	}
	
	public ArrayList<ChatEntry> GetChatToArrayList(Context _context, String strTableName)
	{
		ArrayList<ChatEntry> res= new ArrayList<ChatEntry>();
		boolean bMyChat;
		
		String[] strCol= {"chat", "senderid", "receverid", "date"};
		
		Cursor CS= this.GetCursorFromDB(strTableName, strCol);
		
		if(CS.moveToFirst())
		{    //if 가 참이면 얻어온 데이타가 1개 이상 
			do
			{
				if( CS.getString(1).equals( SPUtil.getString(_context, "AccountID") ) )
					bMyChat= true;
				else
					bMyChat= false;
				
				res.add( new ChatEntry( bMyChat, CS.getString(0), CS.getString(3) ) ); 
			}while(CS.moveToNext());
		}
		
		CS.close();

		
		return res;
	}
	
	
	
	
	public ArrayList<String> GetChatToArrayListTEST(Context _context, String strTableName)
	{
		ArrayList<String> res= new ArrayList<String>();
		
		String[] strCol= {"chat", "senderid", "receverid", "date"};
		
		Cursor CS= this.GetCursorFromDB(strTableName, strCol);
		
		if(CS.moveToFirst())
		{    //if 가 참이면 얻어온 데이타가 1개 이상 
			do
			{				
				res.add( CS.getString(1)+" : "+ CS.getString(0) ); 
			}while(CS.moveToNext());
		}
		
		CS.close();

		
		return res;
	}
}