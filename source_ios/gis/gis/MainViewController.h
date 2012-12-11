//
//  MainViewController.h
//  gis
//
//  Created by mishanet on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginOperation.h"
#import "SebesOperation.h"
#import "ConfigXmlOperation.h"
#import "ProjectOperation.h"
#import <ArcGIS/ArcGIS.h>
#import "BasemapController.h"
#import "ApplicationController.h"
#import "WEPopoverController.h"

@class WEPopoverController;

//contants for data layers
#define kTiledMapServiceURL @"http://sebesgis.sebes.lu/ArcGIS/rest/services/Carto2011/MapServer"
#define kDynamicMapServiceURL @"http://sebesgis.sebes.lu/ArcGIS/rest/services/SEBES/SEBESedit/MapServer"

//Set up constant for predefined where clause for search
#define kLayerDefinitionFormat @"STATE_NAME = '%@'"

@interface MainViewController  : UIViewController <SebesOperationDelegate,ConfigXmlOperationDelegate,ProjectOperationDelegate,AGSMapViewLayerDelegate,WEPopoverControllerDelegate, UIPopoverControllerDelegate,BasemapDelegate,ApplicationDelegate> {
    //container for map layers
	AGSMapView *_mapView;
	
	//this map has a dynamic layer, need a view to act as a container for it
	AGSDynamicMapServiceLayer *_dynamicLayer;
    AGSGraphicsLayer* myGraphicsLayer;
    
	UIView *_dynamicLayerView;
    
    WEPopoverController *popoverController;
    WEPopoverController *popoverAppController;
    
    BOOL _isGps;
}

@property (nonatomic, retain) LoginOperation *loginOperation;
@property (nonatomic, retain) SebesOperation *sebesOperation;
@property (nonatomic, retain) ProjectOperation *projectOperation;
@property (nonatomic, retain) ConfigXmlOperation *configXmlOperation;


@property (nonatomic, retain) IBOutlet AGSMapView *mapView;
@property (nonatomic, assign) AGSDynamicMapServiceLayer *dynamicLayer;
@property (nonatomic, assign) AGSGraphicsLayer* myGraphicsLayer;
@property (nonatomic, assign) UIView *dynamicLayerView;
@property (retain, nonatomic) IBOutlet UIToolbar *tools;

// In property section
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic, retain) WEPopoverController *popoverAppController;

- (IBAction)exit:(id)sender;
- (IBAction)onButtonClick:(UIButton *)button;
- (IBAction)onAppButtonClick:(UIButton *)button;
- (IBAction)onGpsButtonClick:(UIButton *)button;

- (void)initMap;

@end
