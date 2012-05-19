package com.tangibleidea.meeple.activity;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestImageMethods;
import com.tangibleidea.meeple.util.SPUtil;

public class ModifyProfileActivity extends Activity implements OnClickListener
{
	boolean bMentor, bEdit=false;
	ImageView IMG_profile;
	Button BTN_edit, BTN_confirm, BTN_cancel;
	TextView TXT_account, TXT_email;
	EditText EDT_name, EDT_school, EDT_subprofile, EDT_major, EDT_today;
	
	RequestImageMethods RIM;
	
	String strName, strSchool, strSubprofile, strMajor, strToday;
	//String strName2, strSchool2, strSubprofile2, strMajor2, strToday2;

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		RIM= new RequestImageMethods();
		
		if( SPUtil.getBoolean(this, "isMentor") )
		{
			setContentView(R.layout.modify_myprofile_mentor);
			bMentor= true;
		}
		else
		{
			setContentView(R.layout.modify_myprofile_mentee);
			bMentor= false;
		}
				
		IMG_profile= (ImageView) findViewById(R.id.img_profile_image);
		IMG_profile.setOnClickListener(this);
		
		BTN_edit= (Button) findViewById(R.id.btn_profile_edit);
		BTN_confirm= (Button) findViewById(R.id.btn_profile_confirm);
		BTN_cancel= (Button) findViewById(R.id.btn_profile_cancel);
		
		TXT_account= (TextView) findViewById(R.id.txt_profile_id);
		TXT_email= (TextView) findViewById(R.id.txt_profile_email);
		
		EDT_name= (EditText) findViewById(R.id.edt_set1);
		EDT_school= (EditText) findViewById(R.id.edt_set2);
		EDT_subprofile= (EditText) findViewById(R.id.edt_set3);
		if(bMentor)
			EDT_major= (EditText) findViewById(R.id.edt_set4);
		
		EDT_today= (EditText) findViewById(R.id.edt_today_profile);
		
	
		EDT_name.setOnClickListener(this);
		EDT_school.setOnClickListener(this);
		EDT_subprofile.setOnClickListener(this);
		EDT_today.setOnClickListener(this);
		if(bMentor)
		{
			EDT_major.setOnClickListener(this);
		}
		
		BTN_edit.requestFocus();
		BTN_edit.setOnClickListener(this);
		BTN_confirm.setOnClickListener(this);
		BTN_edit.setOnClickListener(this);
		
		this.SetEditable(false);
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onStart()
	 */
	@Override
	protected void onStart()
	{
		super.onStart();
		
		this.ResetProfile();
		
		RequestImageMethods RIM= new RequestImageMethods();
		RIM.DownloadImage(IMG_profile, SPUtil.getString(this, "AccountID"));
			
	}
	
	@Override
	public void onClick(View v)
	{
		if(v.getId() == R.id.img_profile_image)
		{
			new AlertDialog.Builder(this)
	        .setTitle("프로필 사진 변경")
	        .setMessage("어떤 방법으로 변경하시겠습니까?")
	        .setPositiveButton("갤러리에서 선택", new DialogInterface.OnClickListener()
	        {
	        	@Override
				public void onClick(DialogInterface dialog, int which)
	        	{
	        		Intent i= new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);	
	        		startActivityForResult(i, 0);
				}
	        })
	        .setNeutralButton("사진 찍기", new DialogInterface.OnClickListener()
	        {
				
				@Override
				public void onClick(DialogInterface dialog, int which)
				{
					Intent i= new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);	
					startActivityForResult(i, 1);
				}
			})
	        .show();
		}
		
		if(v.getId() == R.id.edt_set1)
		{
			SetEditable(true);
		}
		if(v.getId() == R.id.edt_set2)
		{
			SetEditable(true);
		}
		if(v.getId() == R.id.edt_set3)
		{
			SetEditable(true);
		}
		if(v.getId() == R.id.edt_set4)
		{
			SetEditable(true);
		}
		if(v.getId() == R.id.edt_today_profile)
		{
			SetEditable(true);
		}
		
		if(v.getId() == R.id.btn_profile_edit)
		{
			SetEditable(true);
		}
		if(v.getId() == R.id.btn_profile_confirm)
		{
			this.SendProfile2Server();
		}
		if(v.getId() == R.id.btn_profile_cancel)
		{
			this.ResetProfile();
			
		}
	}
	
	/**
	 * 수정가능여부
	 * @param _bEditable
	 */
	public void SetEditable(boolean _bEditable)
	{		
		if(bEdit== _bEditable)	// 상태가 같으면 패스
			return;
		
		bEdit= _bEditable;
	
		if(bEdit)
		{
			BTN_edit.setVisibility(View.INVISIBLE);
			BTN_confirm.setVisibility(View.VISIBLE);
			BTN_cancel.setVisibility(View.VISIBLE);
		}
		else
		{
			BTN_edit.setVisibility(View.VISIBLE);
			BTN_confirm.setVisibility(View.INVISIBLE);
			BTN_cancel.setVisibility(View.INVISIBLE);
		}
		
		EDT_name.setFocusableInTouchMode(bEdit);
		EDT_school.setFocusableInTouchMode(bEdit);
		EDT_subprofile.setFocusableInTouchMode(bEdit);
		EDT_today.setFocusableInTouchMode(bEdit);
		
		if(bMentor)
		{
			EDT_major.setFocusableInTouchMode(bEdit);
		}
	}
	
	/**
	 * 프로필을 원래대로 되돌린다.
	 */
	void ResetProfile()
	{
		TXT_account.setText(SPUtil.getString(this, "AccountID"));
		TXT_email.setText(SPUtil.getString(this, "Email"));
		
		EDT_name.setText(SPUtil.getString(this, "Name"));
		
		if(bMentor)
		{
			EDT_school.setText(SPUtil.getString(this, "Univ"));
			EDT_subprofile.setText(SPUtil.getString(this, "Promo"));
			EDT_major.setText(SPUtil.getString(this, "Major"));
		}
		else
		{
			EDT_school.setText(SPUtil.getString(this, "School"));
			EDT_subprofile.setText(SPUtil.getString(this, "Grade"));
		}
		
		EDT_today.setText( SPUtil.getString(this, "Comment") );		
		
		this.SetEditable(false);
	}
	
	void SendProfile2Server()
	{
		boolean bSuccess= true;
		
		strName= EDT_name.getText().toString();
		strSchool= EDT_school.getText().toString();
		strSubprofile= EDT_subprofile.getText().toString();
		strToday= EDT_today.getText().toString();
		if(bMentor)
			strMajor= EDT_major.getText().toString();
		
		if( !strName.equals( SPUtil.getString(this, "Name")) ) 
		{
			if( !RIM.ChangeName(this, strName) )
				bSuccess= false;
			SPUtil.putString(this, "Name", strName);
		}
		if( !strToday.equals( SPUtil.getString(this, "Comment")) ) 
		{
			if( !RIM.ChangeComment(this, strToday) )
				bSuccess= false;
			SPUtil.putString(this, "Comment", strToday);
		}
		
		
		if( bMentor )
		{
			if( !strSchool.equals( SPUtil.getString(this, "Univ")) )
			{
				if( !RIM.ChangeSchool(this, strSchool) )
					bSuccess= false;
				else
					SPUtil.putString(this, "Univ", strSchool);
			}
			if( !strSubprofile.equals( SPUtil.getString(this, "Promo")) )
			{
				if( !RIM.ChangePromo(this, strSubprofile) )
					bSuccess= false;
				else
					SPUtil.putString(this, "Promo", strSubprofile);
			}
			if( !strMajor.equals( SPUtil.getString(this, "Major")) )
			{
				if( !RIM.ChangeMajor(this, strMajor) )
					bSuccess= false;
				else
					SPUtil.putString(this, "Major", strMajor);
			}
		}
		else
		{
			if( !strSchool.equals( SPUtil.getString(this, "School")) )
			{
				if( !RIM.ChangeSchool(this, strSchool) )
					bSuccess= false;
				else
					SPUtil.putString(this, "School", strSchool);
			}
			if( !strSubprofile.equals( SPUtil.getString(this, "Grade")) )
			{
				if( !RIM.ChangeGrade(this, strSubprofile) )
					bSuccess= false;
				else
					SPUtil.putString(this, "Grade", strSubprofile);
			}
		}
		
		if(bSuccess)
			Toast.makeText(this, "정보가 저장되었습니다.", 0 ).show();
		else
			Toast.makeText(this, "정보저장 실패.", 0 ).show();
		
		this.SetEditable(false);
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		
		if(resultCode == RESULT_OK)
		{
			if(requestCode==0)
			{
				Uri imageURI= data.getData(); 
				
				try
				{					
					BitmapFactory.Options bmpOptions= new BitmapFactory.Options();
					
					bmpOptions.inJustDecodeBounds= true; 	// 일단 정보만 얻어와보자
					BitmapFactory.decodeStream(getContentResolver().openInputStream(imageURI), null, bmpOptions);
					
					if(bmpOptions.outWidth > 200 || bmpOptions.outHeight > 200)	// 가로,세로가 500px 이상이면
					{
						if( bmpOptions.outHeight > bmpOptions.outWidth ) // 세로가 더 크면...
						{
							bmpOptions.inSampleSize= bmpOptions.outHeight / 200; // 샘플링배율= 2000/10= 10;
						}else{
							bmpOptions.inSampleSize= bmpOptions.outWidth / 200;
						}
					}else{
						bmpOptions.inSampleSize= 1;				// 크기가 작으면 그대로 올린다
					}
					
					bmpOptions.inJustDecodeBounds= false;	// 정보만 얻어올때는 true
					Bitmap bmp= BitmapFactory.decodeStream(getContentResolver().openInputStream(imageURI), null, bmpOptions);
					
					ByteArrayOutputStream BAOS= new ByteArrayOutputStream();
					bmp.compress(CompressFormat.JPEG, 85, BAOS);	// 85%의 화질로 올린다.
					byte[] byteArray= BAOS.toByteArray();
					 
					//RequestImageMethods RIM= new RequestImageMethods();
					RIM.UploadImage(this, byteArray);
					
					IMG_profile.setImageBitmap(bmp);
				}
				catch(FileNotFoundException e)
				{
					Log.e("onActivityResult::FileNotFoundException", e.toString());
				}
			}
			
			if(requestCode==1)
			{
				Bundle extra= data.getExtras();
				Bitmap bmp= (Bitmap) extra.get("data");
				
				ByteArrayOutputStream BAOS= new ByteArrayOutputStream();
				bmp.compress(CompressFormat.JPEG, 100, BAOS);
				byte[] byteArray= BAOS.toByteArray();
				
				//RequestImageMethods RIM= new RequestImageMethods();
				RIM.UploadImage(this, byteArray);
				
				IMG_profile.setImageBitmap(bmp);
			}
			
		}
	}

}
