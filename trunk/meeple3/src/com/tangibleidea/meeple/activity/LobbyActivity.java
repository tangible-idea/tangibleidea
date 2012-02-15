package com.tangibleidea.meeple.activity;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.fragment.FavoriteListFragment;
import com.tangibleidea.meeple.fragment.MeepleListFragment;
import com.tangibleidea.meeple.fragment.RecentTalkListFragment;
import com.tangibleidea.meeple.layout.ViewPageAdapter;

public class LobbyActivity extends FragmentActivity implements OnClickListener, OnPageChangeListener
{
	private MeepleListFragment FRG_meeple;
	private RecentTalkListFragment FRG_talk;
	private FavoriteListFragment FRG_favorite;
	private Button BTN_meeple, BTN_talk, BTN_favorite, BTN_setting;
    ViewPageAdapter mAdapter;
    ViewPager mPager;
    
    /* (non-Javadoc)
	 * @see android.support.v4.app.FragmentActivity#onSaveInstanceState(android.os.Bundle)
	 */
	@Override
	protected void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);
		getSupportFragmentManager()
        .putFragment(outState, MeepleListFragment.class.getName(), FRG_meeple);
	}

	@Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
	
	    setContentView(R.layout.viewpager);
	    
	    FRG_talk= new RecentTalkListFragment();
	    FRG_favorite= new FavoriteListFragment();
	    
	    mAdapter = new ViewPageAdapter(getSupportFragmentManager());
	
	    mPager = (ViewPager)findViewById(R.id.pager);
	    mPager.setAdapter(mAdapter);
	    
	    mPager.setOnPageChangeListener(this);
	    
	    BTN_meeple= (Button) findViewById(R.id.page_meeple);
	    BTN_talk= (Button) findViewById(R.id.page_talk);
	    BTN_favorite= (Button) findViewById(R.id.page_favorite);
	    BTN_setting= (Button) findViewById(R.id.page_setting);
	    
	    BTN_meeple.setOnClickListener(this);
	    BTN_talk.setOnClickListener(this);
	    BTN_favorite.setOnClickListener(this);
	    BTN_setting.setOnClickListener(this);
	    
    }

	@Override
	public void onClick(View v)
	{
		if(v.getId()==R.id.page_meeple)
		{
			mPager.setCurrentItem(0);
		}
		else if(v.getId()==R.id.page_talk)
		{
			mPager.setCurrentItem(1);
		}
		else if(v.getId()==R.id.page_favorite)
		{
			mPager.setCurrentItem(2);
		}
		else if(v.getId()==R.id.page_setting)
		{
			
		}
	}

	@Override
	public void onPageScrollStateChanged(int arg0)
	{
		
	}

	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2)
	{
		
	}

	@Override
	public void onPageSelected(int pos)
	{
		if(pos==0)
			FRG_meeple.LoadingMeeplesInfo();
		else if(pos==1)
			FRG_talk.GetRecentChats();
		else if(pos==2)
			FRG_favorite.GetFavoriteRelations();
			
	}

}
