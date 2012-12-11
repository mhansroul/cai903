//
//  ApplicationController.h
//  gis
//
//  Created by mishanet on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SebesApplication.h"


@protocol ApplicationDelegate
- (void)applicationSelected:(SebesApplication *)app;
@end

@interface ApplicationController : UITableViewController{
    id<ApplicationDelegate> _delegate;
    NSMutableArray *_groupes;
}

@property (nonatomic, assign) id<ApplicationDelegate> delegate;
- (void) setGroupes:(NSMutableArray *)groupes;
- (NSMutableArray *) groupes;

@end
