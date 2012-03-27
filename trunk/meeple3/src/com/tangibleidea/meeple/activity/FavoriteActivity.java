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
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.EnumMeepleStatus;
import com.tangibleidea.meeple.layout.FavoriteListAdapter;
import com.tangibleidea.meeple.layout.InfoEntry;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.SPUtil;

public class FavoriteActivity extends ListActivity
{	
	private ProgressDialog LoadingDL;
	private Context mContext;
	
	private TextView TXT_status;
	
	ArrayAdapter<InfoEntry> AA;
	final ArrayList<InfoEntry> arraylist= new ArrayList<InfoEntry>();
	List<MentorInfo> LIST_mentors= null;
	List<MenteeInfo> LIST_mentees= null;
	
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
     
        setContentView(R.layout.favorite_list);
        mContext= this;
        LoadingDL = new ProgressDialog(mContext);
        TXT_status= (TextView) findViewById(R.id.txt_favorite_status);
        
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
    		LoadingHandler.sendEmptyMessage(0);
    		
            RequestMethods RM= new RequestMethods();
            
            if( SPUtil.getBoolean(mContext, "isMentor") )
            	LIST_mentees= RM.GetRelationsMentee(mContext);
            else
            	LIST_mentors= RM.GetRelationsMentor(mContext);        		
            
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
		        LoadingDL.setMessage("정보를 가져오는 중");
		        LoadingDL.setIndeterminate(true);
		        LoadingDL.show();
			}
			else if(msg.what==1)
			{
				LoadingDL.hide();
				
				if(LIST_mentors==null && LIST_mentees==null)
	            {
					TXT_status.setText("추가된 미플이 없음");
					TXT_status.setVisibility(View.VISIBLE);
	            	return;
	            }
				
				if( SPUtil.getBoolean(mContext, "isMentor") )
				{
					for(MenteeInfo tee : LIST_mentees)
						arraylist.add( new InfoEntry( tee.getAccountId(), tee.getName(), tee.getSchool(), tee.getGrade(), -1, EnumMeepleStatus.E_NONE) );
									
				}else{
					for(MentorInfo tor : LIST_mentors)
						arraylist.add( new InfoEntry( tor.getAccountId(), tor.getName(), tor.getUniv(), tor.getMajor(), -1, EnumMeepleStatus.E_NONE) );
							
				}
				
				if(arraylist.size()==0)
				{
					TXT_status.setText("추가된 미플이 없음");
					TXT_status.setVisibility(View.VISIBLE);
				}else{
					TXT_status.setVisibility(View.GONE);
				}
				
				AA= new FavoriteListAdapter(mContext, R.layout.entry, R.id.eName, arraylist);
				setListAdapter(AA);
			}
		}
	};
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	public void onListItemClick(ListView l, View v, int pos, long id)
	{
		
	}
    
}

