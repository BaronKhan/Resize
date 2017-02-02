//
//  Released by YoYo Games Ltd. on 17/04/2014. Intended for use with GM: S EA97 and above ONLY.
//  Copyright YoYo Games Ltd., 2014.
//  For support please submit a ticket at help.yoyogames.com
//
//


#import "iAd/iad.h"

@interface iAdsExt:NSObject <ADBannerViewDelegate,ADInterstitialAdDelegate>
{
@private
	ADBannerView* iad;
	ADInterstitialAd *iadInterstitial;
}

-(void)iAds_Init;
-(NSString *)iAds_InterstitialStatus;
-(void)iAds_ShowInterstitial;
-(void)iAds_LoadInterstitial;
-(void)iAds_AddBanner;
-(void)iAds_HideBanner:(double)_hide;
//-(void)iAds_TogglePosition;
-(void)iAds_AddBannerAt:(double)_x Arg2:(double)_y;
-(double)iAds_BannerGetWidth;
-(double)iAds_BannerGetHeight;
-(void)iAds_MoveBanner:(double)_x Arg2:(double)_y;
-(void)iAds_RemoveBanner;




@end
