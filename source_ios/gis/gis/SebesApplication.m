//
//  SebesApplication.m
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SebesApplication.h"

@implementation SebesApplication



-(SebesApplication*) init: (NSString*) name: (NSString*) fileName
{
    self = [super init];
    if(self)
    {
        [self setName:name];
        [self setFileName:fileName];
    }
    return self;
}

-(void) setName: (NSString*) name
{
    [_name release];
    _name = [name copy];
}


-(void) setFileName: (NSString*) fileName
{
    [_fileName release];
    _fileName = [fileName copy];
}


-(NSString*) name;
{
    return _name;
}

-(NSString *) fileName;
{
    
    return _fileName;
}


@end
