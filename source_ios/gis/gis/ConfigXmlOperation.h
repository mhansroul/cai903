//
//  ConfigXmlOperation.h
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConfigXmlOperation;


@protocol ConfigXmlOperationDelegate <NSObject>

- (void)configXmlOperationCompleted:(ConfigXmlOperation *)configXmlOperation 
                     withResult:(BOOL)successfulRequest 
                   errorMessage:(NSString *)errorMessage;

@end 

@interface ConfigXmlOperation : NSObject{
@protected
    NSString *_token;
    NSString *_fileName;
@private
    NSInvocationOperation *_invocationOperation;
    NSOperationQueue *_operationQueue;
    BOOL _result;
    NSString *_errorMessage;
}



@property (nonatomic, assign) id<ConfigXmlOperationDelegate> delegate;
- (void)beginConfigXmlInfo:(NSString *)token 
                  fileName:(NSString *)fileName;
- (BOOL)getConfigXmlImpl:(NSString **)errorMessage;


@end
