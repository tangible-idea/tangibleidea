package com.tangibleidea.meeple.activity;

import java.util.ArrayList;

import android.app.ListActivity;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.Notice;
import com.tangibleidea.meeple.server.RequestMethods;


/**
 * A list view example where the 
 * data comes from a custom
 * ListAdapter
 */
public class NoticeActivity extends ListActivity 
{
	private RequestMethods RM;
    
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        
        ArrayList<Notice> notices= new ArrayList<Notice>();
        RM= new RequestMethods();
        notices.clear();
        notices.addAll( RM.GetNotices() );	// 공지사항 가져옴
        
        setContentView(R.layout.notice);
        // Use our own list adapter
        setListAdapter(new NoticeListAdapter(this, notices));

    }
        
    
    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) 
    {    
       ((NoticeListAdapter)getListAdapter()).toggle(position);
    }
    
    /**
     * A sample ListAdapter that presents content
     * from arrays of speeches and text.
     *
     */
    private class NoticeListAdapter extends BaseAdapter
    {
    	private ArrayList<Notice> arrNotice= new ArrayList<Notice>();
    	
        public NoticeListAdapter(Context context, ArrayList<Notice> notice)
        {
        	arrNotice= notice;
            mContext = context;
        }

        
        /**
         * The number of items in the list is determined by the number of speeches
         * in our array.
         * 
         * @see android.widget.ListAdapter#getCount()
         */
        public int getCount()
        {
            return arrNotice.size();
        }

        /**
         * Since the data comes from an array, just returning
         * the index is sufficent to get at the data. If we
         * were using a more complex data structure, we
         * would return whatever object represents one 
         * row in the list.
         * 
         * @see android.widget.ListAdapter#getItem(int)
         */
        public Object getItem(int position)
        {
            return position;
        }

        /**
         * Use the array index as a unique id.
         * @see android.widget.ListAdapter#getItemId(int)
         */
        public long getItemId(int position)
        {
            return position;
        }

        /**
         * Make a SpeechView to hold each row.
         * @see android.widget.ListAdapter#getView(int, android.view.View, android.view.ViewGroup)
         */
        public View getView(int position, View convertView, ViewGroup parent)
        {
            NoticeView sv;
            if (convertView == null)
            {
            	Notice notice= arrNotice.get(position);
                sv = new NoticeView(mContext, notice.getTitle(), notice.getContent(), notice.getDate(), notice.isExpand());
            }
            else
            {
            	Notice notice= arrNotice.get(position);
                sv = (NoticeView)convertView;
                sv.setTitle( notice.getTitle() );
                sv.setDialogue( notice.getContent() );
                sv.setExpanded( notice.isExpand() );
            }
            
            return sv;
        }

        public void toggle(int position)
        {
        	arrNotice.get(position).setExpand( !arrNotice.get(position).isExpand() );
            //mExpanded[position] = !mExpanded[position];
            notifyDataSetChanged();
        }
        
        /**
         * Remember our context so we can use it when constructing views.
         */
        private Context mContext;
        
    }
    
    /**
     * We will use a SpeechView to display each speech. It's just a LinearLayout
     * with two text fields.
     *
     */
    private class NoticeView extends LinearLayout
    {
    	
    	private ImageView mTreeButton; 
        private TextView mTitle, mDate;
        private TextView mDialogue;
        
        public NoticeView(Context context, String title, String content, String date, boolean expanded)
        {
            super(context);
            
            this.setOrientation(VERTICAL);
            
            
            // Here we build the child views in code. They could also have
            // been specified in an XML file.
            RelativeLayout RL_Title= new RelativeLayout(context);
            RL_Title.setBackgroundColor(Color.rgb(230, 230, 230));
            
            	RelativeLayout RL_ButtonView= new RelativeLayout(context);
            	RL_ButtonView.setBackgroundColor(Color.rgb(205, 205, 205));
            	
	            	RelativeLayout.LayoutParams btnParam= new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
	            	btnParam.addRule(RelativeLayout.CENTER_IN_PARENT);
	            	
	            	mTreeButton= new ImageView(context);
            		mTreeButton.setImageResource(R.drawable.notice_subject_plus);
	            	
            	RL_ButtonView.addView(mTreeButton, btnParam);
            	
            	RelativeLayout.LayoutParams tvParam= new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
            	//tvParam.addRule(RelativeLayout.RIGHT_OF, RL_ButtonView.getId());
            	tvParam.leftMargin= 100;
            	tvParam.addRule(RelativeLayout.CENTER_VERTICAL);
            	
	            mTitle = new TextView(context);
	            mTitle.setText(title);
	            mTitle.setTextSize(18.0f);
	            mTitle.setTextColor(Color.BLACK);
	            //mTitle.setPadding(0, 17, 0, 0);
	            
	            RelativeLayout.LayoutParams dateParam= new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
	            dateParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
	            dateParam.rightMargin= 20;
	            dateParam.addRule(RelativeLayout.CENTER_VERTICAL);
	            
	            mDate = new TextView(context);
	            mDate.setText(date);
	            mDate.setTextSize(12.0f);
	            mDate.setTextColor(Color.rgb(121, 90, 31));
	            //mDate.setPadding(0, 20, 0, 0);
            
            RL_Title.addView(RL_ButtonView, new RelativeLayout.LayoutParams(84, 88));
            RL_Title.addView(mTitle, tvParam);
            RL_Title.addView(mDate, dateParam);
            addView(RL_Title, new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
            
            mDialogue = new TextView(context);
            mDialogue.setText(content);
            mDialogue.setTextColor(Color.BLACK);
            mDialogue.setTextSize(16.3f);
            mDialogue.setBackgroundResource(R.drawable.notice_content_box);
            addView(mDialogue, new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
            
            mDialogue.setVisibility(expanded ? VISIBLE : GONE);
        }
        
        /**
         * Convenience method to set the title of a SpeechView
         */
        public void setTitle(String title) {
            mTitle.setText(title);
        }
        
        /**
         * Convenience method to set the dialogue of a SpeechView
         */
        public void setDialogue(String words) {
            mDialogue.setText(words);
        }
        
        /**
         * Convenience method to expand or hide the dialogue
         */
        public void setExpanded(boolean expanded)
        {
        	if(expanded)
        		mTreeButton.setImageResource(R.drawable.notice_subject_minus);
        	else
        		mTreeButton.setImageResource(R.drawable.notice_subject_plus);
            mDialogue.setVisibility(expanded ? VISIBLE : GONE);
        }
        

    }
}
