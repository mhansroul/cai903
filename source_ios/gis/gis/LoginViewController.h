//
//  LoginViewController.h
//  gis
//
//  Created by mishanet on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOperation.h"

@class LoginViewController;
@protocol LoginViewControllerDelegate <NSObject>

// Invoked when the user credentials have been successfully authenticated.
// Check the LoginViewController's loginOperation to get the authenticated username and password.
- (void)loginViewControllerLoggedIn:(LoginViewController *)loginViewController;

@end


@interface LoginViewController : UIViewController <LoginOperationDelegate,UITextFieldDelegate> {
    
}
@property (nonatomic, assign) id<LoginViewControllerDelegate>    delegate;
@property (nonatomic, retain) LoginOperation *loginOperation;

// Outlets
@property (nonatomic, retain) IBOutlet UITextField              *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField              *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton                 *submitButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *waitIndicator;
@property (nonatomic, retain) IBOutlet UITextView               *errorMessageTextView;

// Actions
- (IBAction)submit:(id)sender;


@end
