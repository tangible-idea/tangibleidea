package com.tangibleidea.meeple.activity;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
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
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.DBManager;
import com.tangibleidea.meeple.layout.adapter.InChatListAdapter;
import com.tangibleidea.meeple.layout.entry.ChatEntry;
import com.tangibleidea.meeple.server.Chat;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.ChatManager;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class InChatActivity extends ListActivity implements OnClickListener, OnScrollListener
{
	private Thread GetThread, SendThread, PollingThread, FinishAndSaveChatThread;
	private RequestMethods RM;
	private ProgressDialog LoadingDL;
	
	private ChatManager ChatMgr= ChatManager.GetInstance();
	private Context mContext;
	private Button BTN_send, BTN_close;
	private EditText EDT_chat;
	private ProgressBar PGB_loading;
	
	private String strChat="";
	private boolean bPolling= true, bLoading= false;

	int retry= 0;
	List<Chat> chats, chats2;
	
	InChatListAdapter Adapter;
	ArrayList<ChatEntry> arraylist= new ArrayList<ChatEntry>();
	
	@Override
	protected void onResume()
	{	
		super.onResume();
		
		ChatMgr.AcceptC2DMuser();
		//getListView().setTranscriptMode(ListView.TRANSCRIPT_MODE_ALWAYS_SCROLL);
		
	}


	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		mContext= this;
		LoadingDL = new ProgressDialog(mContext);
		RM= new RequestMethods();
		ChatMgr.ResetChat();	// 채팅 범위 초기화
		chats2= new ArrayList<Chat>();
		

		
		setContentView(R.layout.inchat);
		
		Adapter = new InChatListAdapter(this, R.layout.entry_chat, R.id.eMyChat, arraylist);
        setListAdapter(Adapter);
       
        getListView().setOnScrollListener(this);
        getListView().setSelection(arraylist.size());	// 채팅의 마지막으로 스크롤한다.
		
        PGB_loading= (ProgressBar) findViewById(R.id.progress_chat_loading);
        PGB_loading.setVisibility(View.INVISIBLE);
        
        BTN_send= (Button) findViewById(R.id.btn_send);
		BTN_send.setOnClickListener(this);
		BTN_send.setEnabled(false);
		
		BTN_close= (Button) findViewById(R.id.btn_inchat_end);
		BTN_close.setOnClickListener(this);
		
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
		this.StartGetChatsThread();
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
	
	private void StartFinishThread()
	{
		FinishAndSaveChatThread= new Thread(null, FinishChatThread, "FinishAndSaveChatThread");
	}
	
    private Runnable FinishChatThread = new Runnable()	// 채팅목록을 가져오는 스레드
    {
    	public void run()
    	{
    		UIHandler.sendEmptyMessage(10);	// 대화를 저장한다.
    		
    		DBManager DBMgr= new DBManager(mContext);    		
    		DBMgr.InsertEndChatInfo(ChatMgr.getCurrOppoAccount(), ChatMgr.getCurrOppoName(), GetChatsLastOne().getChat(), GetChatsLastOne().getDateTime());
    		
    		UIHandler.sendEmptyMessage(11);	// 대화를 저장한다.
    	}
    }; 
	
    
    private Runnable GetChatsThread = new Runnable()	// 채팅목록을 가져오는 스레드
    {
    	public void run()
    	{
    		GetChatsRange(ChatMgr.nChatRange);	// 지정된 범위만큼 채팅을 가져오자
    	}
    };
    
    // 범위만큼 채팅을 가져옴
    public void GetChatsRange(int range)
    {
    	UIHandler.sendEmptyMessage(99);
    	
		ChatMgr.setCurrChatID( RM.GetLastChatID(mContext, ChatMgr.getCurrOppoAccount()) );
		
		int nLastChatID= Integer.parseInt( ChatMgr.getCurrChatID() );
		
		if( nLastChatID < range )	// 채팅 개수가 25개(기본값) 미만이면
		{
			this.GetAllChats();
			ChatMgr.bChatEnd= true;
		}
		else
		{
			chats= RM.GetChatsNew(mContext, ChatMgr.getCurrOppoAccount(), Integer.toString(nLastChatID-range) );	// 현재채팅부터 25번째까지 가져옴

			if(chats==null)	// 가져오는데 실패하면 범위를 줄인다.
			{
				++retry;
				this.GetChatsRange(ChatMgr.nChatRange - retry*5);
				return;
			}
		}
		
		this.InsertDateRowsInChat();	// chats 리스트에 중간중간 날짜를 넣는다.
		
		ChatMgr.nChatRange= range;	// 현재 가져온 범위 등록 (성공한 경우만)		
		UIHandler.sendEmptyMessage(0); // UI 새로고침
    }
    
    // 채팅 마지막 한개만 가져온다.
    public Chat GetChatsLastOne()
    {
    	Chat res= null;

    	ChatMgr.setCurrChatID( RM.GetLastChatID(mContext, ChatMgr.getCurrOppoAccount()) );
    	int nLastChatID= Integer.parseInt( ChatMgr.getCurrChatID() );
    	
		res= RM.GetChatsNew(mContext, ChatMgr.getCurrOppoAccount(), Integer.toString(nLastChatID-1) ).get(0);
		
		return res;
    }
    
    // 모든 채팅을 다 가져온다.
    public void GetAllChats()
    {
		chats= RM.GetChatsNew(mContext, ChatMgr.getCurrOppoAccount(), "0");	// 채팅 전부 가져옴
		InsertDateRowsInChat();
    }
    
    //날짜가 달라질때마다 날짜정보를 넣어준다.
    private void InsertDateRowsInChat()
    {
    	if(!chats2.isEmpty())	// 비어있지 않으면 비운다.
    		chats2.clear();
    	
    	Date talkTime1= null;	// 대화시간1 (1row before)
    	Date talkTime2= null;	// 대화시간2 (현재 row)
    	
    	for(Chat C : chats)
    	{	
			try
			{
				SimpleDateFormat format= new SimpleDateFormat("yyyy.MM.dd a h:mm");
				
				if(talkTime1==null)	// 이전 시간에 대한 정보가 없으면
				{
					talkTime1= format.parse(C.getDateTime());	// 이전 시간 정보를 넣고
					chats2.add(new Chat(null, null, null, (1900+talkTime1.getYear())+"년 "+(1+talkTime1.getMonth())+"월 "+talkTime1.getDate()+"일", null));	// 처음 대화 시작한 날짜 라벨
					chats2.add(C);								// 처음대화는 그대로 복사한다.
					continue;
				}
				else
				{
					talkTime2= format.parse(C.getDateTime());	// 현재 시간 정보를 2번에 넣고
					if( talkTime1.getMonth()==talkTime2.getMonth() && talkTime1.getDate()==talkTime2.getDate() ) // 1번과 2번의 대화 날짜가 같으면
					{
						talkTime1= talkTime2;	// 2번을 1번에 넣고 다음으로 넘김
						chats2.add(C);			// 그대로 복사한다.
						continue;
					}
					else	// 날짜가 다르면 라벨을 끼워준다.
					{
						chats2.add(new Chat(null, null, null, (1900+talkTime2.getYear())+"년 "+(1+talkTime2.getMonth())+"월 "+talkTime2.getDate()+"일", null));
						chats2.add(C);
					}
					talkTime1= talkTime2;	// 2번을 1번에 넣고 다음으로 넘김
				}
			}
			catch (ParseException e)
			{
				e.printStackTrace();
			}
    	}
    }
    
    private Runnable SendChatsThread = new Runnable()
    {
    	public void run()
    	{	
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

////////////////////////////////////////////////////////////////////////////////    
// UI 업데이트 핸들러
////////////////////////////////////////////////////////////////////////////////
	public Handler UIHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==0)	// 받은 정보를 채팅UI로 업데이트 할 때
			{
				RefreshChatEntry();
			}
			else if(msg.what==1)	// 채팅이 전송 중일 때
			{
				EDT_chat.setText("");
				EDT_chat.setHint("전송중...");
				EDT_chat.setEnabled(false);
				BTN_send.setEnabled(false);
			}
			else if(msg.what==2)	// 채팅 전송을 마쳤을 때
			{
				EDT_chat.setHint("");
				EDT_chat.setEnabled(true);
				BTN_send.setEnabled(false);
			} 
			else if(msg.what==10)	// 채팅을 끝내서 DB에 저장할 때
			{
				LoadingDL.setMessage("끝난 대화를 저장하고 있습니다...\n대화탭에서 끝난 대화를 다시 볼 수 있습니다.");
				LoadingDL.show();
			}
			else if(msg.what==11)	// 채팅이 DB에 저장 끝낫을 때
			{
				LoadingDL.hide();
			}
			else if(msg.what==99)	// 위로 스크롤 하여 이전 채팅을 로딩할 때
			{
				SetLoadingLock(true);
			}
			else if(msg.what==100)	// 이전 채팅의 로딩을 마쳣을 때
			{
				SetLoadingLock(false);
			}
		}
	};
////////////////////////////////////////////////////////////////////////////////
	
	private void SendChat()
	{
		strChat= EDT_chat.getText().toString();
		UIHandler.sendEmptyMessage(1); // 채팅 새로고침
		this.StartSendChatThread();
	}
	
	private void RefreshChatEntry()
	{		
		Global.s_HasNewChat= false;	// 
		retry= 0; // 채팅 가져오기 실패횟수 초기화
		
		arraylist.clear();
		Adapter.clear();
		
		this.ChatEntrySet();	// 채팅 엔트리 설정		
	}
	
	/**
	 * 가져온 채팅을 리스트로 세팅한다.
	 */
	public void ChatEntrySet()
	{
		if(chats2==null)
			return;
		
		try
		{
			for(Chat C : chats2)
			{
				if( C.getSenderAccount() == null )	// 보낸이 없으면 날짜라벨이므로 패스
				{
					arraylist.add(new ChatEntry(false, null, C.getDateTime()));
					continue;
				}
				
				boolean bMyChat;
				if( C.getSenderAccount().equals( SPUtil.getString(mContext, "AccountID") ))	// 보낸이가 자신이면 내 채팅이다.
				{
					bMyChat= true;
				}else{
					bMyChat= false;
				}
				
				arraylist.add(new ChatEntry(bMyChat, C.getChat(), C.getDateTime()));
			}
		}
		catch(Exception e)
		{
			
		}
		
		UIHandler.sendEmptyMessage(100);
		
	}
	
	@Override
	public void onClick(View v)
	{
		if(v.getId()==R.id.btn_send)
			this.SendChat();
		
		if(v.getId()==R.id.btn_inchat_end)
		{
			new AlertDialog.Builder(this)
	        .setTitle("[대화 끝내기]")
	        .setMessage("상대방과 더 이상 대화를 할 수 없게 됩니다.\n종료하시겠습니까?") 
	        .setPositiveButton("종료", new DialogInterface.OnClickListener()
	        {
	            public void onClick(DialogInterface dialog, int whichButton)
	            {
	            	StartFinishThread();	// 끝낸 대화 정보를 저장한다.
	    			RM.CloseChatting(mContext, ChatMgr.getCurrOppoAccount());
	    			finish();
	            }
	        })
	        .setNegativeButton("계속", new DialogInterface.OnClickListener()
	        {
	        	public void onClick(DialogInterface dialog, int whichButton)
	            {
	            }
	        })
	        .show();
			

		}
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onDestroy()
	 */
	@Override
	protected void onDestroy()
	{		
		boolean retry = true;
				
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


	@Override
	public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount)
	{
		//Log.d("InChatActivity", Integer.toString(firstVisibleItem) );
		if(firstVisibleItem==0 && !(totalItemCount <= visibleItemCount) )	// 총리스트수가 화면에 보이는 리스트수보다 적거나 같지 않으면
		{
			if(!bLoading && !ChatMgr.bChatEnd)
			{
				ChatMgr.AddRange(25);	// 범위 늘리고
				StartGetChatsThread();	// 다시 목록 가져옴.
			}
		}
		
	}


	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState)
	{
		// TODO Auto-generated method stub
		
	}


	private void SetLoadingLock(boolean bLock)
	{
//		LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//        View v = li.inflate(R.layout.header_progress, null);
        
		if(bLock)
		{
			bLoading= true;	// 목록 가져오는 동안 Lock
			PGB_loading.setVisibility(View.VISIBLE);
			//getListView().addHeaderView(v);
		}
		else
		{
			//getListView().removeHeaderView(v);
			bLoading= false;	// 목록 다 가져오고 세팅도 했으니 lock해제
			PGB_loading.setVisibility(View.INVISIBLE);
			
		}
	}

}
