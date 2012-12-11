//
//  MainViewController.m
//  gis
//
//  Created by mishanet on 07/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SebesApplication.h"
#import "GetConfigXml.h"
#import "SebesMapService.h"
#import "WEPopoverController.h"
#import "BasemapController.h"
#import "ApplicationController.h"
#import "HttpProjectOperation.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tools = _tools;

@synthesize mapView = _mapView;
@synthesize dynamicLayer = _dynamicLayer, dynamicLayerView = _dynamicLayerView, myGraphicsLayer=_myGraphicsLayer;
@synthesize popoverController;
@synthesize popoverAppController;

@synthesize loginOperation=_loginOperation;
@synthesize sebesOperation=_sebesOperation;
- (void) setSebesOperation:(SebesOperation *)sebesOperation
{
    [sebesOperation retain];
    [_sebesOperation release];
    _sebesOperation = sebesOperation;
    
    if (_sebesOperation)
        _sebesOperation.delegate = self;
}

@synthesize configXmlOperation=_configXmlOperation;
- (void) setConfigXmlOperation:(ConfigXmlOperation *)configXmlOperation
{
    [configXmlOperation retain];
    [_configXmlOperation release];
    _configXmlOperation = configXmlOperation;
    
    if (_configXmlOperation)
        _configXmlOperation.delegate = self;
}

@synthesize projectOperation=_projectOperation;
- (void) setProjectOperation:(ProjectOperation *)projectOperation
{
    [projectOperation retain];
    [_projectOperation release];
    _projectOperation = projectOperation;
    
    if (_projectOperation)
        _projectOperation.delegate = self;
}

- (IBAction)exit:(id)sender 
{
    // Close down the app.
    exit(0);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _isGps = NO;
    
    self.projectOperation = [[[HttpProjectOperation alloc]init] autorelease];
    
    [self registerAsObserver];
    //self.myGraphicsLayer = [[AGSGraphicsLayer alloc]init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.mapView = nil;
	self.dynamicLayer = nil;
	self.dynamicLayerView = nil;
    [_tools release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) initMap
{
    NSLog(@"Token'%@'", 
          self.loginOperation.authenticatedToken);
    if (!self.sebesOperation)
        return;
    [self.sebesOperation beginApplicationInfo:self.loginOperation.authenticatedToken];
   
}

#pragma mark - SebesOperationDelegate members
-(void)projectOperationCompleted:(ProjectOperation *)projectOperation 
                      withResult:(BOOL)successfulRequest 
                    errorMessage:(NSString *)errorMessage;
{
    if (successfulRequest)
    {
        AGSSimpleMarkerSymbol* myMarkerSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbol];
        myMarkerSymbol.color = [UIColor blueColor];
        myMarkerSymbol.style = AGSSimpleMarkerSymbolStyleDiamond;
        myMarkerSymbol.outline.color = [UIColor whiteColor];
        myMarkerSymbol.outline.width = 3;
        
         
        
        AGSGraphic* myGraphic =
        [AGSGraphic graphicWithGeometry:[self.projectOperation point]
                                 symbol:myMarkerSymbol
                             attributes:nil
                   infoTemplateDelegate:nil];
        
        id<AGSLayerView> myGraphicsLayerView = [self.mapView.mapLayerViews objectForKey:@"Graphics Layer"];
        AGSGraphicsLayer* graphicsLayer =
        (AGSGraphicsLayer*)myGraphicsLayerView.agsLayer;
        
        [graphicsLayer addGraphic:myGraphic];
        
        //Tell the layer to redraw itself
        [graphicsLayer dataChanged];
    }
    else
    {
        NSLog(@"Get Application Error'%@'", 
              errorMessage);
    }
}

- (void)sebesOperationCompleted:(SebesOperation *)sebesOperation 
                     withResult:(BOOL)successfulRequest 
                   errorMessage:(NSString *)errorMessage
{
    if (successfulRequest)
    {
        NSLog(@"DefaultGroupe'%@'",self.sebesOperation.defaultGroupe);
        SebesApplication *app = [self.sebesOperation getApplicationByName:self.sebesOperation.defaultGroupe];
        NSLog(@"FileName:'%@'",app.fileName);

        [self.configXmlOperation beginConfigXmlInfo:self.loginOperation.authenticatedToken 
                                              fileName:app.fileName];
    }
    else
    {
        NSLog(@"Get Application Error'%@'", 
              errorMessage);
    }
}

-(void) configXmlOperationCompleted:(ConfigXmlOperation *)configXmlOperation withResult:(BOOL)successfulRequest errorMessage:(NSString *)errorMessage
{
    if (successfulRequest)
    {
        for (SebesMapService * mservice in [(GetConfigXml*)self.configXmlOperation basemaps]) { 
            NSLog(@"'%@'",mservice.url);
            
            if([mservice.visible isEqualToString:@"true"])
            { 
                //create an instance of a tiled map service layer
                AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:mservice.url]];
            
                //Add it to the map view
                UIView<AGSLayerView>* lyr = [self.mapView addMapLayer:tiledLayer withName:@"basemap"];
            
                //release to avoid memory leaks
                [tiledLayer release];
            
                // Setting these two properties lets the map draw while still performing a zoom/pan
                lyr.drawDuringPanning = YES;
                lyr.drawDuringZooming = YES;
            }
        }
        
        for (SebesMapService * mservice in [(GetConfigXml*)self.configXmlOperation livemaps]) { 
            NSLog(@"'%@'",mservice.url);
            
            if([mservice.visible isEqualToString:@"true"])
            { 
                AGSDynamicMapServiceLayer *mdynamicLayer = [[[AGSDynamicMapServiceLayer alloc] initWithURL:[NSURL URLWithString:mservice.url]] autorelease];
                UIView<AGSLayerView>* lyr = [self.mapView addMapLayer:mdynamicLayer withName:mservice.label];
                lyr.alpha = 1;
            }
        }

       // [self.mapView addMapLayer:self.myGraphicsLayer withName:@"Graphics Layer"];
        AGSGraphicsLayer* graphicsLayer = [AGSGraphicsLayer graphicsLayer];
        [self.mapView addMapLayer:graphicsLayer withName:@"Graphics Layer"];
        
        AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:2169];
        double xmin, ymin, xmax, ymax;
        xmin = 50657.6840015322;
        ymin = 69117.2494221258;
        xmax = 101863.715501742;
        ymax = 108270.044439664;

        // zoom to the United States
        AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:sr];
        [self.mapView zoomToEnvelope:env animated:YES];
        
    }
    else
    {
        NSLog(@"Get Application Error'%@'", 
              errorMessage);
    }
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// set the delegate for the map view
	self.mapView.layerDelegate = self;
    [self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
}

- (void)viewDidUnload
{
    [self setTools:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)onAppButtonClick:(UIButton *)button {
    if (self.popoverAppController) {
		[self.popoverAppController dismissPopoverAnimated:YES];
		self.popoverAppController = nil;
		[button setTitle:@"App" forState:UIControlStateNormal];
	} else {
        
        ApplicationController *bc = [[ApplicationController alloc] initWithStyle:UITableViewStylePlain];
        bc.groupes = [self.sebesOperation groupes];
        bc.delegate = self;
		UIViewController *contentViewController = bc;
		
        
		self.popoverAppController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        self.popoverAppController.delegate = self;
		[self.popoverAppController presentPopoverFromRect:self.tools.frame 
												inView:self.view 
							  permittedArrowDirections:UIPopoverArrowDirectionDown
											  animated:YES];
		[contentViewController release];
		[button setTitle:@"App" forState:UIControlStateNormal];
	}
}

- (IBAction)onButtonClick:(UIButton *)button {
    
    if (self.popoverController) {
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
		[button setTitle:@"Basemap" forState:UIControlStateNormal];
	} else {
        
        BasemapController *bc = [[BasemapController alloc] initWithStyle:UITableViewStylePlain];
        bc.basemaps = [(GetConfigXml*)self.configXmlOperation basemaps];
        bc.delegate = self;
		UIViewController *contentViewController = bc;//;[[BasemapController alloc] initWithStyle:UITableViewStylePlain];
		
        
		self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        self.popoverController.delegate = self;
		[self.popoverController presentPopoverFromRect:self.tools.frame 
												inView:self.view 
							  permittedArrowDirections:UIPopoverArrowDirectionDown
											  animated:YES];
		[contentViewController release];
		[button setTitle:@"Basemap" forState:UIControlStateNormal];
	}
}



- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

- (void)basemapSelected:(SebesMapService *)mapService {
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    
    //create an instance of a tiled map service layer
    AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:mapService.url]];
    
    [self.mapView removeMapLayerWithName:@"basemap"];
    
    //Add it to the map vie
    UIView<AGSLayerView>* lyr = [self.mapView insertMapLayer:tiledLayer withName:@"basemap" atIndex:0];
    
    //release to avoid memory leaks
    [tiledLayer release];
    
    // Setting these two properties lets the map draw while still performing a zoom/pan
    lyr.drawDuringPanning = YES;
    lyr.drawDuringZooming = YES;
}

- (void)applicationSelected:(SebesApplication *)app {
    [self.popoverAppController dismissPopoverAnimated:YES];
    self.popoverAppController = nil;
    
    NSArray * mapLayers  = [self.mapView mapLayers];
    NSMutableArray * layersName =  [[NSMutableArray alloc] initWithCapacity:[mapLayers count]]; 
    int i;
    for(i=0;i<[mapLayers count];i++){ 
        AGSLayer * layer= [mapLayers objectAtIndex:i];
        NSString* layerName = layer.name;
        [layersName addObject:layerName];
    }
    
    for(NSString * layerName in layersName) {
        [self.mapView removeMapLayerWithName:layerName];
    }
    
    [(GetConfigXml*)self.configXmlOperation setBasemaps:[[NSMutableArray alloc] init]];
    [(GetConfigXml*)self.configXmlOperation setLivemaps:[[NSMutableArray alloc] init]];
    
    [self.configXmlOperation beginConfigXmlInfo:self.loginOperation.authenticatedToken 
                                       fileName:app.fileName];
}

- (void)registerAsObserver {
    [ self.mapView.gps addObserver:self
                        forKeyPath:@"currentPoint"
                           options:(NSKeyValueObservingOptionNew)
                           context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"currentPoint"]) {
        NSLog(@"Location updated to %@", self.mapView.gps.currentPoint);
        //[self.projectOperation beginProjectInfo:self.loginOperation.authenticatedToken x:self.mapView.gps.currentPoint.x y:self.mapView.gps.currentPoint.y];
    }
}

- (IBAction)onGpsButtonClick:(UIButton *)button {
    if(_isGps)
    {
        [self.mapView.gps stop];
        _isGps = NO;
    }
    else {
        [self.mapView.gps start];
        _isGps = YES;
    }
    
}


@end
