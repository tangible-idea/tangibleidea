package com.tangibleidea.meeple.util;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class SPUtil
{
        public static void putString(Context context, String key, String value)
        {
                SharedPreferences prefs = 
                PreferenceManager.getDefaultSharedPreferences(context);

                SharedPreferences.Editor editor = prefs.edit();
                
                editor.putString(key, value);
                editor.commit();
        }
        


		public static void putBoolean(Context context, String key, boolean b)
		{
            SharedPreferences prefs = 
            PreferenceManager.getDefaultSharedPreferences(context);

            SharedPreferences.Editor editor = prefs.edit();
            
            editor.putBoolean(key, b);
            editor.commit();			
		}
		
		public static void putInt(Context context, String key, int n)
		{
            SharedPreferences prefs = 
            PreferenceManager.getDefaultSharedPreferences(context);

            SharedPreferences.Editor editor = prefs.edit();
            
            editor.putInt(key, n);
            editor.commit();			
		}
		
		
        public static String getString (Context context, String key)
        {
                SharedPreferences prefs = 
                PreferenceManager.getDefaultSharedPreferences(context);

                return prefs.getString(key, null);
        }
        
        public static boolean getBoolean (Context context, String key)
        {
                SharedPreferences prefs = 
                PreferenceManager.getDefaultSharedPreferences(context);

                return prefs.getBoolean(key, false);
        }
        
        public static int getInt (Context context, String key)
        {
                SharedPreferences prefs = 
                PreferenceManager.getDefaultSharedPreferences(context);

                return prefs.getInt(key, -1);
        }
}