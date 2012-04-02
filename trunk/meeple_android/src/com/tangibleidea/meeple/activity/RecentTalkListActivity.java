package com.tangibleidea.meeple.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.DBManager;
import com.tangibleidea.meeple.layout.RecentTalkEntry;
import com.tangibleidea.meeple.layout.RecentTalkListAdapter;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RecentChat;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.ChatManager;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class RecentTalkListActivity extends ListActivity
{
	private ChatManager ChatMgr= ChatManager.GetInstance();
	private int SelItem= -1;
	private Context mContext;
	private ProgressDialog LoadingDL;
	ArrayAdapter<RecentTalkEntry> list1;
	final ArrayList<RecentTalkEntry> arraylist= new ArrayList<RecentTalkEntry>();

	private List<RecentChat> recentChats;
	private List<MenteeInfo> InProgress_tees;
	private List<MentorInfo> InProgress_tors; 
	
	private DBManager DBMgr;
	

	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.recent_talk);
		
		mContext= this;
		DBMgr= new DBManager(mContext);
		LoadingDL = new ProgressDialog(mContext);
		GetRecentChats();
	}
	
	public void GetRecentChats()
	{
    	Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{	
    		try {
				backgroundThreadProcessing();
			} catch (Exception e) {
				Log.e(Global.LOG_TAG, e.toString());
			}
    	}
    };

    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
    private void backgroundThreadProcessing() throws Exception
    {
    	try 
    	{
    		if( !arraylist.isEmpty() )
    			arraylist.clear();
    		
    		boolean isMentor= SPUtil.getBoolean(mContext, "isMentor");
    		
    		RequestMethods RM= new RequestMethods();
    		
   		
    		if(isMentor)
    		{
        		LoadingHandler.sendEmptyMessage(10);
    			InProgress_tees= RM.InProgressMenteeRecommmendations(mContext);
    			LoadingHandler.sendEmptyMessage(20);
    		}else{
        		LoadingHandler.sendEmptyMessage(11);
    			InProgress_tors= RM.InProgressMentorRecommmendations(mContext);
    			LoadingHandler.sendEmptyMessage(21);
    		}
    		
    		recentChats= RM.GetRecentChatsNew( mContext, SPUtil.getString(mContext, "AccountID") );    		
    		
    		LoadingHandler.sendEmptyMessage(30);
    		
    		
    		
    	}
    	catch (Exception ex)
    	{
    		ex.toString();
    	}
    }
    
	public Handler LoadingHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==10)
			{
		        LoadingDL.setMessage("연결된 멘티를 불러오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
			}
			else if(msg.what==11)
			{
		        LoadingDL.setMessage("연결된 멘토를 불러오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
			}
			else if(msg.what==20)
			{
				for(MenteeInfo tee : InProgress_tees)
				{
					arraylist.add( new RecentTalkEntry(false, "0", tee.getAccountId(), tee.getName(), "대화내용 없음","0", "현재시각" ) );
				}
				
				LoadingDL.setMessage("최근 대화를 불러오는 중");
		        LoadingDL.show();
			}
			else if(msg.what==21)
			{
				for(MentorInfo tor : InProgress_tors)
				{
					arraylist.add( new RecentTalkEntry(false, "0", tor.getAccountId(), tor.getName(), "대화내용 없음","0", "현재시각" ) );
				}
				
				LoadingDL.setMessage("최근 대화를 불러오는 중");
		        LoadingDL.show();
			}
			else if(msg.what==30)
			{
				LoadingDL.hide();
				
				String oppoID, oppoName;
				
				for(RecentChat RC : recentChats)	// 최근 대화 내용을 가져온 것중에
				{
					String myid= SPUtil.getString(mContext, "AccountID");
					String sess= SPUtil.getString(mContext, "Session");
					RequestMethods RM= new RequestMethods();
					
					if( SPUtil.getBoolean(mContext, "isMentor") )
					{	
						if(RC.getSenderAccount().equals( myid )) // 보낸이가 자신의ID면...
						{
							oppoID= RC.getReceiverAccount();
							oppoName= RM.GetMenteeInfo(mContext, myid, oppoID, sess).getName();
						}else{
							oppoID= RC.getSenderAccount();
							oppoName= RM.GetMenteeInfo(mContext, myid, oppoID, sess).getName();
						}
					}else{
						if(RC.getSenderAccount().equals( myid )) // 보낸이가 자신의ID면...
						{
							oppoID= RC.getReceiverAccount();
							oppoName= RM.GetMentorInfo(mContext, myid, oppoID, sess).getName();
						}else{
							oppoID= RC.getSenderAccount();
							oppoName= RM.GetMentorInfo(mContext, myid, oppoID, sess).getName();
						}
					}
					
					for(int i=0; i<arraylist.size(); ++i)
					{
						if( arraylist.get(i).getOppoName().equals(oppoName))	
						{	// 지금 리스트에 추가하려고 하는 상대방ID가 이미 InProgress에서 추가된 리스트이면 제외시킨다.
							arraylist.remove(i);
						}
					}
					arraylist.add( new RecentTalkEntry(false, RC.getCount(), oppoID, oppoName, RC.getChat(), RC.getChatId(), RC.getDateTime()) );
				}
				
				list1 = new RecentTalkListAdapter(mContext, R.layout.entry_recent_talk, R.id.eName, arraylist);
			    setListAdapter(list1); 
			}
		}
	};
	
	
	public void onListItemClick(ListView l, View v, int pos, long id)
	{
		SelItem= pos;
		
		ChatMgr.setCurrOppoAccount( ( arraylist.get(pos).getAccountID() ) );
		ChatMgr.setCurrChatID( Integer.toString( DBMgr.CountDBRows(SPUtil.getString(mContext, "AccountID")+"_"+arraylist.get(pos).getAccountID(), "_id") ) );
		
		Intent intent=new Intent(mContext, InChatActivity.class);
		startActivityForResult(intent, Global.s_nIntent_InChat);
	}
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onDestroy()
	 */
	@Override
	public void onDestroy()
	{		
		DBMgr.DBClose();
		
		super.onDestroy();
	}
	
	
	

}
