//
//  gisAppDelegate.h
//  gis
//
//  Created by mishanet on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@class MainViewController;
@interface gisAppDelegate : NSObject <UIApplicationDelegate, LoginViewControllerDelegate> {
    
}
@property (nonatomic, retain) LoginOperation *loginOperation;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) MainViewController *mainViewController;
@end
