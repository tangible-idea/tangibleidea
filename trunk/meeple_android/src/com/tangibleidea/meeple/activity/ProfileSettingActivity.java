package com.tangibleidea.meeple.activity;

import java.util.ArrayList;

import android.app.ListActivity;
import android.os.Bundle;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.adapter.SettingAdapter;
import com.tangibleidea.meeple.layout.entry.SettingEntry;
import com.tangibleidea.meeple.layout.enums.EnumSettingStatus;
import com.tangibleidea.meeple.util.SPUtil;

public class ProfileSettingActivity extends ListActivity// implements android.view.View.OnClickListener
{
//	private ImageView IMG_profile;
//	private TextView TXT_info;
//	private boolean isMentor;
//	private String strAccountID, strName, strISMentor, strEmail;
//	private String strSchool, strGrade;
//	private String strMajor, strPromo, strUniv;
	
	private SettingAdapter Adapter;
	final ArrayList<SettingEntry> arraylist= new ArrayList<SettingEntry>();
	
    @Override 
    protected void onCreate(Bundle savedInstanceState)
    {
         super.onCreate(savedInstanceState);
                          
         setContentView(R.layout.setting);
         
         arraylist.add(new SettingEntry(EnumSettingStatus.E_LABEL_PROFILE, 0));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_NOLABEL, SPUtil.getString(this, "Name") ));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_LABEL_INFO, 0));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_NOLABEL, R.drawable.list_text_img_02_1 ));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_NOLABEL, R.drawable.list_text_img_02_2 ));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_NOLABEL, R.drawable.list_text_img_02_3 ));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_LABEL_REPORT, 0));
         arraylist.add(new SettingEntry(EnumSettingStatus.E_NOLABEL, R.drawable.list_text_img_02_4 ));
         
         Adapter= new SettingAdapter(this, R.layout.entry_setting, R.id.e_txt_content, arraylist);
         setListAdapter(Adapter);
    }
         
//         IMG_profile= (ImageView) findViewById(R.id.img_Photo);
//         TXT_info= (TextView) findViewById(R.id.txt_myinfo);
//         
//         strAccountID= SPUtil.getString(this, "AccountID");
//         strName= SPUtil.getString(this, "AccountID");
//         isMentor=  SPUtil.getBoolean(this, "isMentor");
//         strEmail= SPUtil.getString(this, "Email");
//         
//         IMG_profile.setOnClickListener(this);
//         
//         if(isMentor)
//         {
//        	 strISMentor= "(멘토)";
//        	 strUniv=SPUtil.getString(this, "Univ");
//        	 strMajor= SPUtil.getString(this, "Major");
//        	 strPromo= SPUtil.getString(this, "Promo");
//        	 TXT_info.setText("아이디 : "+strAccountID+" "+strISMentor
//        			 +"\n대학교 : "+strUniv
//        			 +"\n이메일 : "+strEmail
//        			 +"\n이름 : "+strName
//        			 +"\n전공 : "+strMajor
//        			 +"\n학번 : "+strPromo
//        			 );
//        	 
//         }
//         else
//         {
//        	 strISMentor= "(멘티)";
//        	 strSchool= SPUtil.getString(this, "School");
//        	 strGrade= SPUtil.getString(this, "Grade");
//        	 
//        	 TXT_info.setText("아이디 : "+strAccountID+" "+strISMentor
//        			 +"\n학교 : "+strSchool
//        			 +"\n이메일 : "+strEmail
//        			 +"\n이름 : "+strName
//        			 +"\n학년 : "+strGrade
//        			 );
//         }
//         
//         RequestImageMethods RIM= new RequestImageMethods();
//         RIM.DownloadImage(IMG_profile, SPUtil.getString(this, "AccountID"));         
         
    }
    
    
//
//
//	@Override
//	public void onClick(View v)
//	{
//		new AlertDialog.Builder(this)
//        .setTitle("프로필 사진 변경")
//        .setMessage("어떤 방법으로 변경하시겠습니까?")
//        .setPositiveButton("갤러리에서 선택", new DialogInterface.OnClickListener()
//        {
//        	@Override
//			public void onClick(DialogInterface dialog, int which)
//        	{
//        		Intent i= new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);	
//        		startActivityForResult(i, 0);
//			}
//        })
//        .setNeutralButton("사진 찍기", new DialogInterface.OnClickListener()
//        {
//			
//			@Override
//			public void onClick(DialogInterface dialog, int which)
//			{
//				Intent i= new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);	
//				startActivityForResult(i, 1);
//			}
//		})
//        .show();
//	}
//
//	/* (non-Javadoc)
//	 * @see android.app.Activity#onActivityResult(int, int, android.content.Intent)
//	 */
//	@Override
//	protected void onActivityResult(int requestCode, int resultCode, Intent data)
//	{
//		super.onActivityResult(requestCode, resultCode, data);
//		
//		if(resultCode == RESULT_OK)
//		{
//			if(requestCode==0)
//			{
//				Uri imageURI= data.getData(); 
//				
//				try
//				{					
//					BitmapFactory.Options bmpOptions= new BitmapFactory.Options();
//					
//					bmpOptions.inJustDecodeBounds= true; 	// 일단 정보만 얻어와보자
//					BitmapFactory.decodeStream(getContentResolver().openInputStream(imageURI), null, bmpOptions);
//					
//					if(bmpOptions.outWidth > 200 || bmpOptions.outHeight > 200)	// 가로,세로가 500px 이상이면
//					{
//						if( bmpOptions.outHeight > bmpOptions.outWidth ) // 세로가 더 크면...
//						{
//							bmpOptions.inSampleSize= bmpOptions.outHeight / 200; // 샘플링배율= 2000/10= 10;
//						}else{
//							bmpOptions.inSampleSize= bmpOptions.outWidth / 200;
//						}
//					}else{
//						bmpOptions.inSampleSize= 1;				// 크기가 작으면 그대로 올린다
//					}
//					
//					bmpOptions.inJustDecodeBounds= false;	// 정보만 얻어올때는 true
//					Bitmap bmp= BitmapFactory.decodeStream(getContentResolver().openInputStream(imageURI), null, bmpOptions);
//					
//					ByteArrayOutputStream BAOS= new ByteArrayOutputStream();
//					bmp.compress(CompressFormat.JPEG, 85, BAOS);	// 85%의 화질로 올린다.
//					byte[] byteArray= BAOS.toByteArray();
//					 
//					RequestImageMethods RIM= new RequestImageMethods();
//					RIM.UploadImage(this, byteArray);
//					
//					IMG_profile.setImageBitmap(bmp);
//				}
//				catch(FileNotFoundException e)
//				{
//					Log.e("onActivityResult::FileNotFoundException", e.toString());
//				}
//			}
//			
//			if(requestCode==1)
//			{
//				Bundle extra= data.getExtras();
//				Bitmap bmp= (Bitmap) extra.get("data");
//				
//				ByteArrayOutputStream BAOS= new ByteArrayOutputStream();
//				bmp.compress(CompressFormat.JPEG, 100, BAOS);
//				byte[] byteArray= BAOS.toByteArray();
//				
//				RequestImageMethods RIM= new RequestImageMethods();
//				RIM.UploadImage(this, byteArray);
//				
//				IMG_profile.setImageBitmap(bmp);
//			}
//			
//		}
//	}
	
    
    
    
    
    
    
//    private PreferenceScreen createPreferenceHierarchy()
//    {
//        // Root
//        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);
//
//        	PreferenceCategory CAT_defaultInfo = new PreferenceCategory(this);
//	        CAT_defaultInfo.setTitle("기본정보");	        
//	        root.addPreference(CAT_defaultInfo);
//	        
//	        if( !isMentor )
//	        {
//	        	EditTextPreference EPT_name = new EditTextPreference(this);
//		        EPT_name.setDialogTitle("[이름 입력]");
//		        EPT_name.setKey("mentee_name");
//		        EPT_name.setTitle("이름 변경");
//		        EPT_name.setSummary( SPUtil.getString(this, "AccountID"));
//		        
//		        EditTextPreference EPT_school = new EditTextPreference(this);
//		        EPT_school.setDialogTitle("[학교 입력]");
//		        EPT_school.setKey("mentee_school");
//		        EPT_school.setTitle("학교 변경");
//		        EPT_school.setSummary( SPUtil.getString(this, "School") );
//		        
//		        EditTextPreference EPT_grade = new EditTextPreference(this);
//		        EPT_grade.setDialogTitle("[학년 입력]");
//		        EPT_grade.setKey("mentee_grade");
//		        EPT_grade.setTitle("학년 변경");
//		        EPT_grade.setSummary( SPUtil.getString(this, "Grade") );
//		        
//		        CAT_defaultInfo.addPreference(EPT_name);
//		        CAT_defaultInfo.addPreference(EPT_school);
//		        CAT_defaultInfo.addPreference(EPT_grade);
//		        
//	        }else{
//	        	EditTextPreference EPT_name = new EditTextPreference(this);
//		        EPT_name.setDialogTitle("[이름 입력]");
//		        EPT_name.setKey("mentor_name");
//		        EPT_name.setTitle("이름 변경");
//		        EPT_name.setSummary( SPUtil.getString(this, "Name"));
//		        
//		        EditTextPreference EPT_major = new EditTextPreference(this);
//		        EPT_major.setDialogTitle("[전공 입력]");
//		        EPT_major.setKey("mentor_major");
//		        EPT_major.setTitle("전공 변경");
//		        EPT_major.setSummary( SPUtil.getString(this, "Major") );
//		        
//		        EditTextPreference EPT_promo = new EditTextPreference(this);
//		        EPT_promo.setDialogTitle("[학번 입력]");
//		        EPT_promo.setKey("mentor_promo");
//		        EPT_promo.setTitle("학번 변경");
//		        EPT_promo.setSummary( SPUtil.getString(this, "Promo") );
//		        
//		        CAT_defaultInfo.addPreference(EPT_name);
//		        CAT_defaultInfo.addPreference(EPT_major);
//		        CAT_defaultInfo.addPreference(EPT_promo);
//	        }
//		        
//		        
//	        
//	        
//	        PreferenceCategory CAT_AddtionInfo = new PreferenceCategory(this);
//	        CAT_AddtionInfo.setTitle("부가정보");
//	        root.addPreference(CAT_AddtionInfo);
//	        
//	        EditTextPreference EPT_comment;
//	        
//	        EPT_comment = new EditTextPreference(this);
//	        EPT_comment.setDialogTitle("[오늘의 한마디 입력]");
//	        EPT_comment.setKey("mentee_comment");
//	        EPT_comment.setTitle("오늘의 한마디");
//	        EPT_comment.setSummary( SPUtil.getString(this, "Comment") );
//	    
//		        
//		    CAT_AddtionInfo.addPreference(EPT_comment);
//        
//        
//        
//		return root;
//    }
