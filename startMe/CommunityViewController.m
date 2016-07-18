//
//  CommunityViewController.m
//  startMe
//
//  Created by Matteo Gobbi on 31/07/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import "CommunityViewController.h"
#import "ChooseProfileImageViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

NSString * const AGGOURIA_GR_ADMOB_ID = @"ca-app-pub-4480214269191032/2666942918";

@interface CommunityViewController ()

@end

@implementation CommunityViewController

@synthesize adBanner;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addCenterButtonWithImage:[UIImage imageNamed:@"share1.png"] highlightImage:nil];
    
    DataManager *dman = [DataManager getInstance];
    [dman setCommunityViewController:self];
    [dman updateBadgeNotification];
    
    if([Utility userIsLogged]) [[DataManager getInstance] getNotifications];
    
//    [((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_EXPLORE]).tabBarItem setTitle:NSLocalizedString(@"btTabBarExplore", nil)];
//    [((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_FOLLOWING]).tabBarItem setTitle:NSLocalizedString(@"btTabBarFollowing", nil)];
//    [((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_NOTIFICATIONS]).tabBarItem setTitle:NSLocalizedString(@"btTabBarNotification", nil)];
//    [((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_PROFILE]).tabBarItem setTitle:NSLocalizedString(@"btTabBarProfile", nil)];

    UITabBarItem *tabBarItem1 = ((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_EXPLORE]).tabBarItem;
    UITabBarItem *tabBarItem2 = ((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_FOLLOWING]).tabBarItem;
    UITabBarItem *tabBarItem3 = ((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_NOTIFICATIONS]).tabBarItem;
    UITabBarItem *tabBarItem4 = ((UINavigationController *)[self.viewControllers objectAtIndex:INDEX_OF_PROFILE]).tabBarItem;
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"29-heart2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"29-heart.png"]];
    
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"112-group2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"112-group.png"]];
    
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"notif2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"notif.png"]];
    
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"123-id-card2.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"123-id-card.png"]];
    
    [tabBarItem1 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [tabBarItem2 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [tabBarItem3 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [tabBarItem4 setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    
    
    CGRect size = [[UIScreen mainScreen] bounds];
    
    adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait
                                              origin:CGPointMake(0.0, size.size.height - 98)];
    
    adBanner.adUnitID = AGGOURIA_GR_ADMOB_ID;
    adBanner.rootViewController = self;
    
    [self.view addSubview:adBanner];
    GADRequest *r = [[GADRequest alloc] init];
    r.testing = NO;
    [adBanner loadRequest:r];
    
    //add this line in dealloc method
    adBanner.delegate = self;
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:71.0/255.0 green:142.0/255.0 blue:196.0/255.0 alpha:1.0]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if(_chooseImage) {
        [self performSegueWithIdentifier:@"CommunityToChooseImageProfile" sender:self];
        _chooseImage = NO;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CommunityToChooseImageProfile"]) {
        ((ChooseProfileImageViewController *)segue.destinationViewController).modalityNick = YES;
    }
    
}


-(void)centerButtonPressed {
    if([DataManager getInstance].isSendingPost) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"messageSendingPost", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [super centerButtonPressed];
    
    [self performSegueWithIdentifier:@"CommunityToShare" sender:self];
}


#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

@end
