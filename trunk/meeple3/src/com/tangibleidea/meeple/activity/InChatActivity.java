package com.tangibleidea.meeple.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.DBManager;
import com.tangibleidea.meeple.server.Chat;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.ChatManager;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class InChatActivity extends ListActivity implements OnClickListener
{
	private DBManager DBMgr;
	private Thread GetThread, SendThread, PollingThread;
	
	private ChatManager ChatMgr= ChatManager.GetInstance();
	private Context mContext;
	private Button BTN_send;
	private EditText EDT_chat;
	
	private String strChat="";
	private boolean bPolling= true;
	


	List<Chat> chats;
//	ArrayAdapter<ChatEntry> AA;
//	ArrayList<ChatEntry> arraylist= new ArrayList<ChatEntry>();
	
    private ArrayAdapter<String> mAdapter;    
    private ArrayList<String> mStrings = new ArrayList<String>();
	
	
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onResume()
	 */
	@Override
	protected void onResume()
	{
		DBMgr= new DBManager(this);
		ChatMgr.AcceptC2DMuser();
		super.onResume();
	}


	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		
		
		setContentView(R.layout.inchat);
		
//		AA = new ChatListAdapter(this, R.layout.entry_chat, R.id.eMyChat, arraylist);
//        setListAdapter(AA);
        
        mAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, mStrings);    
        setListAdapter(mAdapter);

		mContext= this;
		
		BTN_send= (Button) findViewById(R.id.btn_send);
		BTN_send.setOnClickListener(this);
		BTN_send.setEnabled(false);
		
		EDT_chat= (EditText) findViewById(R.id.edt_content);
		
		EDT_chat.setOnEditorActionListener(new OnEditorActionListener()
		{
			public boolean onEditorAction(TextView v, int actionId, KeyEvent event)
			{
			if( (actionId == EditorInfo.IME_ACTION_NEXT) ||
			    (actionId == EditorInfo.IME_ACTION_DONE) ||
				(event != null && event.getKeyCode() == KeyEvent.KEYCODE_ENTER))
				{
					//SendChat();
				}
				return false;
			}
		});
		
		EDT_chat.addTextChangedListener(new TextWatcher()
		{

			public void afterTextChanged(Editable arg0)
			{ }
			public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{ }
			public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{
				if(arg0.equals(""))
				{
					BTN_send.setEnabled(false);
				}else{
					BTN_send.setEnabled(true);
					
				}				
			}			
		});
		
		Global.s_HasNewChat= true;
		this.StartPollingThread();
	}
	
	private void StartGetChatsThread()
	{
    	GetThread = new Thread(null, GetChatsThread, "GetChatsThread");
    	GetThread.start();
	}
	
	private void StartSendChatThread()
	{
    	SendThread = new Thread(null, SendChatsThread, "SendChatsThread");
    	SendThread.start();
	}
	
	private void StartPollingThread()
	{
    	PollingThread = new Thread(null, PollingChatThread, "PollingThread");
    	PollingThread.start();
	}
	
    
    private Runnable GetChatsThread = new Runnable()	// 채팅목록을 가져오는 스레드
    {
    	public void run()
    	{	
    		String TableName= SPUtil.getString(mContext, "AccountID")+"_"+ChatMgr.getCurrOppoAccount();    		
        	RequestMethods RM= new RequestMethods();
        	
        	
        	ChatMgr.setCurrChatID( Integer.toString( DBMgr.CountDBRows(TableName, "_id") ) );	// 채팅목록을 어디까지 가져왔나?
        	chats= RM.GetChatsNew(mContext, ChatMgr.getCurrOppoAccount(), ChatMgr.getCurrChatID());	// 서버에서 채팅내용 가져옴
        	DBMgr.PutChatDB(TableName, chats);	// 가져온 것을 DB에 채팅내용 삽입
        	ChatMgr.setCurrChatID( Integer.toString( DBMgr.CountDBRows(TableName, "_id") ) );	// 채팅목록을 어디까지 가져왔나?
        	
        	UIHandler.sendEmptyMessage(0); // UI 새로고침
    	}
    };
    
    private Runnable SendChatsThread = new Runnable()
    {
    	public void run()
    	{	
    		//String TableName= SPUtil.getString(mContext, "AccountID")+"_"+Global.s_CurrOppoAccount;
    		RequestMethods RM= new RequestMethods();
    		
    		RM.SendChatNew(mContext, ChatMgr.getCurrOppoAccount(), strChat);
    		
    		StartGetChatsThread();	// 서버에서 새로운 채팅을 가져온다.
    		
    		UIHandler.sendEmptyMessage(2); // 다시 채팅 가능
    	}
    };
    
    private Runnable PollingChatThread = new Runnable()
    {
    	public void run()
    	{	
	    	while(bPolling)
	    	{
    			try
    			{
					Thread.sleep(1000);	 // 1초마다 확인함
				}
    			catch (InterruptedException e)
				{	e.printStackTrace();	}
    			
	    		if(!Global.s_HasNewChat)	// 새로운 채팅이 없으면 그냥 넘어감
	    			continue;
	    		
    			StartGetChatsThread(); 

    			
    			Global.s_HasNewChat= false;
	    	}
    	}
    };

    
    

	public Handler UIHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==0)
			{
				RefreshChatEntry();
			}
			else if(msg.what==1)
			{
				EDT_chat.setText("");
				EDT_chat.setHint("전송중...");
				EDT_chat.setEnabled(false);				
			}
			else if(msg.what==2)
			{
				EDT_chat.setHint("");
				EDT_chat.setEnabled(true);
				BTN_send.setEnabled(false);
			}
		}
	};
	
	private void SendChat()
	{
		strChat= EDT_chat.getText().toString();
		UIHandler.sendEmptyMessage(1); // 채팅 새로고침
		this.StartSendChatThread();
	}
	
	private void RefreshChatEntry()
	{		
//		arraylist.clear();
//		//AA.clear();
//
//		String TableName= SPUtil.getString(mContext, "AccountID")+"_"+Global.s_CurrOppoAccount;
//		
//		arraylist= DBMgr.GetChatToArrayList(this, TableName);	// DB채팅목록을 가져와서 리스트에 세팅함
//		
//		if(arraylist==null)
//			return;
//				
//		for( ChatEntry CE : arraylist )
//		{
//			AA.add(CE);
//		}
//		
//		Global.s_HasNewChat= false;
//		AA.notifyDataSetChanged();
		
		mStrings.clear();
		
		String TableName= SPUtil.getString(mContext, "AccountID")+"_"+ChatMgr.getCurrOppoAccount();
		
		mStrings= DBMgr.GetChatToArrayListTEST(this, TableName);	// DB채팅목록을 가져와서 리스트에 세팅함
		
		if(mStrings==null)
			return;
			
		for( String str : mStrings )
		{
			mAdapter.add(str);
		}
		
		Global.s_HasNewChat= false;
		mAdapter.notifyDataSetChanged();
	}

	@Override
	public void onClick(View v)
	{
		this.SendChat();
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onDestroy()
	 */
	@Override
	protected void onDestroy()
	{		
		boolean retry = true;
		
		DBMgr.DBClose();
		
		bPolling= false;	// 루프를 멈추고		
        while (retry)
        {
            try
            {
            	PollingThread.join();	// 끝나기를 기다림
                retry = false;
            }
            catch (InterruptedException e)
            {
            	Log.e(Global.LOG_TAG, e.toString());
            }
        }
        
        PollingThread= null;
        
		super.onDestroy();
	}



}
