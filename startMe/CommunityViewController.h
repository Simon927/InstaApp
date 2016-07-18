//
//  CommunityViewController.h
//  startMe
//
//  Created by Matteo Gobbi on 31/07/13.
//  Copyright (c) 2013 Matteo Gobbi. All rights reserved.
//

#import "BaseViewController.h"
#import "GADBannerViewDelegate.h"

@interface CommunityViewController : BaseViewController<GADBannerViewDelegate>

@property (nonatomic, assign) BOOL chooseImage;
@property(nonatomic, strong) GADBannerView *adBanner;

@end
