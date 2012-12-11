//
//  SebesOperation.m
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SebesOperation.h"
#import "SebesApplication.h"

@implementation SebesOperation
@synthesize delegate=_delegate;
@synthesize defaultGroupe=_defaultGroupe;

- (void)beginApplicationInfo:(NSString *)token
{
    if (_operationQueue)
    {
        NSLog(@"Cannot attempt to log in before the previous attempt completes.");
        return;
    }
    
    // Copy the credentials for later use.
    _token = [token copy];
    
    // Create an operation that will be executed async.
    _invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self 
                                                               selector:@selector(executeAsync) 
                                                                 object:nil];
    
    // Enqueue the operation so that it will be executed on a worker thread.
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue addOperation:_invocationOperation];
}

- (BOOL)getApplicationImpl:(NSString **)errorMessage
{
    NSLog(@"Classes derived from LoginOperation must override authenticateImpl:");
    return YES;
}


- (void)executeAsync
{
    NSAssert(![NSThread currentThread].isMainThread, @"executeAsync should run on a worker thread.");
    
    // Let the child class perform the authentication.
    _result = [self getApplicationImpl:&_errorMessage];    
    
    // Dispatch a call to the UI thread to notify the world of the authentication result.
    [self performSelectorOnMainThread:@selector(onCompleted) 
                           withObject:nil 
                        waitUntilDone:NO];
}

- (void)onCompleted
{
    if (_result)
    {
        
    }
    
    [self.delegate sebesOperationCompleted:self 
                                withResult:_result 
                              errorMessage:_errorMessage];
    
    [self releaseReferences];
    
    
}

-(SebesApplication*) getApplicationByName:(NSString *)name{
    

    for (SebesApplication * app in [self groupes]) { 
        if([[app name] isEqualToString:name])
        {
            return app;
        }
    }
    return nil;
}

- (void) setGroupes:(NSMutableArray *)groupes
{
    _groupes = groupes;
}

- (NSMutableArray *) groupes
{
    return _groupes;
}

-(void)dealloc
{
    NSLog(@"[LoginOperation dealloc]");
    [self releaseReferences];
    [_groupes release];
    [_defaultGroupe release];
    [super dealloc];
}

- (void)releaseReferences
{
    [_token release];
    [_invocationOperation release];
    [_operationQueue release];

    _token = nil;
    _invocationOperation = nil;
    _operationQueue = nil;
    _errorMessage = nil;
}

@end
