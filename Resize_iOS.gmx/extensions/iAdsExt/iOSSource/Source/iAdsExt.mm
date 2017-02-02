//
//  Released by YoYo Games Ltd. on 17/04/2014. Intended for use with GM: S EA97 and above ONLY.
//  Copyright YoYo Games Ltd., 2014.
//  For support please submit a ticket at help.yoyogames.com
//
//


#import "iAdsExt.h"
#import "UIKit/UIkit.h"

const int EVENT_OTHER_SOCIAL = 70;
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
extern UIViewController *g_controller;
extern UIView *g_glView;
extern int g_DeviceWidth;
extern int g_DeviceHeight;

bool g_BannerAdded=false;
bool g_BannerLoaded=false;
bool g_BannerHidden=false;

@implementation iAdsExt

-(void)iAds_LoadInterstitial
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[self cycleInterstitial];
	}
	else
	{
		NSLog(@"iAds_LoadInterstitial - only available on iPad");
	}
}

-(void)iAds_ShowInterstitial
{
	if(iadInterstitial!=nil)
    {
		if(iadInterstitial.loaded)
			[iadInterstitial presentFromViewController:g_controller];
    }
}

-(NSString *)iAds_InterstitialStatus
{
	if(iadInterstitial!=nil)
	{
		if( iadInterstitial.loaded)
			return @"Ready";
		else 
			return @"Not Ready";
	}
	return @"Not Ready";
}

int GetOrientation( void )
{
//    UIDeviceOrientation i = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation i = [[UIApplication sharedApplication] statusBarOrientation];
    if(( i== UIInterfaceOrientationLandscapeLeft) || ( i== UIInterfaceOrientationLandscapeRight)){
        return 0;
    }else{
        return 1;
    }
}

-(void)iAds_HideBanner:(double)_hide
{
	int hide = (int)(_hide+0.5);
	NSLog(@"Hide Banner %d", hide);
	if( iad != nil )
	{
		if( hide )
		{
			iad.hidden = YES;
			g_BannerHidden = true;
		}
		else
		{
			if( g_BannerLoaded )
				iad.hidden = NO;
			g_BannerHidden = false;
		}
	}
}

-(void)iAds_AddBannerAt:(double)_x Arg2:(double)_y
{
	[self iAds_AddBanner];
	[self iAds_MoveBanner:_x Arg2:_y];
}

-(void)iAds_AddBanner
{
	if(!g_BannerAdded)
	{
		NSLog(@"iAds_AddBanner creating banner");
		
		iad = [[ADBannerView alloc] initWithFrame:CGRectZero];
		
		iad.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierLandscape,ADBannerContentSizeIdentifierPortrait, nil];
	   
		if(GetOrientation() == 0)
		{
			iad.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
		}
		else {
			iad.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait; 
		}
		
		iad.delegate = self;
		[g_glView addSubview:iad]; // attach the ad to the view hierarchy; self.window is responsible for retaining the ad
		
		g_BannerAdded = true;
		g_BannerLoaded = false;
		g_BannerHidden = false;
		iad.hidden = YES;	//banner made visible on load
	}
	else
	{
		NSLog(@"iAds_AddBanner banner already created");
	}
}

-(void)iAds_MoveBanner:(double)_x Arg2:(double)_y
{
	if( iad != nil )
	{
		//display->view coords
		int x = (int)(_x * g_glView.bounds.size.width) / g_DeviceWidth;
		int y = (int)(_y * g_glView.bounds.size.height) / g_DeviceHeight;
		
		//NSLog(@"iAds_MoveBanner: x,y=%d,%d -> %d,%d", (int)_x, (int)_y, x, y );
		
		CGRect frame = iad.frame;
		frame.origin.x = x;
		frame.origin.y = y;
		iad.frame = frame;
	}
}

-(void)iAds_RemoveBanner
{
	if( iad != nil )
	{
		[iad removeFromSuperview];
		iad.delegate = nil;
		[iad release];
		
		iad = nil;
		g_BannerAdded = false;
		g_BannerLoaded = false;
	}
}

-(double)iAds_BannerGetWidth
{
	if( iad != nil )
	{
		float adW = iad.frame.size.width;
		//->display width
		int dispW = (int)(( adW * g_DeviceWidth ) / g_glView.bounds.size.width);
		return dispW;
	}
	return 0;
}

-(double)iAds_BannerGetHeight
{
	if( iad != nil )
	{
		float adH = iad.frame.size.height;
		//->display height
		int dispH = (int)(( adH * g_DeviceHeight ) / g_glView.bounds.size.height);
		return dispH;
	}
	return 0;
}


- (void) OnRotate:(NSNotification*)note
{
	if(iad!=nil)
	{
		UIInterfaceOrientation neworient = [[UIApplication sharedApplication] statusBarOrientation];
	
        if(neworient == UIInterfaceOrientationLandscapeLeft || neworient == UIInterfaceOrientationLandscapeRight)
        {
            iad.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        }
        else 
		{
            iad.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait; 
        }
   }   
}

- (void) iAds_Init
{	
	[[NSNotificationCenter defaultCenter] 
       addObserver:self
          selector:@selector(OnRotate:) 
              name:UIDeviceOrientationDidChangeNotification 
            object:nil];
}

-(void)sendBannerLoadedEvent:(int)_loaded
{
	int dsMapIndex;
	if( _loaded != 0 )
	{
		double bannerWidth = [self iAds_BannerGetHeight];
		double bannerHeight = [self iAds_BannerGetWidth];
	
		dsMapIndex = CreateDsMap(4,
					"type", 0.0, "banner_load",
					"loaded", 1.0, (void*)NULL,
					"width", bannerWidth, (void*)NULL,
					"height",bannerHeight,(void*)NULL
					);
	}
	else
	{
		dsMapIndex = CreateDsMap(2,
					"type", 0.0, "banner_load",
					"loaded", 0.0, (void*)NULL );
	}
	
	//send async event 
	CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
}

-(void)sendInterstitialLoadedEvent:(int)_loaded
{
	double loaded = (double)_loaded;
	int dsMapIndex = CreateDsMap(2,
					"type", 0.0, "interstitial_load",
					"loaded", loaded, (void*)NULL );

	//send async event 
	CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
}


-(void) bannerView:(ADBannerView*)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"bannerView didFailToReceiveAdWithError %@", [error localizedDescription]);
	
	[self sendBannerLoadedEvent:0];
	g_BannerLoaded = false;
	//on a load fail, the banner should be hidden;
	//-the banner view continues to try to download new advertisements ( and is set to visible again if load succeeds )
	iad.hidden = YES;
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd");
	[self sendBannerLoadedEvent:1];
	g_BannerLoaded = true;
	if( !g_BannerHidden )
	{
		iad.hidden = NO;
	}
}

- (void)cycleInterstitial
{

    // Clean up the old interstitial...
    if(iadInterstitial!=nil)
    {
        iadInterstitial.delegate = nil;
        [iadInterstitial release];
    }
    // and create a new interstitial. We set the delegate so that we can be notified of when
    iadInterstitial = [[ADInterstitialAd alloc] init];
    iadInterstitial.delegate = self;

}

#pragma mark ADInterstitialViewDelegate methods

// When this method is invoked, the application should remove the view from the screen and tear it down.
// The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
// This may occur either when the user dismisses the interstitial view via the dismiss button or
// if the content in the view has expired.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd interstitial did unload");
    [self cycleInterstitial];
   
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"iAd interstitial did fail");
	[self sendInterstitialLoadedEvent:0];
    [self cycleInterstitial];
}

// This method is invoked when the interstitial has confirmation that an ad will be presented, but before the ad
// has loaded resources necessary for presentation.
- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd interstitial will load");
}

// This method is invoked when the interstitial ad load ad content. The delegate should implement this method so that
// it knows when the interstitial ad is ready to be presented.
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd interstitial did load");
	[self sendInterstitialLoadedEvent:1];
}

// This message will be sent when the user chooses to interact with the ad unit for the interstitial ad.
// The delegate may return NO to block the action from taking place, but this
// should be avoided if possible because most advertisements pay significantly more when
// the action takes place and, over the longer term, repeatedly blocking actions will
// decrease the ad inventory available to the application. Applications should reduce
// their own activity while the advertisement's action executes.
- (BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave
{
    
        NSLog(@"iAd interstitial action should begin");
    return true;
    
}

// This message is sent when the action has completed and control is returned to the application.
// Games, media playback, and other activities that were paused in response to the beginning
// of the action should resume at this point.
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd interstitial action did finish");
}


@end

