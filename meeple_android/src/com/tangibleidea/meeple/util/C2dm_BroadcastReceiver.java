package com.tangibleidea.meeple.util;

import java.util.List;

import com.tangibleidea.meeple.R;
import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;

import com.tangibleidea.meeple.activity.LobbyActivity;

	// 브로드캐스트 리시버 부분 (메시지 받는 부분)
	public class C2dm_BroadcastReceiver extends BroadcastReceiver
	{
		private ChatManager ChatMgr= ChatManager.GetInstance();

	    /** Called when the activity is first created. */
		private NotificationManager NotiMgr;
		private Notification NT;
		
	    String registration_id = null;
	    String c2dm_type = "";
	    String c2dm_msg = "";
	    String c2dm_oppo= "";

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
	        	c2dm_type= intent.getExtras().getString("type");
	            c2dm_msg = intent.getExtras().getString("message");
	            c2dm_oppo= intent.getExtras().getString("oppoaccount");

	         	NotiMgr= (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
	        	
//	         	Intent LoginIntent= new Intent(context, LoginActivity.class);
//	         	LoginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK 
//	                    | Intent.FLAG_ACTIVITY_CLEAR_TOP 
//	                    | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//	        	PendingIntent LoginIntent_p = PendingIntent.getActivity(context, 0, LoginIntent , 0);
	         	
	         	Intent LobbyIntent= new Intent(context, LobbyActivity.class);
	         	LobbyIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK 
	                    | Intent.FLAG_ACTIVITY_CLEAR_TOP 
	                    | Intent.FLAG_ACTIVITY_SINGLE_TOP);
	         	PendingIntent LobbyIntent_p = PendingIntent.getActivity(context, 0, LobbyIntent, 0);

	        	
	        	NT= new Notification(R.drawable.ic_launcher,
	        			"[MEEPLE 알림]",
	        			System.currentTimeMillis());
	        	
	        	NT.defaults= Notification.DEFAULT_ALL;
	        	NT.flags= Notification.FLAG_AUTO_CANCEL;
	        	
	        	if( c2dm_type.equals("notice") )
	        	{
	        		NT.setLatestEventInfo(context, "미플 공지사항", c2dm_msg, LobbyIntent_p);	        	
		        	NotiMgr.notify(9093, NT);
	        	}
	        	else if( c2dm_type.equals("recommand") )
	        	{
	        		NT.setLatestEventInfo(context, "미플 알림", c2dm_msg, LobbyIntent_p);	        	
		        	NotiMgr.notify(9090, NT);
	        	}
	        	else if( c2dm_type.equals("chat") )
	        	{
	        		String topActivity = null;
	        		try
		            {
	        			ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
	        			List<ActivityManager.RunningTaskInfo> runningTaskInfo = am.getRunningTasks(1);            
	        			  
	        			if (runningTaskInfo != null)
	        			{	        				
	        				ActivityManager.RunningTaskInfo runInfo = runningTaskInfo.get(0);                       
	        				topActivity = runInfo.topActivity.getClassName();
	        			}

		            	if(topActivity.equals("com.tangibleidea.meeple.activity.InChatActivity") && ChatMgr.getCurrOppoAccount().equals(c2dm_oppo) )
		            	{	// C2DM이 온 상대와 채팅중이면...
		            		Global.s_HasNewChat= true;	// 노티로 안날리고 새로 받기만 한다.
		            	}
		            	else if(topActivity.equals("com.tangibleidea.meeple.activity.InChatActivity")) // 다른 상대와 대화중이면...
		            	{
		            		Global.s_nLobbyToTap= 1;

		    	        	
		            		
		            		NT.setLatestEventInfo(context, "새 대화가 도착했습니다.", c2dm_msg, LobbyIntent_p);	        	
				        	NotiMgr.notify(9090, NT);
		            	}		            	
		            	else	 // 미플과 관련이 없거나 아무것도 안하고 있으면
		            	{
		            		Global.s_nLobbyToTap= 1;
		            		ChatMgr.setC2DMoppoAccount(c2dm_oppo);
		    	         	Intent InChatIntent= new Intent(context, LobbyActivity.class);
		    	         	InChatIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK 
		    	                    | Intent.FLAG_ACTIVITY_CLEAR_TOP 
		    	                    | Intent.FLAG_ACTIVITY_SINGLE_TOP);
		    	        	
		            		PendingIntent InChatIntent_p = PendingIntent.getActivity(context, 0, InChatIntent, 0);
		            		NT.setLatestEventInfo(context, "새 대화가 도착했습니다.", c2dm_msg, InChatIntent_p);	        	
				        	NotiMgr.notify(9090, NT);
		            	}
		            	
		            } catch (Exception e) {
		            	Log.d(Global.LOG_TAG, e.toString());
		            }
	        	}
	        	else if( c2dm_type.equals("message") )
	        	{
	        		Global.s_nLobbyToTap= 1;
	        		NT.setLatestEventInfo(context, "새 쪽지가 도착했습니다.", c2dm_msg, LobbyIntent_p);	        	
		        	NotiMgr.notify(9090, NT);
	        	}
	        	else if( c2dm_type.equals("end") )
	        	{
	        		NT.setLatestEventInfo(context, "미플 알림", c2dm_msg, LobbyIntent_p);	        	
		        	NotiMgr.notify(9090, NT);
	        	}
	        	

	            
	            
	            	//text1.setText();

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
	        	SPUtil.putString(context, "reg_id", registration_id);
	        }
	    }


	}
