//
//  BasemapController.h
//  gis
//
//  Created by mishanet on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigXmlOperation.h"
#import "SebesMapService.h"

@protocol BasemapDelegate
- (void)basemapSelected:(SebesMapService *)mapService;
@end

@interface BasemapController : UITableViewController{
    NSMutableArray *_basemaps;
    id<BasemapDelegate> _delegate;
}

- (void) setBasemaps:(NSMutableArray *)basemaps;
- (NSMutableArray *) basemaps;
@property (nonatomic, assign) id<BasemapDelegate> delegate;

@end
