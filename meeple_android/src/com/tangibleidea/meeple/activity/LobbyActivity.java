package com.tangibleidea.meeple.activity;

import android.app.ActivityGroup;
import android.app.LocalActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TabHost;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.util.Global;

public class LobbyActivity extends ActivityGroup
{
	public static TabHost s_TabHost;
	
	private void setupTabHost()
	{
		s_TabHost = (TabHost) findViewById(android.R.id.tabhost);
		LocalActivityManager LAM = getLocalActivityManager();
		s_TabHost.setup(LAM);
	}
	
    /* (non-Javadoc)
	 * @see android.app.ActivityGroup#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.lobby_tap);

		setupTabHost();
		//mTabHost.getTabWidget().setDividerDrawable(R.drawable.tab_divider);

		
		setupTab(new TextView(this), "tab1", new Intent(this, MeepleListActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP));
		setupTab(new TextView(this), "tab2", new Intent(this, RecentTalkListActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP));
		setupTab(new TextView(this), "tab3", new Intent(this, FavoriteActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP));
		setupTab(new TextView(this), "tab4", new Intent(this, ProfileSettingActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP));
	}

	/* (non-Javadoc)
	 * @see android.app.ActivityGroup#onResume()
	 */
	@Override
	protected void onResume()
	{
		super.onResume();
		
		if( !(Global.s_nLobbyToTap==-1) )
		{
			s_TabHost.setCurrentTab(Global.s_nLobbyToTap);	// C2DM에서 설정된 탭이 있으면 그쪽으로 간다.
			Global.s_nLobbyToTap= -1;
		}
	}

	private void setupTab(final View view, final String tabID, final Intent intent)
	{
		View tabview = createTabView(s_TabHost.getContext(), tabID);
		
		s_TabHost.addTab(s_TabHost.newTabSpec( tabID )
		        .setIndicator( tabview )
		        .setContent(intent));

	}

	private static View createTabView(final Context context, final String tabID)
	{
		View view = LayoutInflater.from(context).inflate(R.layout.tabs_bg, null);
		//ImageView IMG_BG = (ImageView) view.findViewById(R.id.img_tab);
		
		if(tabID.equals("tab1"))
		{
			view.setBackgroundResource(R.drawable.tab_image_selector_1);
		}
		if(tabID.equals("tab2"))
		{
			view.setBackgroundResource(R.drawable.tab_image_selector_2);
		}
		if(tabID.equals("tab3"))
		{
			view.setBackgroundResource(R.drawable.tab_image_selector_3);
		}
		if(tabID.equals("tab4"))
		{
			view.setBackgroundResource(R.drawable.tab_image_selector_4);
		}
		
		
		
		return view;
	}


	
	
//	private MeepleListFragment FRG_meeple;
//	private RecentTalkListFragment FRG_talk;
//	private FavoriteListFragment FRG_favorite;
//	private Button BTN_meeple, BTN_talk, BTN_favorite, BTN_setting;
//    ViewPageAdapter mAdapter;
//    ViewPager mPager;
    
    /* (non-Javadoc)
	 * @see android.support.v4.app.FragmentActivity#onSaveInstanceState(android.os.Bundle)
	 */
//	@Override
//	protected void onSaveInstanceState(Bundle outState)
//	{
//		super.onSaveInstanceState(outState);
//		getSupportFragmentManager()
//        .putFragment(outState, MeepleListFragment.class.getName(), FRG_meeple);
//	}
//
//	@Override
//    protected void onCreate(Bundle savedInstanceState)
//    {
//        super.onCreate(savedInstanceState);
//	
//	    setContentView(R.layout.viewpager);
//	    
//	    FRG_talk= new RecentTalkListFragment();
//	    FRG_favorite= new FavoriteListFragment();
//	    
//	    mAdapter = new ViewPageAdapter(getSupportFragmentManager());
//	
//	    mPager = (ViewPager)findViewById(R.id.pager);
//	    mPager.setAdapter(mAdapter);
//	    
//	    mPager.setOnPageChangeListener(this);
//	    
//	    BTN_meeple= (Button) findViewById(R.id.page_meeple);
//	    BTN_talk= (Button) findViewById(R.id.page_talk);
//	    BTN_favorite= (Button) findViewById(R.id.page_favorite);
//	    BTN_setting= (Button) findViewById(R.id.page_setting);
//	    
//	    BTN_meeple.setOnClickListener(this);
//	    BTN_talk.setOnClickListener(this);
//	    BTN_favorite.setOnClickListener(this);
//	    BTN_setting.setOnClickListener(this);
//	    
//    }

//	@Override
//	public void onClick(View v)
//	{
	
//		if(v.getId()==R.id.page_meeple)
//		{
//			mPager.setCurrentItem(0);
//		}
//		else if(v.getId()==R.id.page_talk)
//		{
//			mPager.setCurrentItem(1);
//		}
//		else if(v.getId()==R.id.page_favorite)
//		{
//			mPager.setCurrentItem(2);
//		}
//		else if(v.getId()==R.id.page_setting)
//		{
//			
//		}
//	}
//
//	@Override
//	public void onPageScrollStateChanged(int arg0)
//	{
//		
//	}
//
//	@Override
//	public void onPageScrolled(int arg0, float arg1, int arg2)
//	{
//		
//	}
//
//	@Override
//	public void onPageSelected(int pos)
//	{
//		if(pos==0)
//			FRG_meeple.LoadingMeeplesInfo();
//		else if(pos==1)
//			FRG_talk.GetRecentChats();
//		else if(pos==2)
//			FRG_favorite.GetFavoriteRelations();
//			
//	}

}
