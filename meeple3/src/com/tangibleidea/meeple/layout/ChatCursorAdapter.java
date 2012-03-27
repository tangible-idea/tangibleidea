package com.tangibleidea.meeple.layout;

import android.content.Context;
import android.database.Cursor;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.util.SPUtil;

public class ChatCursorAdapter extends CursorAdapter
{
	TextView TXT_MYCHAT, TXT_MYTIME, TXT_OPPOCHAT, TXT_OPPOTIME;
	ImageView IMG_OPPO;

	public ChatCursorAdapter(Context context, Cursor c)
	{
		super(context, c);
	}

	
	// _id(0), chat(1), senderid(2), receverid(3), date(4)
	// {"senderid", "receverid", "chat", "date", "_id"}; 커서정보
	
	@Override
	public void bindView(View v, Context _context, Cursor cursor)	
	{
		TXT_MYCHAT= (TextView)v.findViewById(R.id.eMyChat);
		TXT_MYTIME= (TextView)v.findViewById(R.id.eMyTime);
		TXT_OPPOCHAT= (TextView)v.findViewById(R.id.eOppoChat);
		TXT_OPPOTIME= (TextView)v.findViewById(R.id.eOppoTime);
		IMG_OPPO= (ImageView)v.findViewById(R.id.eOppoPhoto);
		
		boolean bMyChat;
		
		if( cursor.getString(2).equals( SPUtil.getString(_context, "AccountID") ) )
			bMyChat= true;
		else
			bMyChat= false;
		
		if(bMyChat)
		{
			TXT_MYCHAT.setText( cursor.getString(1) );
			TXT_MYCHAT.setBackgroundResource(R.drawable.my_message);
			TXT_MYTIME.setText( cursor.getString(4) );
			TXT_OPPOCHAT.setText("");
			TXT_OPPOCHAT.setBackgroundResource(R.drawable.transpercy_image);
			TXT_OPPOTIME.setText("");
			IMG_OPPO.setImageResource(R.drawable.transpercy_image);
//			TXT_OPPOCHAT.setVisibility(View.INVISIBLE);
//			TXT_OPPOTIME.setVisibility(View.INVISIBLE);
//			IMG_OPPO.setVisibility(View.INVISIBLE);
		}else{
//			TXT_MYCHAT.setVisibility(View.INVISIBLE);
//			TXT_MYTIME.setVisibility(View.INVISIBLE);
			TXT_MYCHAT.setText( "" );
			TXT_MYCHAT.setBackgroundResource(R.drawable.transpercy_image);
			TXT_MYTIME.setText( "" );
			TXT_OPPOCHAT.setText( cursor.getString(1) );
			TXT_OPPOCHAT.setBackgroundResource(R.drawable.oppo_message);
			TXT_OPPOTIME.setText( cursor.getString(4) );
			IMG_OPPO.setImageResource(R.drawable.no_profileimage);
		}
		
		return;
	}

	@Override
	public View newView(Context context, Cursor cursor, ViewGroup parent)
	{
		LayoutInflater inflater = LayoutInflater.from(context);
		View view = inflater.inflate(R.layout.entry_chat, parent, false);

		return view;
	}

}
