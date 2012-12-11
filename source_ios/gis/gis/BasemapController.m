//
//  BasemapController.m
//  gis
//
//  Created by mishanet on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasemapController.h"
#import "GetConfigXml.h"
#import "SebesMapService.h"

@interface BasemapController ()

@end

@implementation BasemapController

@synthesize delegate = _delegate;

- (void) setBasemaps:(NSMutableArray *)basemaps
{
    _basemaps = basemaps;
}

- (NSMutableArray *) basemaps
{
    return _basemaps;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		//self.contentSizeForViewInPopover = CGSizeMake(100, 1 * 44 - 1);
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.tableView.rowHeight = 44.0;
	self.view.backgroundColor = [UIColor clearColor];
    
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.basemaps count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    SebesMapService * mservice = [self.basemaps objectAtIndex:indexPath.row];
    
    NSString *color = mservice.label;//[_colors objectAtIndex:indexPath.row];
    cell.textLabel.text = color;
    
    // Configure the cell...
	//cell.textLabel.text = [NSString stringWithFormat:@"Item %d", [indexPath row]]; 
	cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate != nil) {
        SebesMapService * mservice = [self.basemaps objectAtIndex:indexPath.row];
        //NSString *color = [_colors objectAtIndex:indexPath.row];
        [_delegate basemapSelected:mservice ];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    self.basemaps = nil;
}

@end
