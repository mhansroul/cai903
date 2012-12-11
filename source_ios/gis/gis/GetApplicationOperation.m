//
//  GetApplicationOperation.m
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetApplicationOperation.h"
#import "ASIFormDataRequest.h"
#import "GlobalWebservice.h"
#import "JSON.h"
#import "Constants.h"
#import "SebesApplication.h"

@implementation GetApplicationOperation

- (BOOL)getApplicationImpl:(NSString **)errorMessage
{
    NSString *urlLogin = [@"" stringByAppendingFormat:@"http://sebesgis.sebes.lu/sebes/UserService/UserService.svc/user/UserInfo?_token=%@",_token];
    NSURL *url = [NSURL URLWithString:urlLogin];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *httpError = [request error];
    
    
    BOOL result = NO;
    
    if (!httpError) {
        NSString *receivedString = [request responseString];
        NSDictionary *dict = [receivedString JSONValue];
        
        
        NSDictionary *loginResult = [dict objectForKey:@"UserInfoResult"];
        self.defaultGroupe = (NSString *)[loginResult objectForKey:@"DefaultGroupe"];
        NSArray *groupesArray = (NSArray *)[loginResult objectForKey:@"Groupes"];
        
        [self setGroupes:[[NSMutableArray alloc] initWithCapacity:[groupesArray count]]]; 
        
        for (int i = 0; i < [groupesArray count]; i++)
        {
            NSDictionary *groupeDictionary = [groupesArray objectAtIndex:i];
            NSString *fileNameString = (NSString *)[groupeDictionary objectForKey:@"FileName"];
            NSString *nameString = (NSString *)[groupeDictionary objectForKey:@"Name"];
            SebesApplication *app= [[SebesApplication alloc] init: nameString : fileNameString];
            [[self groupes] addObject:app];
        }
        
       
        
        result = YES;
    }
    else
        *errorMessage = @"HTTP Error";
    
    //[request release];
    
    return result;
}
@end
