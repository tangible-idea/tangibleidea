package com.tangibleidea.meeple.auth;

public interface OnAuthListener
{
	void OnLoadCompelete(boolean bCompleted);
	void OnAuthResult(boolean bSuccess);
}
