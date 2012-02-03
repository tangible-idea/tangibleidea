package com.tangibleidea.meeple.util;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.activity.LoginActivity;

	// 브로드캐스트 리시버 부분 (메시지 받는 부분)
	public class C2dm_BroadcastReceiver extends BroadcastReceiver
	{

	    /** Called when the activity is first created. */
		private NotificationManager NotiMgr;
		private Notification NT;
		
	    String registration_id = null;
	    String c2dm_msg = "";

	    @Override
	    public void onReceive(Context context, Intent intent)
	    {

	        if (intent.getAction().equals("com.google.android.c2dm.intent.REGISTRATION"))	// 디바이스 등록
	        {
	        	GetRegistration(context, intent);
	        }
	        else if (intent.getAction().equals("com.google.android.c2dm.intent.RECEIVE"))	// 푸시가 메세지가 왔음
	        {
	            // 메시지 받아옴
	        	//c2dm_name= intent.getExtras().getString("name");
	            c2dm_msg = intent.getExtras().getString("message");

	         	NotiMgr= (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
	        	
	        	PendingIntent intent_p = PendingIntent.getActivity(
	        			context, 0, new Intent(context, LoginActivity.class), 0);
	        	
	        	NT= new Notification(R.drawable.app_icon,
	        			"MEEPLE",
	        			System.currentTimeMillis());
	        	
	        	NT.defaults= Notification.DEFAULT_ALL;
	        	NT.flags= Notification.FLAG_AUTO_CANCEL;
	        	
	        	NT.setLatestEventInfo(context, "미플 공지사항", c2dm_msg, intent_p);
	        	
	        	NotiMgr.notify(9090, NT);

	            // // 위험 액션 취함
	            // Intent i = new Intent(context, WarningAction.class);
	            // i.putExtra("message", c2dm_msg);
	            // i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
	            // PendingIntent pendingIntent = PendingIntent.getActivity(
	            // context, 0, i, PendingIntent.FLAG_UPDATE_CURRENT);
	            //
	            // try {
	            // pendingIntent.send();
	            // } catch (CanceledException e) {
	            // e.printStackTrace();
	            // Log.d("test", "인텐트 에러");
	            // }
	        }

	    }

	    private void GetRegistration(final Context context, Intent intent)
	    {

	        registration_id = intent.getStringExtra("registration_id");

	        // System.out.println("registration_id====>" + registration_id);
	        Log.d("test", "registration_id====>" + registration_id);

	        if (intent.getStringExtra("error") != null) 
	        {
	            Log.v("C2DM_REGISTRATION", ">>>>>" + "Registration failed, should try again later." + "<<<<<");

	        }
	        else if (intent.getStringExtra("unregistered") != null)
	        {

	            Log.v("C2DM_REGISTRATION", ">>>>>" + "unregistration done, new messages from the authorized sender will be rejected" + "<<<<<");

	        }
	        else if (registration_id != null)
	        {
	            System.out.println("registration_id complete!!");
	        }

	        // 고유 아아디 값이 null 이면 토스트 띄우고 리턴
	        if (registration_id == null)
	        {
	            SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(context);
	            SharedPreferences.Editor editor = pref.edit();
	            // 다음 실행시 또 실행 되게
	            editor.putBoolean("appInstall", false);
	            // 저장
	            editor.commit();
	        }
	        else	// 널이 아니면
	        {
	        	Global.REG_ID= registration_id;
	        }
	    }


	}
