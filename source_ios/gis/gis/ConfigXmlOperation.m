//
//  ConfigXmlOperation.m
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigXmlOperation.h"

@implementation ConfigXmlOperation
@synthesize delegate=_delegate;

- (void)beginConfigXmlInfo:(NSString *)token 
                  fileName:(NSString *)fileName
{
    if (_operationQueue)
    {
        NSLog(@"Cannot attempt to log in before the previous attempt completes.");
        return;
    }
    
    // Copy the credentials for later use.
    _token = [token copy];
    _fileName = [fileName copy];
    // Create an operation that will be executed async.
    _invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self 
                                                               selector:@selector(executeAsync) 
                                                                 object:nil];
    
    // Enqueue the operation so that it will be executed on a worker thread.
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue addOperation:_invocationOperation];
}

- (BOOL)getConfigXmlImpl:(NSString **)errorMessage
{
    NSLog(@"Classes derived from LoginOperation must override authenticateImpl:");
    return YES;
}


- (void)executeAsync
{
    NSAssert(![NSThread currentThread].isMainThread, @"executeAsync should run on a worker thread.");
    
    // Let the child class perform the authentication.
    _result = [self getConfigXmlImpl:&_errorMessage];    
    
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
    
    [self.delegate configXmlOperationCompleted:self 
                                withResult:_result 
                              errorMessage:_errorMessage];
    
    [self releaseReferences];
    
    
}


-(void)dealloc
{
    NSLog(@"[LoginOperation dealloc]");
    [self releaseReferences];
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
