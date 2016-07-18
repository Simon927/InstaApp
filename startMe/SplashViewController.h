//
//  SplashViewController.h
//  startMe
//
//  Created by Lion on 3/30/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : CustomViewController <UITextFieldDelegate, UIAlertViewDelegate, ASIHTTPRequestDelegate, MBProgressHUDDelegate>
{
    IBOutlet UIButton *btJoinFB;
    
    DataManager *dman;
}

@property (nonatomic, retain) NSString* m_email;
@property (nonatomic, retain) NSString* m_password;

-(IBAction)joinFB:(id)sender;
-(void)login;

@end
