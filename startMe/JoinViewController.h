//
//  JoinViewController.h
//  startMe
//
//  Created by Matteo Gobbi on 20/12/12.
//  Copyright (c) 2012 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

#import "User.h"

@interface JoinViewController : CustomViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, MBProgressHUDDelegate> {
    
    IBOutlet UITableView *tb;
    IBOutlet UIScrollView *myScroll;
    
    IBOutlet UIButton *btSignUp;
}

@property (nonatomic, retain) User *user;

-(IBAction)cancel:(id)sender;
-(IBAction)signUp:(id)sender;

@end
