package com.tangibleidea.meeple.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.EnumMeepleStatus;
import com.tangibleidea.meeple.data.ImageRepository;
import com.tangibleidea.meeple.layout.ProfileListAdapter;
import com.tangibleidea.meeple.layout.entry.InfoEntry;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.SPUtil;

public class MeepleListActivity extends ListActivity
{
	private int SelItem= -1;
	private Context mContext; 
	private ProgressDialog LoadingDL;
	
	ArrayAdapter<InfoEntry> AA;
	final ArrayList<InfoEntry> arraylist= new ArrayList<InfoEntry>();

	private List<MenteeInfo> tees, Pending_tees, Waiting_tees, InProgress_tees;
	private List<MentorInfo> tors, Pending_tors, InProgress_tors; 
	
	private TextView TXT_pending;
	private Button BTN_waitlinenumber, BTN_refresh;
	
	



	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		setContentView(R.layout.pending_meeple);
		
        // 셋팅하기전에 로딩시 보여줄 이미지 셋팅
        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.no_profileimage);
        ImageRepository.INSTANCE.setDefaultBitmap(bitmap);
		
		
		Pending_tees= new ArrayList<MenteeInfo>();
		Waiting_tees= new ArrayList<MenteeInfo>();
		InProgress_tees= new ArrayList<MenteeInfo>();
		Pending_tors= new ArrayList<MentorInfo>();
		InProgress_tors= new ArrayList<MentorInfo>();
		
		TXT_pending= (TextView) findViewById(R.id.txt_pending);
		BTN_refresh= (Button) findViewById(R.id.btn_refresh);
		BTN_refresh.setOnClickListener(new OnClickListener()
		{
			@Override
			public void onClick(View v)
			{
				LoadingMeeplesInfo();
			}
		});
		BTN_waitlinenumber= (Button) findViewById(R.id.btn_waitnumber);
		BTN_waitlinenumber.setOnClickListener(new OnClickListener()
		{	
			@Override
			public void onClick(View v)
			{
				RequestMethods RM= new RequestMethods();
				ShowAlertDialog("[대기번호]", "대기번호 : "+RM.GetWatingLines(mContext), "확인");
			}
		});
		
		mContext= this;
		LoadingDL = new ProgressDialog(mContext);
		LoadingMeeplesInfo();
	}

	
	public void LoadingMeeplesInfo()
	{
		Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
    
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{	
    		backgroundThreadProcessing();
    	}
    };

    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
    private void backgroundThreadProcessing()
    {
    	try 
    	{
    		if( !arraylist.isEmpty() )	// 리스트가 비어있지 않으면 클리어해준다.
    		{
    			if( SPUtil.getBoolean(mContext, "isMentor") )
    			{
        			tees.clear();
        			Pending_tees.clear();
        			Waiting_tees.clear();
        			InProgress_tees.clear();
    			}
    			else
    			{
        			tors.clear();
        			Pending_tors.clear();
        			InProgress_tors.clear();
    			}

    			arraylist.clear();
    		}
    		
    		if( SPUtil.getBoolean(mContext, "isMentor") ) 
    		{
        		LoadingHandler.sendEmptyMessage(0);
         		
        		RequestMethods RM= new RequestMethods();        		
        		tees= RM.GetMenteeRecommmendations(mContext);
        		
        		if(tees==null || tees.isEmpty())
        		{
        			if(!RM.CheckLogin(mContext))
        			{
        				LoadingHandler.sendEmptyMessage(-1);
        				return;
        			}
        		}
        		
        		for(MenteeInfo MI : tees)	// 가져온 멘티 리스트를 상태에 맞게 분류
        		{
        			if( MI.eSTAT == EnumMeepleStatus.E_MENTEE_PENDING ) 
        				Pending_tees.add(MI);
        			else if( MI.eSTAT == EnumMeepleStatus.E_MENTEE_WAITING ) 
        				Waiting_tees.add(MI);
        			else if( MI.eSTAT == EnumMeepleStatus.E_MENTEE_INPROGRESS ) 
        				InProgress_tees.add(MI);
        		}
        		LoadingHandler.sendEmptyMessage(3); 
    		}
    		else
    		{
        		LoadingHandler.sendEmptyMessage(10);
         		
        		RequestMethods RM= new RequestMethods();
        		tors= RM.GetMentorRecommmendations(mContext);
        		
        		if(tors==null || tors.isEmpty())
        		{
        			if(!RM.CheckLogin(mContext))
        			{
        				LoadingHandler.sendEmptyMessage(-1);
        				return;
        			}
        		}
        		
        		for(MentorInfo MO : tors)	// 가져온 멘토 리스트를 상태에 맞게 분류
        		{
        			if( MO.eSTAT == EnumMeepleStatus.E_MENTOR_PENDING ) 
        				Pending_tors.add(MO);
        			else if( MO.eSTAT == EnumMeepleStatus.E_MENTOR_INPROGRESS ) 
        				InProgress_tors.add(MO);
        		}
        		
        		LoadingHandler.sendEmptyMessage(30);
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
			if(msg.what==-1)
			{
				LoadingDL.hide();
				ShowAlertDialog("세션이 종료됨", "다시 로그인해주세요~", "확인");
			}
			if(msg.what==0)
			{
				if(AA!=null)
					AA.clear();
				
				BTN_waitlinenumber.setVisibility(View.INVISIBLE);
				LoadingDL.setMessage("멘티 목록을 불러오는 중...");
		        //LoadingDL.setMessage("나를 기다리는 멘티들을 불러오는 중");
		        LoadingDL.show();
			}
//			else if(msg.what==1)
//			{
//				LoadingDL.setMessage("내가 기다리고 있는 멘티들을 불러오는 중");
//				LoadingDL.show();
//			} 
//			else if(msg.what==2)
//			{
//				LoadingDL.setMessage("대화중인 멘티들을 불러오는 중");
//				LoadingDL.show();
//			}
			else if(msg.what==3)
			{
				LoadingDL.hide();
				
				for(MenteeInfo tee : Pending_tees)
					arraylist.add( new InfoEntry( tee.getAccountId(), tee.getName(), tee.getSchool(), tee.getGrade(), 0, EnumMeepleStatus.E_MENTEE_PENDING) );
				
				for(MenteeInfo tee : Waiting_tees)
					arraylist.add( new InfoEntry( tee.getAccountId(), tee.getName(), tee.getSchool(), tee.getGrade(), 0, EnumMeepleStatus.E_MENTEE_WAITING) );
						
				for(MenteeInfo tee : InProgress_tees)
					arraylist.add( new InfoEntry( tee.getAccountId(), tee.getName(), tee.getSchool(), tee.getGrade(), 0, EnumMeepleStatus.E_MENTEE_INPROGRESS) );				
		        
				AA = new ProfileListAdapter(mContext, R.layout.entry, R.id.eName, arraylist);
		        setListAdapter(AA);
			}
			else if(msg.what==10)
			{
				LoadingDL.setMessage("멘토 목록을 불러오는 중...");
				 //LoadingDL.setMessage("나를 수락한 멘토를 불러오는 중");
			     LoadingDL.setIndeterminate(true);
			     LoadingDL.show();
			}
//			else if(msg.what==20)
//			{
//				LoadingDL.setMessage("대화중인 멘토를 불러오는 중");
//				LoadingDL.show();
//			}
			else if(msg.what==30)
			{
				LoadingDL.hide();
				
				for(MentorInfo tor : Pending_tors)
					arraylist.add( new InfoEntry( tor.getAccountId(), tor.getName(), tor.getUniv(), tor.getMajor(), 0, EnumMeepleStatus.E_MENTOR_PENDING) );
				
				for(MentorInfo tor : InProgress_tors)
					arraylist.add( new InfoEntry( tor.getAccountId(), tor.getName(), tor.getUniv(), tor.getMajor(), 0, EnumMeepleStatus.E_MENTOR_INPROGRESS) );
				
		        if(arraylist.isEmpty())	// 추천받은 멘토가 없는 경우 멘티가 대기번호를 받는다.
		        {
		        	RequestMethods RM= new RequestMethods();
		        	TXT_pending.setVisibility(View.VISIBLE);
		        	TXT_pending.setText("대기번호 : "+RM.GetWatingLines(mContext));
		        }else{
		        	TXT_pending.setVisibility(View.GONE);
		        	AA = new ProfileListAdapter(mContext, R.layout.entry, R.id.eName, arraylist);
			        setListAdapter(AA); 
		        }
			}
		}
	}; 
	
	public void onListItemClick(ListView l, View v, int pos, long id)
	{
		SelItem= pos;
		
		if(arraylist.get(SelItem).eSTAT == EnumMeepleStatus.E_MENTEE_PENDING)
		{
			this.PendingMentee();
		}
		else if(arraylist.get(SelItem).eSTAT == EnumMeepleStatus.E_MENTEE_WAITING)
		{
			this.WatingMentee();
		}
		else if(arraylist.get(SelItem).eSTAT == EnumMeepleStatus.E_MENTEE_INPROGRESS)
		{
			this.ChatWithMentee();
		}
		else if(arraylist.get(SelItem).eSTAT == EnumMeepleStatus.E_MENTOR_PENDING)
		{
			this.PendingMentor();
		}
		else if(arraylist.get(SelItem).eSTAT == EnumMeepleStatus.E_MENTOR_INPROGRESS)
		{
			this.ChatWithMentor();
		}		
	}
	
	
	private void PendingMentee()
	{
		new AlertDialog.Builder(mContext)
        .setTitle("MEEPLE "+ arraylist.get(SelItem).getName())
        .setMessage( "추천받은 Meeple을 나의 멘티로 수락하시겠습니까?\n등록하시면 대화가 가능합니다."	)
        .setPositiveButton("수락", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int whichButton)
            {
            	RequestMethods RM= new RequestMethods();
            	if(RM.RespondRecommendation( mContext, arraylist.get(SelItem).getID(), true))
            	{
            		LoadingMeeplesInfo();
            	}else{
            		ShowAlertDialog("실패", "멘티 수락이 실패했습니다.", "확인");
            	}
            }
        })
        .setNegativeButton("거부", new DialogInterface.OnClickListener()
        {
        	public void onClick(DialogInterface dialog, int whichButton)
            {
            	RequestMethods RM= new RequestMethods();
        		RM.RespondRecommendation(mContext, arraylist.get(SelItem).getID(), false);
        		LoadingMeeplesInfo();
            }
        })
        .setNeutralButton("보류", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int whichButton) 
            {
            	
            }
        })
        .show();
	}
	
	// 멘티를 기다리는중
	private void WatingMentee()
	{
		this.ShowAlertDialog("MEEPLE "+ arraylist.get(SelItem).getName(), "멘티의 수락을 대기중입니다.", "확인");
	}
	
	// 멘티와 채팅하기
	private void ChatWithMentee()
	{
//		Intent intent=new Intent(MeepleActivity.this, InChatActivity.class);
//		startActivity(intent);
	}
	
	
	
	// 멘토가 수락해서 나의 응답을 기다리는 중
	private void PendingMentor()
	{ 
		new AlertDialog.Builder(mContext)
        .setTitle("MEEPLE "+ arraylist.get(SelItem).getName())
        .setMessage( "추천받은 Meeple을 나의 멘토로 수락하시겠습니까?\n등록하시면 대화가 가능합니다."	)
        .setPositiveButton("수락", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int whichButton)
            {
            	RequestMethods RM= new RequestMethods();
            	if(RM.RespondRecommendation( mContext, arraylist.get(SelItem).getID(), true))
            	{
            		LoadingMeeplesInfo();
            	}else{
            		ShowAlertDialog("실패", "멘토 수락이 실패했습니다.", "확인");
            	}
            }
        })
        .setNegativeButton("거부", new DialogInterface.OnClickListener()
        {
        	public void onClick(DialogInterface dialog, int whichButton)
            {
            	RequestMethods RM= new RequestMethods();
            	if(RM.RespondRecommendation( mContext, arraylist.get(SelItem).getID(), false))
            	{
            		LoadingMeeplesInfo();
            	}else{
            		ShowAlertDialog("실패", "멘토 거부에 실패했습니다.", "확인");
            	}
            }
        })
        .setNeutralButton("보류", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int whichButton)
            {
            	
            }
        })
        .show();
	}
	
	// 멘토와 채팅하기
	private void ChatWithMentor()
	{
		
	}
	
	
	private void ShowAlertDialog(String strTitle, String strContent, String strButton)
	{
		new AlertDialog.Builder(mContext)
		.setTitle( strTitle )
		.setMessage( strContent )
		.setPositiveButton( strButton , null)
		.setCancelable(false)
		.create()
		.show();
	}

}
