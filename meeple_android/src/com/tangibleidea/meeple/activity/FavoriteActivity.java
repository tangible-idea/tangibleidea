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
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.EnumMeepleStatus;
import com.tangibleidea.meeple.layout.adapter.FavoriteListAdapter;
import com.tangibleidea.meeple.layout.adapter.MessageListAdapter;
import com.tangibleidea.meeple.layout.entry.InfoEntry;
import com.tangibleidea.meeple.layout.entry.MessageEntry;
import com.tangibleidea.meeple.server.Chat;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class FavoriteActivity extends ListActivity implements OnClickListener
{	
	private ProgressDialog LoadingDL;
	private Context mContext;
	private RequestMethods RM;
	
	private ImageView IMGBTN_friend, IMGBTN_message;
	
	private FavoriteListAdapter Adapter;
	private final ArrayList<InfoEntry> arraylist= new ArrayList<InfoEntry>();
	private List<MentorInfo> LIST_mentors= null;
	private List<MenteeInfo> LIST_mentees= null;
	
	private MessageListAdapter Adapter2;
	private final ArrayList<MessageEntry> arraylist2= new ArrayList<MessageEntry>();
	private List<Chat> LIST_message= null;
	
	private static boolean bFriend_subtab= true; 
	
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        
        RM= new RequestMethods();
        

     
        setContentView(R.layout.favorite_list);
        mContext= this;
        LoadingDL = new ProgressDialog(mContext);
        //TXT_status= (TextView) findViewById(R.id.txt_favorite_status);
        IMGBTN_friend= (ImageView) findViewById(R.id.subtap_friend);
        IMGBTN_message= (ImageView) findViewById(R.id.subtap_message);
        
        IMGBTN_friend.setOnClickListener(this);
        IMGBTN_message.setOnClickListener(this);
        
		ImageView view= new ImageView(mContext);
		view.setImageResource(R.drawable.title_blank_14);
		getListView().addHeaderView(view);
        
        if(bFriend_subtab)	// 서브탭이 즐겨찾기탭이면
        {
			IMGBTN_friend.setImageResource(R.drawable.fav_tabbtn_meeplefriend_pre);
			IMGBTN_message.setImageResource(R.drawable.fav_tabbtn_note_nor);
        	GetFavoriteRelations();
        }
        else
        {
        	IMGBTN_friend.setImageResource(R.drawable.fav_tabbtn_meeplefriend_nor);
			IMGBTN_message.setImageResource(R.drawable.fav_tabbtn_note_pre);
        	GetMessages();
        }
    }
    
    
	public void GetFavoriteRelations()
	{
    	Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
	public void GetMessages()
	{
    	Thread thread = new Thread(null, BackgroundThread2, "Background");
    	thread.start();
	}


	
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{
    		
    		
    		if(Global.s_LIST_Relations.isEmpty())	// 다른 곳에서 받아온 관계가 없으면 새로 받아온다.
    		{
    			LoadingHandler.sendEmptyMessage(0);
	    		GetFavoriteRelationsProcessing();
	    		LoadingHandler.sendEmptyMessage(1);
    		}
			else	// 이미 가져온 것이 있으면..	// 그것을 넣어준다.
			{
				arraylist.clear();
				arraylist.addAll(Global.s_LIST_Relations);
				LoadingHandler.sendEmptyMessage(2);	// 어댑터에 세팅만 해준다.
			}
    		
		}
    };
    
    private Runnable BackgroundThread2 = new Runnable()
    {
    	public void run()
    	{

			LoadingHandler.sendEmptyMessage(10);
    		
    		LIST_message= RM.GetMessages(mContext);
    		
    		if(LIST_message != null)	// 서버로부터 쪽지정보가 왔으면..
    			LoadingHandler.sendEmptyMessage(11);
    		else
    		{
    			if(!RM.CheckLogin(mContext))
    			{
	    			LoadingHandler.sendEmptyMessage(-1);
    			}
    		}

    	}
    };
    
    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
    private void GetFavoriteRelationsProcessing()
    {
    	try 
    	{   
            if( SPUtil.getBoolean(mContext, "isMentor") )
            	LIST_mentees= RM.GetRelationsMentee(mContext);
            else
            	LIST_mentors= RM.GetRelationsMentor(mContext);
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
			if(msg.what==-1)
			{
				LoadingDL.hide();
				Intent intent= new Intent(mContext, LoginActivity.class);
				intent.putExtra("logout_session", true);
				startActivity(intent);
			}
			if(msg.what==0)
			{
		        LoadingDL.setMessage("상대방 정보를 가져오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
		        
		        arraylist.clear();
			}
			else if(msg.what==1)
			{
				LoadingDL.hide();
				
				if(LIST_mentors==null && LIST_mentees==null)	// 가져온 것이 없으면 패스
	            	return;
				
				if( SPUtil.getBoolean(mContext, "isMentor") )
				{
					for(MenteeInfo tee : LIST_mentees)
						arraylist.add( new InfoEntry( tee.getAccountId(), tee.getName(), tee.getSchool(), tee.getGrade(),tee.getComment(), -1, EnumMeepleStatus.E_NONE) );
									
				}else{
					for(MentorInfo tor : LIST_mentors)
						arraylist.add( new InfoEntry( tor.getAccountId(), tor.getName(), tor.getUniv(), tor.getMajor(),tor.getComment(), -1, EnumMeepleStatus.E_NONE) );
							
				}
				
				Adapter= new FavoriteListAdapter(mContext, R.layout.entry_favorite, R.id.eName, arraylist);
				setListAdapter(Adapter);
			}
			else if(msg.what==2)
			{
				Adapter= new FavoriteListAdapter(mContext, R.layout.entry_favorite, R.id.eName, arraylist);
				setListAdapter(Adapter);
			}
			
			else if(msg.what==10)
			{
		        LoadingDL.setMessage("쪽지를 가져오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
		        
		        arraylist2.clear();
			}
			else if(msg.what==11)
			{
				LoadingDL.hide();
				

				for(Chat C : LIST_message)
				{
					if(C.getSenderAccount().equals( SPUtil.getString(mContext, "AccountID") ))	// 내가 보냈으면...
						arraylist2.add(new MessageEntry(true, C.getReceiverAccount(), C.getChat(), C.getDateTime()));
					else
						arraylist2.add(new MessageEntry(false, C.getSenderAccount(), C.getChat(), C.getDateTime()));					
				}

				Adapter2= new MessageListAdapter(mContext, R.layout.entry_messages, R.id.eName, arraylist2);
				setListAdapter(Adapter2);
			}
		}
	};
    
    
    
    
    
	public void onListItemClick(ListView l, View v, int pos, long id)
	{
		if(pos==0)
			return;
		
		if(bFriend_subtab)	// 친구 탭일 때는
		{
			InfoEntry e= arraylist.get(pos-1);
			
			Intent intent= new Intent(mContext, PopupActivity.class);
			intent.putExtra("id", e.getID() );
			intent.putExtra("name", e.getName() );
			intent.putExtra("profile", e.getSchool() );
			intent.putExtra("comment", e.getComment() );
			
			intent.putExtra("recommandation", "T");	// 즐겨찾기 창에서 클릭하면 쪽지보내기를 띄워준다.
			intent.putExtra("relation", "T");	// 즐겨찾기 창에서 클릭했다는 건 무조건 친구사이라는 거다.
			
			mContext.startActivity(intent);
		}
		else	// 쪽지 탭일 때는 
		{
			
		}
	}


	@Override
	public void onClick(View v)
	{
		
		if(v.getId()==R.id.subtap_friend)
		{
			if(!bFriend_subtab)
			{
				bFriend_subtab= true;
				IMGBTN_friend.setImageResource(R.drawable.fav_tabbtn_meeplefriend_pre);
				IMGBTN_message.setImageResource(R.drawable.fav_tabbtn_note_nor);
				
				GetFavoriteRelations();
			}
		}
		
		if(v.getId()==R.id.subtap_message)
		{
			if(bFriend_subtab)
			{
				bFriend_subtab= false;
				IMGBTN_friend.setImageResource(R.drawable.fav_tabbtn_meeplefriend_nor);
				IMGBTN_message.setImageResource(R.drawable.fav_tabbtn_note_pre);
				
				GetMessages();
			}
		}
		
		
	}
    
}

