//
//  Released by YoYo Games Ltd. on 17/04/2014. Intended for use with GM: S EA97 and above ONLY.
//  Copyright YoYo Games Ltd., 2014.
//  For support please submit a ticket at help.yoyogames.com
//
//


#import "MMAdView.h"
#import "MMInterstitial.h"

@interface MMediaExt:NSObject
{
	MMAdView *mmadView;
	NSTimer *timer;
}
- (void) MMedia_Init:(char*)IntID;
-(NSString *)MMedia_InterstitialStatus;
-(void)MMedia_ShowInterstitial;
-(void)MMedia_LoadInterstitial;
-(void)MMedia_AddBanner:(char*)_bannerID Arg2:(double)_sizeType;
-(void)MMedia_AddBannerAt:(char*)_bannerID Arg2:(double)_sizeType Arg3:(double)_x Arg4:(double)_y;
-(void)MMedia_RemoveBanner;
-(void)MMedia_MoveBanner:(double)_x Arg2:(double)_y;
-(double)MMedia_BannerGetWidth;
-(double)MMedia_BannerGetHeight;







@end
