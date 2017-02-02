//
//  Released by YoYo Games Ltd. on 17/04/2014. Intended for use with GM: S EA97 and above ONLY.
//  Copyright YoYo Games Ltd., 2014.
//  For support please submit a ticket at help.yoyogames.com
//
//


package ${YYAndroidPackageName};



import ${YYAndroidPackageName}.RunnerActivity;
import com.yoyogames.runner.RunnerJNILib;
import android.util.Log;
import com.yoyogames.runner.RunnerJNILib;
import java.util.Map;

import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.millennialmedia.android.MMAd;
import com.millennialmedia.android.MMAdView;
import com.millennialmedia.android.MMRequest;
import com.millennialmedia.android.MMSDK;
import com.millennialmedia.android.MMInterstitial;
import com.millennialmedia.android.MMException;
import com.millennialmedia.android.RequestListener;

import android.view.ViewGroup;
import android.view.View;
import android.widget.AbsoluteLayout;

public class MMediaExt
{
	
	//Constants for tablet sized ads (728x90)
private static final int IAB_LEADERBOARD_WIDTH = 728;
private static final int IAB_LEADERBOARD_HEIGHT = 90;

private static final int MED_BANNER_WIDTH = 480;
private static final int MED_BANNER_HEIGHT = 60;

//Constants for phone sized ads (320x50)
private static final int BANNER_AD_WIDTH = 320;
private static final int BANNER_AD_HEIGHT = 50;

//rectangle
private static final int BANNER_RECT_WIDTH=300;
private static final int BANNER_RECT_HEIGHT=250;

private static final int EVENT_OTHER_SOCIAL = 70;

MMInterstitial interstitial;

	public boolean interstitial_requested;
	private String app_id;
	
	private int BannerXPos;
	private int BannerYPos;
	private int mBannerWidth=0;
	private int mBannerHeight=0;
	private MMAdView mAdView=null;
	
	protected boolean canFit(int adWidth) 
	{
		int adWidthPx = (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, adWidth, RunnerActivity.CurrentActivity.getResources().getDisplayMetrics());
		DisplayMetrics metrics = RunnerActivity.CurrentActivity.getResources().getDisplayMetrics();
		return metrics.widthPixels >= adWidthPx;
	}
	
	public void MMedia_Init(String _app_id)
	{
		app_id = _app_id;
		Log.i("yoyo","Calling InitMMedia with "+_app_id);
		RunnerActivity.ViewHandler.post( new Runnable() {
    	public void run() 
    	{	
			MMSDK.initialize(RunnerActivity.CurrentActivity);
			MMSDK.setLogLevel(MMSDK.LOG_LEVEL_ERROR);		
			
			interstitial = new MMInterstitial(RunnerActivity.CurrentActivity);
	
			//Set your metadata in the MMRequest object
			MMRequest request = new MMRequest();
	
			//Add metadata here.
	
			//Add the MMRequest object to your MMInterstitial.
			interstitial.setMMRequest(request);
			interstitial.setApid(app_id);
			interstitial_requested = false;
			
			interstitial.setListener( new RequestListener.RequestListenerImpl() {
				/** Called when an ad is loaded. */
			    @Override
			    public void requestCompleted(MMAd mmAd) {
			    	Log.i("yoyo", "Interstitial Ad requestCompleted");
			    	sendInterstitialLoadedEvent( true );
			    }
			    
			    /** Called when an ad request failed. */
			    @Override
			    public void requestFailed(MMAd mmAd, MMException exception) {
			    	Log.i("yoyo", "Interstitial Ad requestFailed");
			    	sendInterstitialLoadedEvent( false );
			    }
			});

    	}});
	}

	public void MMedia_AddBanner(String _bannerId, double _sizeType )
	{
		MMedia_AddBannerAt( _bannerId, _sizeType, 0, 0 );
	}
	
	public void MMedia_AddBannerAt(String _bannerId, double _sizeType, double _x, double _y )
	{
		BannerXPos = (int)_x;
		BannerYPos = (int)_y;
		int sizeType = (int)(_sizeType+0.5);
		final String bannerId = _bannerId;
		
		int width = BANNER_AD_WIDTH;
		int height = BANNER_AD_HEIGHT;

		if( sizeType == 1) //RECTANGLE
		{
			width = BANNER_RECT_WIDTH;
			height = BANNER_RECT_HEIGHT;
		}
		else //BANNER
		{
			//Finds an ad that best fits a users device.
			if(canFit(IAB_LEADERBOARD_WIDTH)) {
				width = IAB_LEADERBOARD_WIDTH;
				height = IAB_LEADERBOARD_HEIGHT;
			} else if(canFit(MED_BANNER_WIDTH)) {
				width = MED_BANNER_WIDTH;
				height = MED_BANNER_HEIGHT;
			}
		}
		
		final int placementWidth = width;
		final int placementHeight = height;
		
		//Calculate the size of the adView based on the ad size. Replace the width and height values if needed.
		final int layoutWidth = (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, placementWidth, RunnerActivity.CurrentActivity.getResources().getDisplayMetrics());
		final int layoutHeight = (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, placementHeight, RunnerActivity.CurrentActivity.getResources().getDisplayMetrics());
		
		mBannerWidth = layoutWidth;
		mBannerHeight = layoutHeight;
		
		Log.i("yoyo", "placement:" + placementWidth + "," + placementHeight );
		Log.i("yoyo", "layout:" + layoutWidth + "," + layoutHeight );
		
		RunnerActivity.ViewHandler.post( new Runnable() {
    	public void run() 
    	{	
    		//remove existing banner
    		AbsoluteLayout layout = (AbsoluteLayout)RunnerActivity.CurrentActivity.findViewById(R.id.ad);
			ViewGroup vg = (ViewGroup)layout;

			//remove existing banner
			if( mAdView != null )
			{
				if(vg!=null)
				{
					vg.removeView( mAdView );
				}
				//mAdView.destroy();
				mAdView = null;
			}
    		
			mAdView = new MMAdView( RunnerActivity.CurrentActivity);

			//Replace YOUR_APID with the APID provided to you by Millennial Media
			mAdView.setApid(bannerId);

			//Set your metadata in the MMRequest object
			MMRequest request = new MMRequest();

			//Add metadata here.

			//Add the MMRequest object to your MMAdView.
			mAdView.setMMRequest(request);

			//Sets the id to preserve your ad on configuration changes.
			mAdView.setId(MMSDK.getDefaultAdId());
			
			//Set the ad size. Replace the width and height values if needed.
			mAdView.setWidth(placementWidth);
			mAdView.setHeight(placementHeight);
			
			//Create the layout parameters using the calculated adView width and height.
			//RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(layoutWidth, layoutHeight);
			//This positions the banner.
			//layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
			//layoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
			//mAdView.setLayoutParams(layoutParams);

			//Add the adView to the layout. The layout is assumed to be a RelativeLayout.
			vg.addView(mAdView);
			
			//AbsoluteLayout.LayoutParams params = new AbsoluteLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, x,y );
			//mAdView.setLayoutParams( params);
			//mAdView.requestLayout();

			mAdView.setListener( new RequestListener.RequestListenerImpl() {
			
				/** Called when an ad is loaded. */
			    @Override
			    public void requestCompleted(MMAd mmAd) {
			    	Log.i("yoyo", "BannerAd requestCompleted");
			    	sendBannerLoadedEvent( true );
			    }
			    
			    /** Called when an ad request failed. */
			    @Override
			    public void requestFailed(MMAd mmAd, MMException exception) {
			    	Log.i("yoyo", "BannerAd requestFailed");
			    	sendBannerLoadedEvent( false );
			    }
			});
			
			mAdView.getAd();
		}});
	}
	
	public void MMedia_MoveBanner( double _x, double _y)
	{
		Log.i("yoyo", "MoveBanner:" + _x + "," + _y);
		final int x = (int)_x;
		final int y = (int)_y;
		BannerXPos = x;
		BannerYPos = y;
		if( mAdView != null)
		{
			RunnerActivity.ViewHandler.post( new Runnable() {
			public void run()
			{
				if( x < 0 && y < 0) 
				{
					mAdView.setVisibility(View.INVISIBLE);
				}
				else
				{
					//AbsoluteLayout.LayoutParams params = new AbsoluteLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, x,y );
					AbsoluteLayout.LayoutParams params = new AbsoluteLayout.LayoutParams( mBannerWidth, mBannerHeight, x,y );
					mAdView.setLayoutParams( params);
					mAdView.requestLayout();
					mAdView.setVisibility(View.VISIBLE);
				}
			}});
		}
	}
	
	public void MMedia_RemoveBanner()
	{
		Log.i("yoyo", "MMedia_RemoveBanner");
		if( mAdView != null )
		{
			RunnerActivity.ViewHandler.post( new Runnable() {
			public void run() 
		    {
				AbsoluteLayout layout = (AbsoluteLayout)RunnerActivity.CurrentActivity.findViewById(R.id.ad);
				ViewGroup vg = (ViewGroup)layout;
				if(vg!=null)
				{
					vg.removeView( mAdView );
				}
				//adView.destroy();
				mAdView = null;
				mBannerWidth = 0;
				mBannerHeight = 0;
		    }});
		}
	}
	
	public double MMedia_BannerGetWidth()
	{
		return mBannerWidth;
	}
	
	public double MMedia_BannerGetHeight()
	{
		return mBannerHeight;
	}

	public void MMedia_LoadInterstitial()
	{
		RunnerActivity.ViewHandler.post( new Runnable() {
    	public void run() {	
		interstitial_requested = true;
		interstitial.fetch();
		}
		});
	}
	
	public void MMedia_ShowInterstitial()
	{
		RunnerActivity.ViewHandler.post( new Runnable() {
    	public void run() {	
		interstitial_requested =false;
		interstitialstatus="Not Ready";
		interstitial.display();
		}});
	}
	
	String interstitialstatus="Not Ready";
	
	public String MMedia_InterstitialStatus()
	{
		RunnerActivity.ViewHandler.post( new Runnable() {
    	public void run() {	
			if(interstitial_requested)
    		//if( interstitial != null)
			{
				if(interstitial.isAdAvailable())
				{
					interstitialstatus="Ready";
				}
				else
					interstitialstatus="Not Ready";
			}
		}});
		
		return interstitialstatus;
	}
	
	private void sendBannerLoadedEvent( boolean _bLoaded )
	{
		int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
		
		RunnerJNILib.DsMapAddString( dsMapIndex, "type", "banner_load" );
		double loaded = (_bLoaded) ? 1 : 0;
		RunnerJNILib.DsMapAddDouble( dsMapIndex, "loaded", loaded);
		
		if( _bLoaded)
		{
			MMedia_MoveBanner(BannerXPos, BannerYPos);
		
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "width",  MMedia_BannerGetWidth());
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "height",  MMedia_BannerGetHeight());
		}
		
		RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
	}
	
	private void sendInterstitialLoadedEvent( boolean _bLoaded )
	{
		int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
		RunnerJNILib.DsMapAddString( dsMapIndex, "type", "interstitial_load" );
		double loaded = (_bLoaded) ? 1 : 0;
		RunnerJNILib.DsMapAddDouble( dsMapIndex, "loaded", loaded);
		RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
	}
	
}


