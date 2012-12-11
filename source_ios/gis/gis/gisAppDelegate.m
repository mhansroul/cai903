//
//  gisAppDelegate.m
//  gis
//
//  Created by mishanet on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gisAppDelegate.h"
#import "LoginViewController.h"
#import "HttpLoginOperation.h"
#import "GetApplicationOperation.h"
#import "GetConfigXml.h"
#import "MainViewController.h"


@implementation gisAppDelegate

@synthesize window = _window;
@synthesize loginViewController=_loginViewController;
@synthesize mainViewController=_mainViewController;
@synthesize loginOperation=_loginOperation;
- (void)dealloc
{

    self.loginViewController = nil;
    self.mainViewController = nil;
    self.loginOperation = nil;
    [_loginOperation release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *loginViewNib = [info objectForKey:@"Login nib file base name"];
    self.loginViewController = [[[LoginViewController alloc] initWithNibName:loginViewNib bundle:nil] autorelease];
    self.loginViewController.delegate = self;
    
    self.loginOperation = [[[HttpLoginOperation alloc]init] autorelease];
    
    self.loginViewController.loginOperation = self.loginOperation;
    // Add the main view to the window.
    self.mainViewController = [[[MainViewController alloc] init] autorelease];
    [self.window addSubview:self.mainViewController.view];
    self.mainViewController.loginOperation = self.loginOperation;
    self.mainViewController.sebesOperation = [[[GetApplicationOperation alloc]init] autorelease];
    self.mainViewController.configXmlOperation = [[[GetConfigXml alloc]init] autorelease];
    // Show the login view modally. When the user logs in, we dismiss the modal dialog.
    [self.loginViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.mainViewController presentModalViewController:self.loginViewController animated:NO];
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController
{
    [self.mainViewController dismissModalViewControllerAnimated:YES];
    
    LoginOperation *loginOp = loginViewController.loginOperation;
    
    NSLog(@"Logged in. User Name='%@' Password='%@'", 
          loginOp.authenticatedUsername, 
          loginOp.authenticatedPassword);

    [loginOp deleteAuthenticatedData];
    
    [self.mainViewController initMap];
    
    self.loginViewController = nil;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}




@end
