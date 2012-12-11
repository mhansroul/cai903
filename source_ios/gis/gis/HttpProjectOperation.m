//
//  HttpProjectOperation.m
//  gis
//
//  Created by mishanet on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpProjectOperation.h"
#import "ASIFormDataRequest.h"
#import "GlobalWebservice.h"
#import "JSON.h"
#import "Constants.h"
#import <ArcGIS/ArcGIS.h>

@implementation HttpProjectOperation
- (BOOL)getProjectImpl:(NSString **)errorMessage
{
    NSString* xString = [NSString stringWithFormat:@"%f",self.inputX];
    NSString* yString = [NSString stringWithFormat:@"%f",self.inputY];
    
    NSString* urlProject = [@"" stringByAppendingFormat:@"http://sebesgis.sebes.lu/sebes/CartoService/CartoService.svc/carto/ProjectPoint?x=%@&y=%@",xString,yString];
    NSLog(urlProject);
    //NSString *urlLogin = [@"" stringByAppendingFormat:@"http://sebesgis.sebes.lu/sebesdev/TokenService/TokenService.svc/user/Login?username=%@&password=%@", _username,_password];

    NSURL *url = [NSURL URLWithString:urlProject];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
   
    
    NSError *httpError = [request error];
    
    
    BOOL result = NO;
    
    if (!httpError) {
        NSString *receivedString = [request responseString];
        NSDictionary *dict = [receivedString JSONValue];
        
        NSDictionary *projectResult = [dict objectForKey:@"ProjectPointResult"];
        
        NSString * status = (NSString *)[projectResult objectForKey:@"status"];
        NSDecimalNumber * numberX = (NSDecimalNumber *)[projectResult objectForKey:@"x"];
        NSDecimalNumber * numberY = (NSDecimalNumber *)[projectResult objectForKey:@"y"];
        double x = [numberX doubleValue];
        double y = [numberY doubleValue];
        
        //NSString *sx = [NSString stringWithFormat:@"%f",x];
        //NSString *sy = [NSString stringWithFormat:@"%f",y];
        //NSLog(status);
        //NSLog(sy);
        self.point = [AGSPoint pointWithX:x y:y spatialReference:[AGSSpatialReference spatialReferenceWithWKID:2169 WKT:nil]];
       
        //AGSPoint* locationPoint =[AGSPoint pointWithX:x y:y spatialReference:self.mapView.spatialReference];
        
        result = YES;
    }
    else
        *errorMessage = @"HTTP Error";
    
    //[request release];
    
    return result;
}
@end
