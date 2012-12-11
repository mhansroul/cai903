//
//  SebesOperation.h
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SebesOperation;
@class SebesApplication;

@protocol SebesOperationDelegate <NSObject>

- (void)sebesOperationCompleted:(SebesOperation *)sebesOperation 
                     withResult:(BOOL)successfulRequest 
                   errorMessage:(NSString *)errorMessage;

@end 

@interface SebesOperation : NSObject{
@protected
    NSString *_token;
    NSMutableArray *_groupes;
@private
    NSInvocationOperation *_invocationOperation;
    NSOperationQueue *_operationQueue;
    BOOL _result;
    NSString *_errorMessage;
}



@property (nonatomic, assign) id<SebesOperationDelegate> delegate;
- (void)beginApplicationInfo:(NSString *)token;
- (BOOL)getApplicationImpl:(NSString **)errorMessage;
- (SebesApplication*) getApplicationByName:(NSString *)name;
- (void) setGroupes:(NSMutableArray *)groupes;
- (NSMutableArray *) groupes;


@property (nonatomic, copy, readwrite) NSString *defaultGroupe;

@end
