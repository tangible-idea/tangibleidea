package com.tangibleidea.meeple.activity;

import java.util.List;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.server_response.LoginResponse;
import com.tangibleidea.meeple.util.Global;

public class FavoriteActivity extends ListActivity
{
	private ProgressDialog LoadingDL;
	List<MentorInfo> LIST_mentors= null;
	List<MenteeInfo> LIST_mentees= null;
	
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        
        LoadingDL = new ProgressDialog(this);
        
        this.GetFavoriteRelations();
    }
    
    
	private void GetFavoriteRelations()
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
            
            if( Global.s_Info.isMentor() )
            	LIST_mentees= RM.GetRelationsMentee();
            else
            	LIST_mentors= RM.GetRelationsMentor();        		
            
            if(LIST_mentors==null && LIST_mentees==null)
            { 
            	setListAdapter(new FavoriteNULLAdapter(this));
            	return;
            }
            
            if( Global.s_Info.isMentor() )
            {
            	if( LIST_mentees.size()==0 )
            		setListAdapter(new FavoriteNULLAdapter(this));
            	else
            		setListAdapter(new FavoriteAdapter(this));
            }else{
            	if(LIST_mentors.size()==0)
            		setListAdapter(new FavoriteNULLAdapter(this));
            	else
            		setListAdapter(new FavoriteAdapter(this));
            }
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
			}
		}
	};
    
    
    
    
    
    
    
    
    
    
    
    
    

    private class FavoriteAdapter extends BaseAdapter
    {
        public FavoriteAdapter(Context context)
        {
            mContext = context;
        }

        public int getCount()
        {
        	if( Global.s_Info.isMentor() )
        		return LIST_mentees.size();
        	else
        		return LIST_mentors.size();
        }

        @Override
        public boolean areAllItemsEnabled()
        {
            return false;
        }

        @Override
        public boolean isEnabled(int position)
        {
        	if( Global.s_Info.isMentor() )
        		return !LIST_mentees.get(position).getAccountId().startsWith("-");
        	else
        		return !LIST_mentors.get(position).getAccountId().startsWith("-");
        }

        public Object getItem(int position)
        {
            return position;
        }

        public long getItemId(int position)
        {
            return position;
        }

        public View getView(int position, View convertView, ViewGroup parent)
        {
            TextView tv;
            if (convertView == null)
            {
                tv = (TextView) LayoutInflater.from(mContext).inflate(
                        android.R.layout.simple_expandable_list_item_1, parent, false);
            }
            else
            {
                tv = (TextView) convertView;
            }
            if( Global.s_Info.isMentor() )
            	tv.setText( LIST_mentees.get(position).getAccountId() );
            else
            	tv.setText( LIST_mentors.get(position).getAccountId() );
            
            return tv;
        }

        private Context mContext;
    }
    
    
    
    private class FavoriteNULLAdapter extends BaseAdapter
    {
        public FavoriteNULLAdapter(Context context)
        {
            mContext = context;
        }
        public int getCount()
        {
            return 1;
        }
        @Override
        public boolean areAllItemsEnabled()
        {
            return false;
        }
        @Override
        public boolean isEnabled(int position)
        {
            return false;
        }
        public Object getItem(int position)
        {
            return position;
        }

        public long getItemId(int position)
        {
            return position;
        }

        public View getView(int position, View convertView, ViewGroup parent)
        {
            TextView tv;
            if (convertView == null)
            {
                tv = (TextView) LayoutInflater.from(mContext).inflate(
                        android.R.layout.simple_expandable_list_item_1, parent, false);
            }
            else
            {
                tv = (TextView) convertView;
            }
            tv.setText( "즐겨찾기된 상대가 없음" );
            return tv;
        }

        private Context mContext;
    }
    
}

