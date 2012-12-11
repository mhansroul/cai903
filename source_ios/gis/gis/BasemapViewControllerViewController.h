//
//  BasemapViewControllerViewController.h
//  gis
//
//  Created by mishanet on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasemapDelegate
- (void)basemapSelected:(NSString *)color;
@end

@interface BasemapViewControllerViewController : UITableViewController{
    NSMutableArray *_colors;
    id<BasemapDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *colors;
@property (nonatomic, assign) id<BasemapDelegate> delegate;

@end
