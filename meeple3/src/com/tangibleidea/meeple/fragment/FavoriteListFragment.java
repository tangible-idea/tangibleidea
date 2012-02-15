package com.tangibleidea.meeple.fragment;

import java.util.ArrayList;
import java.util.List;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.EnumMeepleStatus;
import com.tangibleidea.meeple.layout.FavoriteListAdapter;
import com.tangibleidea.meeple.layout.InfoEntry;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.SPUtil;

public class FavoriteListFragment extends ListFragment
{	
	private ProgressDialog LoadingDL;
	private Context mContext;
	ArrayAdapter<InfoEntry> AA;
	final ArrayList<InfoEntry> arraylist= new ArrayList<InfoEntry>();
	List<MentorInfo> LIST_mentors= null;
	List<MenteeInfo> LIST_mentees= null;
	
    public static FavoriteListFragment newInstance()
    {
    	FavoriteListFragment f= new FavoriteListFragment();
        return f;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        View v = inflater.inflate(R.layout.favorite_list, container, false);
        return v;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState)
    {
        super.onActivityCreated(savedInstanceState);
    }
	
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        
        mContext= this.getActivity();
        LoadingDL = new ProgressDialog(mContext);
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
				
				AA= new FavoriteListAdapter(mContext, R.layout.entry, R.id.eName, arraylist);
				setListAdapter(AA);
			}
		}
	};
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	public void onListItemClick(ListView l, View v, int pos, long id)
	{
		
	}
    
}

