//
//  ProjectOperation.m
//  gis
//
//  Created by mishanet on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectOperation.h"

@implementation ProjectOperation
@synthesize delegate=_delegate;
@synthesize point;

-(void) setInputX: (double) value
{
    inputX = value;
}

-(void) setInputY: (double) value
{
    inputY = value;
}

-(double) inputX
{
	return inputX;
}

-(double) inputY
{
	return inputY;
}

-(void)dealloc
{
    NSLog(@"[LoginOperation dealloc]");
    [point release];
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

- (void)beginProjectInfo:(NSString *)token x:(double)inputX y:(double)inputY
{
    if (_operationQueue)
    {
        NSLog(@"Cannot attempt to log in before the previous attempt completes.");
        return;
    }
    
    // Copy the credentials for later use.
    _token = [token copy];
    self.inputX = inputX;
    self.inputY = inputY;
    
    // Create an operation that will be executed async.
    _invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self 
                                                               selector:@selector(executeAsync) 
                                                                 object:nil];
    
    // Enqueue the operation so that it will be executed on a worker thread.
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue addOperation:_invocationOperation];
}

- (BOOL)getProjectImpl:(NSString **)errorMessage
{
    NSLog(@"Classes derived from LoginOperation must override authenticateImpl:");
    return YES;
}


- (void)executeAsync
{
    NSAssert(![NSThread currentThread].isMainThread, @"executeAsync should run on a worker thread.");
    
    // Let the child class perform the authentication.
    _result = [self getProjectImpl:&_errorMessage];    
    
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
    
    [self.delegate projectOperationCompleted:self 
                                withResult:_result 
                              errorMessage:_errorMessage];
    
    [self releaseReferences];
    
    
}

@end
