//
//  SebesApplication.h
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SebesOperation.h"

@interface SebesApplication : NSObject{
@protected
    NSString *_name;
    NSString *_fileName;
}

-(SebesApplication*) init: (NSString*) name: (NSString*) fileName;
-(void) setName: (NSString*) name;
-(void) setFileName: (NSString*) fileName;
-(NSString*) name;
-(NSString *) fileName;




@end
