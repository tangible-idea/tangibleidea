package com.tangibleidea.meeple.data;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.util.Log;

import com.tangibleidea.meeple.activity.RecentTalkListActivity;
import com.tangibleidea.meeple.layout.entry.ChatEntry;
import com.tangibleidea.meeple.layout.entry.RecentTalkEntry;
import com.tangibleidea.meeple.layout.enums.EnumRecentTalkStatus;
import com.tangibleidea.meeple.server.Chat;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;



public class DBManager extends DBCore
{
	private Context mContext;
	
	public DBManager(Context _context)
	{
		super(_context);
		mContext= _context;
	}
	
	
	public void InsertChatDB(String strTableName, List<Chat> _chat)
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
	 * 끝난 채팅 정보를 입력한다.
	 * @param oppoAccount : 끝낸 상대방 정보
	 * @param lastChat : 마지막 채팅
	 * @param date : 끝낸 날짜
	 */
	public void InsertEndChatInfo(String oppoAccount, String oppoName, String lastChat, String date)
	{
		ContentValues CV= new ContentValues();
		CV.put("my_account", SPUtil.getString(mContext, "AccountID"));
		CV.put("oppo_account", oppoAccount);
		CV.put("name", oppoName);
		CV.put("last_chat", lastChat);
		CV.put("date", date);
		
		Long lRow= DB.insert(Global.DB_TABLE_ENDCHAT, "0", CV);
		
		if (lRow < 0)
			Log.e(Global.LOG_TAG,"DBInsert error!");
		
		CV.clear();
	}
	
	/**
	 * 끝낸 채팅 정보들을 가져 온다.
	 * @return : RecentTalkEntry
	 */
	public ArrayList<RecentTalkEntry> GetEndChatInfo()
	{
		ArrayList<RecentTalkEntry> res= new ArrayList<RecentTalkEntry>();
		
		String[] strCol= {"my_account", "oppo_account", "name", "last_chat", "date"};
		
		Cursor CS= this.GetCursorFromDB(Global.DB_TABLE_ENDCHAT, strCol);
		
		if(CS.moveToFirst())
		{
			do
			{
				if( CS.getString(0).equals(SPUtil.getString(mContext, "AccountID")) )	// DB에 저장된 정보가 나의 정보가 일치하면
					res.add(new RecentTalkEntry(EnumRecentTalkStatus.E_FINISHED_TALK, "0", CS.getString(1), CS.getString(2), CS.getString(3), "0", CS.getString(4)));
			}
			while(CS.moveToNext());
		}
		
		return res;
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
	
	/**
	 * 현재 채팅의 커서값을 가져온다.
	 * @param strTableName
	 * @return
	 */
	public Cursor MakeCursorChat(Context _context, String strTableName)
	{
		return DB.rawQuery("SELECT * FROM "+strTableName, null);
	}
	
	/**
	 * DB에 저장된 채팅 리스트 전부를 가져온다.
	 * @param _context
	 * @param strTableName
	 * @return
	 */
	public ArrayList<ChatEntry> GetChatToArrayList(Context _context, String strTableName)
	{
		ArrayList<ChatEntry> res= new ArrayList<ChatEntry>();
		boolean bMyChat;
		
		String[] strCol= {"chat", "senderid", "receverid", "date"};
		
		Cursor CS= this.GetCursorFromDB(strTableName, strCol);
		
		if( CS.getCount() < 25 )	// 채팅이 25줄보다 적으면
		{
			if(CS.moveToFirst())
			{    //moveToFirst 가 참이면 얻어온 데이타가 1개 이상 
				do
				{
					if( CS.getString(1).equals( SPUtil.getString(_context, "AccountID") ) )
						bMyChat= true;
					else
						bMyChat= false;
					
					res.add( new ChatEntry( bMyChat, CS.getString(0), CS.getString(3) ) ); 
				}while(CS.moveToNext());
			}
		}
		else	// 채팅이 25줄보다 많으면
		{
			CS.moveToPosition( CS.getCount() - 25);
			
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
//	
//	
//	public ArrayList<String> GetChatToArrayListTEST(Context _context, String strTableName)
//	{
//		ArrayList<String> res= new ArrayList<String>();
//		
//		String[] strCol= {"chat", "senderid", "receverid", "date"};
//		
//		Cursor CS= this.GetCursorFromDB(strTableName, strCol);
//		
//		if(CS.moveToFirst())
//		{    //if 가 참이면 얻어온 데이타가 1개 이상 
//			do
//			{				
//				res.add( CS.getString(1)+" : "+ CS.getString(0) ); 
//			}while(CS.moveToNext());
//		}
//		
//		CS.close();
//
//		
//		return res;
//	}
}