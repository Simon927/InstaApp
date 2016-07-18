//
//  MasterViewController.h
//  startMe
//
//  Created by Matteo Gobbi on 19/12/12.
//  Copyright (c) 2012 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityViewController;

@interface MasterViewController : CustomViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, ASIHTTPRequestDelegate, MBProgressHUDDelegate> {
    UIBarButtonItem *btLogin;
    
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIButton *btSignIn;
    IBOutlet UIButton *btResetPass;
    IBOutlet UIButton *btCancel;
    
    DataManager *dman;
}

@property (nonatomic, retain) IBOutlet UITableView *tb;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (assign) bool isShownKeyboard;

-(IBAction)resetPass:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)signIn:(id)sender;

-(void)login;

@end
