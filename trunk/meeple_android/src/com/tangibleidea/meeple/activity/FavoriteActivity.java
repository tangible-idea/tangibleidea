package com.tangibleidea.meeple.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.EnumMeepleStatus;
import com.tangibleidea.meeple.layout.FavoriteListAdapter;
import com.tangibleidea.meeple.layout.entry.InfoEntry;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.SPUtil;

public class FavoriteActivity extends ListActivity implements OnClickListener
{	
	private ProgressDialog LoadingDL;
	private Context mContext;
	
	private ImageView IMGBTN_friend, IMGBTN_message;
	
	private FavoriteListAdapter Adapter;
	private final ArrayList<InfoEntry> arraylist= new ArrayList<InfoEntry>();
	private List<MentorInfo> LIST_mentors= null;
	private List<MenteeInfo> LIST_mentees= null;
	
	private boolean bFriend_subtab= true; 
	
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
     
        setContentView(R.layout.favorite_list);
        mContext= this;
        LoadingDL = new ProgressDialog(mContext);
        //TXT_status= (TextView) findViewById(R.id.txt_favorite_status);
        IMGBTN_friend= (ImageView) findViewById(R.id.subtap_friend);
        IMGBTN_message= (ImageView) findViewById(R.id.subtap_message);
        
        IMGBTN_friend.setOnClickListener(this);
        IMGBTN_message.setOnClickListener(this);
        
        GetFavoriteRelations();
    }
    
    
	public void GetFavoriteRelations()
	{
    	Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}


	
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{
    		LoadingHandler.sendEmptyMessage(0);
    		
    		backgroundThreadProcessing();
    		
    		LoadingHandler.sendEmptyMessage(1);
    	}
    };
    
    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
    private void backgroundThreadProcessing()
    {
    	try 
    	{
            RequestMethods RM= new RequestMethods();
            
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
			if(msg.what==0)
			{
		        LoadingDL.setMessage("정보를 가져오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
			}
			else if(msg.what==1)
			{
				LoadingDL.hide();
				
				if(LIST_mentors==null && LIST_mentees==null)
	            {
					//TXT_status.setText("추가된 미플이 없음");
					//TXT_status.setVisibility(View.VISIBLE);
	            	return;
	            }
				
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
		}
	};
    
    
    
    
    
	public void onListItemClick(ListView l, View v, int pos, long id)
	{
		
	}


	@Override
	public void onClick(View v)
	{
		
		if(v.getId()==R.id.subtap_friend)
		{
			bFriend_subtab= true;
			IMGBTN_friend.setImageResource(R.drawable.fav_tapbtn_meeplefriend_pre);
			IMGBTN_message.setImageResource(R.drawable.fav_tapbtn_note_nor);
		}
		
		if(v.getId()==R.id.subtap_message)
		{
			bFriend_subtab= false;
			IMGBTN_friend.setImageResource(R.drawable.fav_tapbtn_meeplefriend_nor);
			IMGBTN_message.setImageResource(R.drawable.fav_tapbtn_note_pre);
		}
		
		
	}
    
}

