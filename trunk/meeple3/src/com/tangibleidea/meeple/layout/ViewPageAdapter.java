package com.tangibleidea.meeple.layout;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.tangibleidea.meeple.fragment.FavoriteListFragment;
import com.tangibleidea.meeple.fragment.MeepleListFragment;
import com.tangibleidea.meeple.fragment.RecentTalkListFragment;

public class ViewPageAdapter extends FragmentPagerAdapter
{
		public static final int NUM_ITEMS = 3;

		public ViewPageAdapter(FragmentManager fm)
		{
	        super(fm);
	    }

	    @Override
	    public int getCount()
	    {
	        return NUM_ITEMS;
	    }

	    @Override
	    public Fragment getItem(int position)
	    {
	    	switch(position)
	    	{
	    	case 0:
	    		return MeepleListFragment.newInstance();
	    	case 1:
	    		return RecentTalkListFragment.newInstance();
	    	case 2:
	    		return FavoriteListFragment.newInstance();
	    	}
	        
	    	return null;
	    }
}
