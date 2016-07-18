//
//  SplashViewController.m
//  startMe
//
//  Created by Lion on 3/30/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "SplashViewController.h"
#import "MasterViewController.h"

@interface SplashViewController ()
{
    BOOL chooseImage;
}
-(void)initializeView;
-(void)getUserDetails;

@end

@implementation SplashViewController

@synthesize m_email, m_password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [btJoinFB setTitle:NSLocalizedString(@"btJoinFB", "Button in the soryboard to login with FB") forState:UIControlStateNormal];

    dman = [DataManager getInstance];

    [self initializeView];
}

-(void)initializeView {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //Check if there is an active session
    if(![[Utility getSession] isEqualToString:@""]) {
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            // Yes, so just open the session (this won't display any UX).
            //Login with new facebook session
            [self openSession];
        } else {
            //Use the actual session
            [self goToCommunity];
        }
    }
    
    [[DataManager getInstance] setIsLogIn:YES];
}

-(void)login {
    //[self.view endEditing:YES];
    
    [self loginWithSendConfirm:NO];
}


-(void)loginWithSendConfirm:(BOOL)send {
    [self startModeLoadingWithText:NSLocalizedString(@"Login", nil)];
    
    NSString *email = m_email;
    NSString *password = m_password;
    
    email = [Utility encryptString:email];
    password = [Utility encryptString:password];
    NSString *device = [Utility encryptString:[Utility getDeviceAppId]];
    NSString *token = [Utility encryptString:[Utility getDeviceToken]];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    language = [Utility encryptString:language];
    
    NSString *strSend = @"false";
    if(send) strSend = @"true";
    
    //POST
    NSString *str = [URL_SERVER stringByAppendingString:@"login.php"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:device forKey:@"device"];
    [request setPostValue:token forKey:@"token"];
    [request setPostValue:language forKey:@"lang"];
    [request setPostValue:strSend forKey:@"send_confirm"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self stopModeLoading];
    
    if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        
        NSString *login = [responseDict valueForKey:@"login"];
        
        if([login isEqualToString:@"1"] || [login isEqualToString:@"4"]) {
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            HUD.labelText = NSLocalizedString(@"Access permitted!", nil);
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
            
            //Login permitted
            NSString *user_id = [responseDict valueForKey:@"user_id"];
            NSString *session = [responseDict valueForKey:@"session"];
            NSString *facebook = [responseDict valueForKey:@"facebook"];
            NSString *image = [responseDict valueForKey:@"img_profile"];
            NSString *nickname = [responseDict valueForKey:@"nickname"];
            
            user_id = [Utility decryptString:user_id];
            session = [Utility decryptString:session];
            facebook = [Utility decryptString:facebook];
            image = [Utility decryptString:image];
            nickname = [Utility decryptString:nickname];
            
            if(![session isEqualToString:@""] && session != nil) {
                [Utility setDefaultValue:user_id forKey:USER_ID];
                [Utility setDefaultValue:session forKey:USER_SESSION];
                [Utility setDefaultValue:facebook forKey:USER_FACEBOOK_LOGIN];
                [Utility setDefaultValue:nickname forKey:USER_NICKNAME];
            }
            
            if(image) {
                UIImage *im = [Utility getCachedImageFromPath:[URL_SERVER stringByAppendingString:PATH_IMAGES_PROFILES] withName:image];
                [Utility setDefaultObject:UIImageJPEGRepresentation(im, 1.0) forKey:USER_IMG_PROFILE];
            }
            
            //Reset all param for the new logged user
            [[DataManager getInstance] resetParam];
            
            chooseImage = [login isEqualToString:@"4"];
            
            [self goToCommunity];
            
            return;
            
        } else if([login isEqualToString:@"-1"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Server error", nil) message:NSLocalizedString(@"messageDatabaseError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if([login isEqualToString:@"0"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"errorAccountData", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if([login isEqualToString:@"3"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"messageConfirmEmail", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else if([login isEqualToString:@"2"]) {
            //Show alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:NSLocalizedString(@"errorConfirmEmail", nil) delegate:self cancelButtonTitle:@"No, grazie" otherButtonTitles:@"Invia",nil];
            alert.tag = 1;
            [alert show];
            [alert release];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:NSLocalizedString(@"messageConnectionError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    [dman logout];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [dman logout];
    [self stopModeLoading];
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}


-(void)goToCommunity {
    
    //Go to community
    [self performSegueWithIdentifier:@"SplashToCommunity" sender:self];
}

- (IBAction)joinFB:(id)sender {
    if (!FBSession.activeSession.isOpen) {
        [self openSession];
    }
}



- (void)getUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 //Get info from facebook: if the user already exist, there isn't problem
                 NSDictionary *dict = (NSDictionary *)user;
                 
                 //Temp nickname
                 NSString *nickname = user.username;
                 [Utility setDefaultValue:nickname forKey:USER_TEMPFB_NICKNAME];
                 nickname = [Utility encryptString:nickname];
                 
                 NSString *name = [Utility encryptString:user.first_name];
                 NSString *surname = [Utility encryptString:user.last_name];
                 NSString *gender = [Utility encryptString:[dict valueForKey:@"gender"]];
                 NSString *birthday = [Utility encryptString:user.birthday];
                 NSString *profile_id = user.id;
                 profile_id = [Utility encryptString:profile_id];
                 NSString *email = [Utility encryptString:[dict valueForKey:@"email"]];
                 
                 NSString *device = [Utility encryptString:[Utility getDeviceAppId]];
                 NSString *token = [Utility encryptString:[Utility getDeviceToken]];
                 
                 NSString *str = [URL_SERVER stringByAppendingString:@"fb_login.php"];
                 
                 NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                 language = [Utility encryptString:language];
                 
                 //Start parser thread
                 ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
                 [request setPostValue:name forKey:@"name"];
                 [request setPostValue:surname forKey:@"surname"];
                 [request setPostValue:profile_id forKey:@"facebook"];
                 [request setPostValue:device forKey:@"device"];
                 [request setPostValue:token forKey:@"token"];
                 [request setPostValue:language forKey:@"lang"];
                 [request setPostValue:birthday forKey:@"birthday"];
                 [request setPostValue:gender forKey:@"gender"];
                 [request setPostValue:email forKey:@"email"];
                 [request setDelegate:self];
                 [request startAsynchronous];
             } else {
                 [[DataManager getInstance] logout];
                 [self stopModeLoading];
             }
         }];
    } else {
        
    }
}


/*****NEW APPROCH*****/

#pragma mark -
#pragma mark - FB state changed NEW

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self getUserDetails];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [FBSession.activeSession closeAndClearTokenInformation];
            [self stopModeLoading];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Connection error", nil)
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [[DataManager getInstance] logout];
        [self stopModeLoading];
        [alertView show];
    }
}

- (void)openSession
{
    [self startModeLoadingWithText:NSLocalizedString(@"Login", nil)];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SplashToCommunity"]) {
        CommunityViewController *vc = (CommunityViewController *)segue.destinationViewController;
        vc.chooseImage = chooseImage;
        chooseImage = NO;
    }
}

@end
