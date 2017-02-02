//
//  Released by YoYo Games Ltd. on 17/04/2014. Intended for use with GM: S EA97 and above ONLY.
//  Copyright YoYo Games Ltd., 2014.
//  For support please submit a ticket at help.yoyogames.com
//
//


#import "MMedia.h"
#import "UIKit/UIkit.h"



#define MILLENNIAL_IPHONE_AD_VIEW_FRAME CGRectMake(0, 0, 320, 50)
#define MILLENNIAL_IPAD_AD_VIEW_FRAME CGRectMake(0, 0, 728, 90)
#define MILLENNIAL_AD_VIEW_FRAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? MILLENNIAL_IPAD_AD_VIEW_FRAME : MILLENNIAL_IPHONE_AD_VIEW_FRAME)

const int EVENT_OTHER_SOCIAL = 70;
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
extern UIViewController *g_controller;
extern UIView *g_glView;
extern int g_DeviceWidth;
extern int g_DeviceHeight;

NSString *g_AdId;
NSString *g_BannerAdId;

@implementation MMediaExt


-(void)sendBannerLoadedEvent:(int)_loaded
{
	int dsMapIndex;
	if( _loaded != 0 )
	{
		double bannerWidth = [self MMedia_BannerGetWidth];
		double bannerHeight = [self MMedia_BannerGetHeight];
	
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

- (void)getAd {
    // Get a banner ad
	if( mmadView != nil )
	{
		[mmadView getAdWithRequest:[MMRequest request]
		  onCompletion:^(BOOL success, NSError *error) {
			if (success) {
				NSLog(@"AD REQUEST SUCCEEDED");
			}
			else {
				NSLog(@"AD REQUEST FAILED WITH ERROR %@", error);
			}
		}];
	}
}



-(void)MMedia_LoadInterstitial
{
	MMRequest *request = [MMRequest request];

    //
    [MMInterstitial fetchWithRequest:request
                                apid:g_AdId
                        onCompletion:^(BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"Ad available");
								[self sendInterstitialLoadedEvent:1];
                            }
                            else {
                                NSLog(@"Error fetching interstitial ad: %@", error);
								[self sendInterstitialLoadedEvent:0];
                            }
                        }];
}


-(void)MMedia_ShowInterstitial
{
	if ([MMInterstitial isAdAvailableForApid:g_AdId]) {
        [MMInterstitial displayForApid:g_AdId
            fromViewController:g_controller
                       withOrientation:[g_controller interfaceOrientation]
                          onCompletion:nil];
    }
    else {
        //MMRequest Object
        MMRequest *request = [MMRequest request];

        [MMInterstitial fetchWithRequest:request
                                apid:g_AdId
                        onCompletion:^(BOOL success, NSError *error) {
                            if (success) {
                                [MMInterstitial displayForApid:g_AdId
                                            fromViewController:g_controller
                                               withOrientation:[g_controller interfaceOrientation]
                                                  onCompletion:nil];
                            }
                        }];
    }
}

-(NSString *)MMedia_InterstitialStatus
{
	if ([MMInterstitial isAdAvailableForApid:g_AdId]) {
		return @"Ready";
	}
	else
	{
		return @"Not ready";
	}
}

-(void)MMedia_AddBanner:(char*)_bannerID Arg2:(double)_sizeType
{
	[self MMedia_AddBannerAt:_bannerID Arg2:_sizeType Arg3:0 Arg4:0];
}

-(void)MMedia_AddBannerAt:(char*)_bannerID Arg2:(double)_sizeType Arg3:(double)_x Arg4:(double)_y
{
	//remove existing...
	if( mmadView != nil )
	{
		[mmadView removeFromSuperview];
		[mmadView release];
		mmadView = nil;
	}
	
	if( g_BannerAdId != nil )
	{
		[g_BannerAdId release];
		g_BannerAdId = nil;
	}
	g_BannerAdId = [NSString stringWithCString:_bannerID encoding:NSUTF8StringEncoding];
	[g_BannerAdId retain];
	
	int sizeType = (int)(_sizeType+0.5);
	CGRect adFrame;
	
	if( sizeType == 1 )
	{
		//RECTANGLE
		adFrame = CGRectMake(0, 0, 300, 250);
	}
	else	//BANNER
	{
		adFrame = MILLENNIAL_AD_VIEW_FRAME;
	}
	
	//set position - display->view coords
	int x = (int)(_x * g_glView.bounds.size.width) / g_DeviceWidth;
	int y = (int)(_y * g_glView.bounds.size.height) / g_DeviceHeight;
	
	adFrame.origin.x = x;
	adFrame.origin.y = y;
	
	mmadView = [[MMAdView alloc] initWithFrame:adFrame
									apid:g_BannerAdId
									rootViewController:g_controller
									];
									
	MMRequest *request = [MMRequest request];
	[mmadView getAdWithRequest:request onCompletion:^(BOOL success,NSError *error)
	{
		if(success)
		{
			NSLog(@"Millennial ad request succeeded");
			[self sendBannerLoadedEvent:1];
		}
		else
		{
			NSLog(@"Millennial ad request failed with error %@",error);
			[self sendBannerLoadedEvent:0];
		}
	}];
	
	[g_glView addSubview:mmadView];
	
	if( timer == nil )
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:30.0
			target:self
			selector:@selector(getAd)
			userInfo:nil
			repeats:YES];
		[timer fire];
	}
}

-(void)MMedia_RemoveBanner
{
	if( mmadView != nil )
	{
		[mmadView removeFromSuperview];
		[mmadView release];
		mmadView = nil;
	}
	if( timer != nil )
	{
		[timer invalidate];
		timer = nil;
	}
}

-(void)MMedia_MoveBanner:(double)_x Arg2:(double)_y
{
	//NSLog(@"Move Banner: %d,%d", (int)_x, (int)_y );
	if( mmadView != nil )
	{
		if( _x < 0 && _y < 0 )
		{
			//hide the view
			mmadView.hidden = YES;
		}
		else
		{
			//display->view coords
			int x = (int)(_x * g_glView.bounds.size.width) / g_DeviceWidth;
			int y = (int)(_y * g_glView.bounds.size.height) / g_DeviceHeight;
			
			CGRect frame = mmadView.frame;
			frame.origin.x = x;
			frame.origin.y = y;
			mmadView.frame =frame;
			mmadView.hidden = NO;
		}
	}
}

-(double)MMedia_BannerGetWidth
{
	if( mmadView != nil )
	{
		//->display width
		float adW = mmadView.frame.size.width;
		int dispW = (int)(( adW * g_DeviceWidth ) / g_glView.bounds.size.width);
		return dispW;
	}
	return 0;
}

-(double)MMedia_BannerGetHeight
{
	if( mmadView != nil )
	{
		//->display height
		float adH = mmadView.frame.size.height;
		int dispH = (int)(( adH * g_DeviceHeight ) / g_glView.bounds.size.height);
		return dispH;
	}
	return 0;
}

- (void) MMedia_Init:(char *)IntID 
{	
	g_AdId = [NSString stringWithCString:IntID encoding:NSUTF8StringEncoding];
	[g_AdId retain];
}

@end

