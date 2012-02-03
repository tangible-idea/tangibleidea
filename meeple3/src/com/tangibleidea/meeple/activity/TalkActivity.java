package com.tangibleidea.meeple.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.ArrayAdapter;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.ProfileListAdapter;
import com.tangibleidea.meeple.layout.RecentTalkEntry;
import com.tangibleidea.meeple.layout.RecentTalkListAdapter;
import com.tangibleidea.meeple.server.RecentChat;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.Global;

public class TalkActivity extends ListActivity
{
	private int SelItem= -1;
	private Context mContext;
	private ProgressDialog LoadingDL;
	ArrayAdapter<RecentTalkEntry> list1;
	final ArrayList<RecentTalkEntry> arraylist= new ArrayList<RecentTalkEntry>();

	private List<RecentChat> recentChats;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		mContext= this;		
		LoadingDL = new ProgressDialog(this);
		setContentView(R.layout.recent_talk);
		
		this.GetRecentChats();
	}
	
	private void GetRecentChats()
	{
    	Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{	
    		backgroundThreadProcessing();
    	}
    };

    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
    private void backgroundThreadProcessing()
    {
    	try 
    	{
    		if( !arraylist.isEmpty() )
    			arraylist.clear();
    		
    		LoadingHandler.sendEmptyMessage(0);
    		
    		RequestMethods RM= new RequestMethods();
    		recentChats= RM.GetRecentChatsNew( Global.s_Info.isMentor() );    		
    		
    		LoadingHandler.sendEmptyMessage(1);
    		
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
			if(msg.what==0)
			{
		        LoadingDL.setMessage("최근 대화를 불러오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
			}
			else if(msg.what==1)
			{
				LoadingDL.hide();
				
				String oppoName;
				
				for(RecentChat RC : recentChats)
				{
					if(Global.s_Info.isMentor())
					{
						if(RC.getSenderAccount().equals( Global.s_Info.getMentorInfo().getAccountId())) // 보낸이가 자신의ID면...
						{
							oppoName= RC.getReceiverAccount();
						}else{
							oppoName= RC.getSenderAccount();
						}
					}else{
						if(RC.getSenderAccount().equals( Global.s_Info.getMenteeInfo().getAccountId())) // 보낸이가 자신의ID면...
						{
							oppoName= RC.getReceiverAccount();
						}else{
							oppoName= RC.getSenderAccount();
						}
					}
					
					arraylist.add( new RecentTalkEntry(false, RC.getCount(), oppoName, RC.getChat(), RC.getDateTime()) );
					
					 list1 = new RecentTalkListAdapter(mContext, R.layout.entry_recent_talk, R.id.eName, arraylist);
				     setListAdapter(list1); 
				}
			}
		}
	};
}
