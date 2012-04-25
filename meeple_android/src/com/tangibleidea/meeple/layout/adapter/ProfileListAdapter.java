package com.tangibleidea.meeple.layout.adapter;

import java.util.ArrayList;
import java.util.HashMap;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.activity.LobbyActivity;
import com.tangibleidea.meeple.activity.PopupActivity;
import com.tangibleidea.meeple.callback.common.OnMeepleInteraction;
import com.tangibleidea.meeple.data.EnumMeepleStatus;
import com.tangibleidea.meeple.layout.PathButton;
import com.tangibleidea.meeple.layout.entry.InfoEntry;
import com.tangibleidea.meeple.server.RequestImageMethods;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.SPUtil;

class ViewHolder_ProfileList
{
	ImageView IMG_ProfilePic;
}

public class ProfileListAdapter extends ArrayAdapter<InfoEntry> implements android.view.View.OnClickListener
{
		//private HashMap<Integer, Bitmap> mapProfileImages= new HashMap<Integer, Bitmap>();
//		private ImageView CurrImageView= null;
//		private String CurrID= null;
//		private int CurrPos= 0;
	private RequestMethods RM;
	private OnMeepleInteraction CBInteraction;	// 이 Adapter를 가지고 있는 Activity에 터치 여부를 전달하기 위한 콜백이다.
	private static boolean bFirstClick= true;
	
	private ArrayList<InfoEntry> items;
    private int rsrc;
    private Context mContext;
      
    private ImageView[] IMG_covers;
    private TextView[] TXT_name, TXT_sub;
    private PathButton[] BTN_slide;//, BTN_slide2;
    private boolean[] bSlide;	// 
    private int nPos;	// 현재 선택된 포지션
    
    private Animation ANI_scale, ANI_scale2;
    private Animation ANI_trans, ANI_trans2;
    private Animation ANI_fadeout, ANI_fadein;
    
    private HashMap<Integer,EnumMeepleStatus> mapMeepleLabel= new HashMap<Integer,EnumMeepleStatus>();
      
    int nLoop= 0;
      
      public ProfileListAdapter(Context context, int rsrcId, int txtId, ArrayList<InfoEntry> data)
      {
          super(context, rsrcId, txtId, data);
          this.mContext= context;
          this.items = data;
          this.rsrc = rsrcId;
          
          RM= new RequestMethods();
          
          bSlide= new boolean[data.size()];
          for(boolean b : bSlide)	// 초기값
        	  b= false;
        		  
		  ANI_scale= AnimationUtils.loadAnimation(mContext, R.anim.my_scale);
		  ANI_trans= AnimationUtils.loadAnimation(mContext, R.anim.my_translate);
		  ANI_fadeout= AnimationUtils.loadAnimation(mContext, R.anim.my_fadeout);
		  ANI_fadein= AnimationUtils.loadAnimation(mContext, R.anim.my_fadein);
		  ANI_scale2= AnimationUtils.loadAnimation(mContext, R.anim.my_scale2);
		  ANI_trans2= AnimationUtils.loadAnimation(mContext, R.anim.my_translate2);
		  
		  ANI_scale.setFillEnabled(true);
		  ANI_scale.setFillAfter(true);
		  
		  ANI_trans.setFillEnabled(true);
		  ANI_trans.setFillAfter(true);
		  
		  ANI_fadeout.setFillEnabled(true);
		  ANI_fadeout.setFillAfter(true);
		  
		  ANI_fadein.setFillEnabled(true);
		  ANI_fadein.setFillAfter(true);
		  
		  ANI_scale2.setFillEnabled(true);
		  ANI_scale2.setFillAfter(true);
		  
		  ANI_trans2.setFillEnabled(true);
		  ANI_trans2.setFillAfter(true);
		  
          TXT_name= new TextView[data.size()];
          TXT_sub= new TextView[data.size()];
          BTN_slide= new PathButton[data.size()];
          //BTN_slide2= new Button[data.size()];
          IMG_covers= new ImageView[data.size()];
          
          
          ANI_scale.setAnimationListener(new Animation.AnimationListener() {
			
			@Override
			public void onAnimationStart(Animation animation)
			{
				Log.d("ANI_scale", "start");
			}
			
			@Override
			public void onAnimationRepeat(Animation animation) {
				Log.d("ANI_scale", "repeat");
				
			}
			
			@Override
			public void onAnimationEnd(Animation animation) {
				Log.d("ANI_scale", "end");
				
			}
		});
          
        
      }
      
      @Override
      public View getView(final int position, View convertView, ViewGroup parent)
      {
    	  ViewHolder_ProfileList VH;
          View v = convertView;
          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(rsrc, null);
              
    		  VH = new ViewHolder_ProfileList();
    		  VH.IMG_ProfilePic = (ImageView)v.findViewById(R.id.ePhoto);
    		  v.setTag(VH);
          }
          else
          {
        	  VH = (ViewHolder_ProfileList)v.getTag();
          }
          
          final InfoEntry e = items.get(position); 
          
          if (e != null)
          {
        	  mapMeepleLabel.put(position, e.eSTAT);	// 포지션별 Enum값을 기억한다.
        	  
        	  TXT_name[position]= (TextView)v.findViewById(R.id.eName);
        	  TXT_name[position].setText(e.getName());
        	  TXT_name[position].setPaintFlags(TXT_name[position].getPaintFlags() | Paint.FAKE_BOLD_TEXT_FLAG);  
        	  
        	  TXT_sub[position]= (TextView)v.findViewById(R.id.eSchool);
        	  TXT_sub[position].setText(e.getSchool());
        	  
        	  IMG_covers[position]= (ImageView)v.findViewById(R.id.e_img_table);
        	  
        	  BTN_slide[position]= (PathButton)v.findViewById(R.id.e_btn_slide);
        	  BTN_slide[position].setTag(position);        	  
        	  BTN_slide[position].setOnClickListener(this);
        	  
          
        	  // 이미지를 다운로드하고 설정하는 부분
//              if (e.getPhotoId() != -1)
//              {    			
            	  //VH.IMG_ProfilePic= (ImageView) v.findViewById(R.id.ePhoto);
            	  RequestImageMethods RIM= new RequestImageMethods();
          		  RIM.DownloadImage2( VH.IMG_ProfilePic, e.getID() );	// 이미지를 다운로드 받고
          		  VH.IMG_ProfilePic.setBackgroundColor(Color.BLACK);
//              } else {
//            	  holder.imgView.setImageResource(R.drawable.no_profileimage);  
//              }
              
              // 테이블 내에 들어갈 작업들
              ImageView IMG_in_caption= (ImageView) v.findViewById(R.id.e_img_table_in_caption);
              final Button BTN_in_yes= (Button) v.findViewById(R.id.e_btn_table_in_yes);
              final Button BTN_in_no= (Button) v.findViewById(R.id.e_btn_table_in_no);
              final Button BTN_in_talk= (Button) v.findViewById(R.id.e_btn_table_in_talk);
        	  ImageView IMG_LBL= (ImageView) v.findViewById(R.id.e_img_label);
        	  ImageView IMG_notice= (ImageView) v.findViewById(R.id.e_notice);
        	  
        	  VH.IMG_ProfilePic.setOnClickListener(new OnClickListener()
        	  {
				
				@Override
				public void onClick(View v)
				{
					Log.d("ProfileListAdapter", "Click::ProfilePopup "+position);
					
					Intent intent= new Intent(mContext, PopupActivity.class);
					intent.putExtra("position", position);
					intent.putExtra("id", e.getID());
					intent.putExtra("name", e.getName());
					intent.putExtra("profile", e.getSchool());
					intent.putExtra("comment", e.getComment());
					mContext.startActivity(intent);
					
				}
        	  });
        	  
        	  BTN_in_yes.setOnClickListener(new OnClickListener()
        	  {
				
				@Override
				public void onClick(View v)
				{
					if( bSlide[position] )
					{
						RM.RespondRecommendation(mContext, e.getID(), true);
						
						CBInteraction.OnRespound(true);
					}
				}
        	  });
        	  
        	  BTN_in_no.setOnClickListener(new OnClickListener()
        	  {
				
				@Override
				public void onClick(View v)
				{
					if( bSlide[position] )
					{
						RM.RespondRecommendation(mContext, e.getID(), false);
						
						CBInteraction.OnRespound(false);
					}
				}
        	  });
        	  
        	  BTN_in_talk.setOnClickListener(new OnClickListener()
        	  {
				
				@Override
				public void onClick(View v)
				{
					if( bSlide[position] )
					{
						Log.d("ProfileListAdapter", "Click::Talk "+position);
						LobbyActivity.s_TabHost.setCurrentTab(1);
					}
				}
        	  });
        	  
        	  if( SPUtil.getBoolean(mContext, "isMentor") )	// 자신이 멘토일 경우...
        	  {
        		  if( e.eSTAT == EnumMeepleStatus.E_MENTEE_NULL )	// 추천받은 멘티가 없을 경우
        		  {
        			  IMG_notice.setBackgroundResource(R.drawable.notice_my_mentee);
        			  BTN_slide[position].setVisibility(View.INVISIBLE);
        		  }

        		  else if( e.eSTAT == EnumMeepleStatus.E_MENTEE_PENDING ) // 멘토에게 멘티가 추천된 경우... (방금 추천됨)
        		  {
        			  IMG_notice.setImageResource(R.drawable.notice_new_mentee);
					  IMG_in_caption.setBackgroundResource(R.drawable.text_img_mentee_accept);	// 멘티를 수락하시겠습니까?
					  BTN_in_yes.setBackgroundResource(R.drawable.btn_new_meeple_ok);
					  BTN_in_no.setBackgroundResource(R.drawable.btn_new_meeple_no);
					  BTN_in_talk.setBackgroundResource(R.drawable.btn_tap_talk_blank);	// 대화하기는 없앰
					  BTN_in_talk.setOnClickListener(null);
					  
    				  if( (position!=0) )
    				  {					  
    					  if(mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTEE_PENDING || mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTEE_WAITING)
    					  {
    						  IMG_LBL.setBackgroundResource(R.drawable.title_blank_17);
    						  return v;
    					  }
    				  }
    				  IMG_LBL.setBackgroundResource(R.drawable.title_new_mentee);
        		  }
        		  else if( e.eSTAT == EnumMeepleStatus.E_MENTEE_WAITING ) // 멘티를 대기중인 경우... (멘토가 이미 수락했음)
        		  {
        			  IMG_notice.setImageResource(R.drawable.notice_wait_mentee);
        			  IMG_in_caption.setBackgroundResource(R.drawable.text_img_wait_mentee_accept);	// 멘티를 대기중입니다.
					  BTN_in_yes.setBackgroundResource(R.drawable.btn_new_meeple_blank);
					  BTN_in_no.setBackgroundResource(R.drawable.btn_new_meeple_blank);
					  BTN_in_talk.setBackgroundResource(R.drawable.btn_tap_talk_blank);	// 대화하기는 없앰
					  BTN_in_talk.setOnClickListener(null);
					  BTN_in_yes.setOnClickListener(null);
					  BTN_in_no.setOnClickListener(null);
					  
        			  if( (position!=0) )
    				  {
    					  if(mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTEE_WAITING || mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTEE_PENDING)
    					  {
    						  
    						  IMG_LBL.setBackgroundResource(R.drawable.title_blank_17);
    						  return v;
    					  }
    				  }
        			  IMG_LBL.setBackgroundResource(R.drawable.title_new_mentee);
        		  }
        		  else if( e.eSTAT == EnumMeepleStatus.E_MENTEE_INPROGRESS ) // 둘 다 수락했을 경우... (대화중)
        		  {
        			  IMG_notice.setImageResource(R.drawable.notice_blank);
        			  IMG_in_caption.setBackgroundResource(R.drawable.text_img_mentor_accept_blank);	// 캡션을 안보이게함
					  BTN_in_yes.setBackgroundResource(R.drawable.btn_new_meeple_blank);
					  BTN_in_no.setBackgroundResource(R.drawable.btn_new_meeple_blank);
					  BTN_in_talk.setBackgroundResource(R.drawable.btn_tap_talk);	// 대화하기만 보여줌
					  BTN_in_yes.setOnClickListener(null);
					  BTN_in_no.setOnClickListener(null);
					  
        			  if( (position!=0) )
    				  {
    					  if(mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTEE_INPROGRESS)
    					  {
    						  IMG_LBL.setBackgroundResource(R.drawable.title_blank_17);
    						  return v;
    					  }
    				  }
        			  IMG_LBL.setBackgroundResource(R.drawable.title_my_mentee);
        		  }  
        	  }
        	  else
        	  {
        		  if( e.eSTAT == EnumMeepleStatus.E_MENTOR_NULL )	// 추천받은 멘토가 없을 경우
        		  {
        			  IMG_notice.setImageResource(R.drawable.notice_my_mentor);
        			  BTN_slide[position].setVisibility(View.INVISIBLE);
        		  }
        		  else if( e.eSTAT == EnumMeepleStatus.E_MENTOR_PENDING )	// 멘토가 수락해서 -> 멘티에게 멘토가 추천된 경우
        		  {
        			  IMG_notice.setImageResource(R.drawable.notice_new_mentor);
        			  IMG_in_caption.setBackgroundResource(R.drawable.text_img_mentee_accept);	// 멘토를 수락하시겠습니까?
					  BTN_in_yes.setBackgroundResource(R.drawable.btn_new_meeple_ok);
					  BTN_in_no.setBackgroundResource(R.drawable.btn_new_meeple_no);
					  BTN_in_talk.setBackgroundResource(R.drawable.btn_tap_talk_blank);	// 대화하기 안보여줌
					  BTN_in_talk.setOnClickListener(null);
					  
        			  if( (position!=0) )
    				  {
    					  if(mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTOR_PENDING)
    					  {
    						  IMG_LBL.setBackgroundResource(R.drawable.title_blank_17);
    						  return v;
    					  }
    				  }
        			  IMG_LBL.setBackgroundResource(R.drawable.title_new_mentor);
        		  }
        		  else if( e.eSTAT == EnumMeepleStatus.E_MENTOR_INPROGRESS )	// 둘 다 수락 했음
        		  {
        			  IMG_notice.setImageResource(R.drawable.notice_blank);
        			  IMG_in_caption.setBackgroundResource(R.drawable.text_img_mentor_accept_blank);	// 캡션을 안보이게함
					  BTN_in_yes.setBackgroundResource(R.drawable.btn_new_meeple_blank);
					  BTN_in_no.setBackgroundResource(R.drawable.btn_new_meeple_blank);
					  BTN_in_talk.setBackgroundResource(R.drawable.btn_tap_talk);	// 대화하기만 보여줌
					  BTN_in_yes.setOnClickListener(null);
					  BTN_in_no.setOnClickListener(null);
					  
        			  if( (position!=0) )
    				  {  
    					  if(mapMeepleLabel.get(position-1) == EnumMeepleStatus.E_MENTOR_INPROGRESS)
    					  {
    						  IMG_LBL.setBackgroundResource(R.drawable.title_blank_17);
    						  return v;
    					  }
    				  }
        			  IMG_LBL.setBackgroundResource(R.drawable.title_my_mentor);
        		  }
        	  }
        	  
        	  ++nLoop;
          }
          return v;
      }

	@Override
	public void onClick(View v)
	{
		if(bFirstClick)
		{
			CBInteraction.OnRespound(true);	// 한번 다시 리프레시
			bFirstClick= false;
		}
		
		PathButton currBTN= (PathButton) v;	// 현재 클릭한 버튼 받아옴
		
		
		for(PathButton btn : BTN_slide)
		{
			nPos= (Integer) btn.getTag();	// 위치를 알아낸다.
			
			if(currBTN.getTag()==btn.getTag())
			{	
				if(!bSlide[nPos])
				{
					bSlide[nPos]= true;
					
					IMG_covers[nPos].startAnimation(ANI_scale);
					
					TXT_name[nPos].startAnimation(ANI_fadeout);
					TXT_sub[nPos].startAnimation(ANI_fadeout);
					
					btn.setOffset(-230, 0);
					btn.startAnimation(ANI_trans);
					btn.setBackgroundResource(R.drawable.button_right_slide);
					
//					param_BTN_slide= new RelativeLayout.LayoutParams( currBTN.getLayoutParams() );
//					param_BTN_slide.setMargins(param_BTN_slide.leftMargin+350, param_BTN_slide.topMargin+80, param_BTN_slide.rightMargin, param_BTN_slide.bottomMargin);
//					currBTN.setLayoutParams( param_BTN_slide );
				}
				else
				{
					bSlide[nPos]= false;
					
					IMG_covers[nPos].startAnimation(ANI_scale2);
					
					TXT_name[nPos].startAnimation(ANI_fadein);
					TXT_sub[nPos].startAnimation(ANI_fadein);
					
					btn.setOffset(0, 0);
					btn.startAnimation(ANI_trans2);					
					btn.setBackgroundResource(R.drawable.button_left_slide);
					
//					param_BTN_slide= new RelativeLayout.LayoutParams( currBTN.getLayoutParams() );
//					param_BTN_slide.setMargins(param_BTN_slide.leftMargin, param_BTN_slide.topMargin, param_BTN_slide.rightMargin, param_BTN_slide.bottomMargin);
//					currBTN.setLayoutParams( param_BTN_slide );
				}
				
				for(int i=0; i<TXT_name.length; ++i)
				{
					if(nPos==i)	// 현재 클릭된거면 패스
						continue;
					TXT_name[i].clearAnimation();
				}
				
				for(int i=0; i<TXT_sub.length; ++i)
				{
					if(nPos==i)	// 현재 클릭된거면 패스
						continue;
					TXT_sub[i].clearAnimation();
				}
				
				for(int i=0; i<IMG_covers.length; ++i)
				{
					if(nPos==i)	// 현재 클릭된거면 패스
						continue;
					IMG_covers[i].clearAnimation();
				}
				
				for(int i=0; i<BTN_slide.length; ++i)
				{
					if(nPos==i)	// 현재 클릭된거면 패스
						continue;
					BTN_slide[i].clearAnimation();
				}
			}
		}
		
	}
	
	// 콜백 등록 메서드
	public void SetOnMeepleInteractionListener(OnMeepleInteraction _CB)
	{
		this.CBInteraction= _CB;
	}

	
	
//	private void StartImageDownloadThread()
//	{
//    	Thread thread = new Thread(null, BackgroundThread, "Background");
//    	thread.start();
//	}
//	
//    
//    private Runnable BackgroundThread = new Runnable()
//    {
//    	public void run()
//    	{	
//    		backgroundThreadProcessing();
//    	}
//    };
//
//    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
//    private void backgroundThreadProcessing()
//    {
//		LoadingHandler.sendEmptyMessage(0);
//	
//		RequestImageMethods RIM= new RequestImageMethods();
//		
//		Bitmap res= RIM.DownloadImageToThread( this.CurrID );	// 이미지를 다운로드 받고    		
//		mapProfileImages.put(CurrPos, res);	// 각 계정에 맞게 맵에 할당
//		
//		LoadingHandler.sendEmptyMessage(1);
//    }
//    
//	public Handler LoadingHandler = new Handler()
//	{
//		public void handleMessage(Message msg)
//		{
//			if(msg.what==-1)
//			{
//				
//			}
//			if(msg.what == 1)
//			{
//				for(int i=0; i<mapProfileImages.size(); i++)
//				{
//					CurrImageView.setImageBitmap( mapProfileImages.get( CurrID ) );
//				}
//			}
//		}
//	};


}
