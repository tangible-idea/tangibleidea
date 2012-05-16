package com.tangibleidea.meeple.layout.viewpage;

//PageControl 기본틀
public interface IPageControl {
	/**
	 * 페이지에 전체 크기를 지정합니다.
	 * @param size
	 */
	public void setPageSize(int size);
	/**
	 * 페이지 전체 크기를 리턴합니다.
	 * @return
	 */
	public int getPageSize();
	
	/**
	 * 페이지를 호출합니다.
	 * @param index
	 */
	public void setPageIndex(int index);
	/**
	 * 현재 페이지를 리턴합니다.
	 * @return
	 */
	public int getCurrentPageIndex(); 
}
