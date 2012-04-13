package com.tangibleidea.meeple.callback.auth;

public interface OnAuthListener
{
	void OnLoadCompelete(boolean bCompleted);
	void OnAuthResult(boolean bSuccess, String msg);
}
