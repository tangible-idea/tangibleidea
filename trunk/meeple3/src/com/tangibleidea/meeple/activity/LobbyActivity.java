package com.tangibleidea.meeple.activity;

import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TabHost;
import android.widget.TabHost.OnTabChangeListener;

public class LobbyActivity extends TabActivity
{
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        

    final TabHost tabHost = getTabHost();

    tabHost.addTab(tabHost.newTabSpec("tab1")
            .setIndicator("Meeple")
            .setContent(new Intent(this, MeepleActivity.class)
            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)));

    tabHost.addTab(tabHost.newTabSpec("tab2")
            .setIndicator("Talk")
            .setContent(new Intent(this, TalkActivity.class)));
    
//    tabHost.addTab(tabHost.newTabSpec("tab3")
//            .setIndicator("Favorite")
//            .setContent(new Intent(this, FavoriteActivity.class)
//                    .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP))); // recall OnCreate()
//    
    tabHost.addTab(tabHost.newTabSpec("tab4")
            .setIndicator("Setting")
            .setContent(new Intent(this, SettingActivity.class)
            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)));
    

    
    }
}
