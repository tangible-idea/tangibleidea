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

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
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
		
		BTN_edit= (Button) findViewById(R.id.btn_profile_cancel);
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
		//this.SetEditable(false);
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onStart()
	 */
	@Override
	protected void onStart()
	{
		super.onStart();
		
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
		
		EDT_today.setText( SPUtil.getString(this, "comment") );		
		
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
	}
	
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
		
//		EDT_name.setFocusableInTouchMode(bEdit);
//		EDT_school.setFocusableInTouchMode(bEdit);
//		EDT_subprofile.setFocusableInTouchMode(bEdit);
//		EDT_today.setFocusableInTouchMode(bEdit);
//		
//		if(bMentor)
//		{
//			EDT_major.setFocusableInTouchMode(bEdit);
//		}
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
					 
					RequestImageMethods RIM= new RequestImageMethods();
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
				
				RequestImageMethods RIM= new RequestImageMethods();
				RIM.UploadImage(this, byteArray);
				
				IMG_profile.setImageBitmap(bmp);
			}
			
		}
	}

}
