//
//  HttpLoginOperation.m
//  gis
//
//  Created by mishanet on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpLoginOperation.h"
#import "ASIFormDataRequest.h"
#import "GlobalWebservice.h"
#import "JSON.h"
#import "Constants.h"

@implementation HttpLoginOperation
- (BOOL)authenticateImpl:(NSString **)errorMessage
{
    NSString *urlLogin = [@"" stringByAppendingFormat:@"http://sebesgis.sebes.lu/sebes/TokenService/TokenService.svc/user/Login?username=%@&password=%@", _username,_password];
    NSURL *url = [NSURL URLWithString:urlLogin];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
     NSError *httpError = [request error];
  
    
    BOOL result = NO;
    
    if (!httpError) {
        NSString *receivedString = [request responseString];
        NSDictionary *dict = [receivedString JSONValue];
        
        
        NSDictionary *loginResult = [dict objectForKey:@"LoginResult"];
        NSString *StatusString = (NSString *)[loginResult objectForKey:@"Status"];
        
        if ([StatusString isEqualToString:@"SUCCESS"]) 
        {
            NSString *tokenString = (NSString *)[loginResult objectForKey:@"Token"];
            self.authenticatedToken = tokenString;
            result = YES;
        }   
        else if ([StatusString isEqualToString:@"DENIED"]) 
        {
            
            *errorMessage = @"Utilisateur ou mote de passe incorrect";
        }
        else {
            *errorMessage = @"Erreur inconnue";
        }
        
    }
    else
        *errorMessage = @"HTTP Error";

    //[request release];
    
    
    return result;
}
@end
