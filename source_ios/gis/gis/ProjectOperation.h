//
//  ProjectOperation.h
//  gis
//
//  Created by mishanet on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@class ProjectOperation;

@protocol ProjectOperationDelegate <NSObject>

- (void)projectOperationCompleted:(ProjectOperation *)projectOperation 
                     withResult:(BOOL)successfulRequest 
                   errorMessage:(NSString *)errorMessage;

@end 

@interface ProjectOperation : NSObject{
    AGSPoint* point;
@protected
    NSString *_token;
    double inputX;
    double inputY;
@private
    NSInvocationOperation *_invocationOperation;
    NSOperationQueue *_operationQueue;
    BOOL _result;
    NSString *_errorMessage;
}

@property (nonatomic, assign) id<ProjectOperationDelegate> delegate;
@property (nonatomic, retain) AGSPoint* point;

- (void)beginProjectInfo:(NSString *)token x:(double)inputX y:(double)inputY;
- (BOOL)getProjectImpl:(NSString **)errorMessage;

-(void) setInputX: (double) value;
-(double) inputX; 

-(void) setInputY: (double) value;
-(double) inputY; 

@end
