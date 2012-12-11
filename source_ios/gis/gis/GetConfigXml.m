//
//  GetConfigXml.m
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetConfigXml.h"
#import "ASIFormDataRequest.h"
#import "GlobalWebservice.h"
#import "JSON.h"
#import "Constants.h"
#import "SebesMapService.h"

@implementation GetConfigXml


- (void) setBasemaps:(NSMutableArray *)basemaps
{
    _basemaps = basemaps;
}

- (NSMutableArray *) basemaps
{
    return _basemaps;
}

- (void) setLivemaps:(NSMutableArray *)livemaps
{
    _livemaps = livemaps;
}

- (NSMutableArray *) livemaps
{
    return _livemaps;
}


- (BOOL)getConfigXmlImpl:(NSString **)errorMessage
{
    NSString *query = [@"" stringByAppendingFormat:@"http://sebesgis.sebes.lu/sebes/UserService/UserService.svc/user/UserXmlFile?_token=%@&_file=%@",_token,_fileName];
    *errorMessage = nil;
    
    //
    // WARNING: A production authentication service should never pass user credentials as URL query parameters over HTTP!
    //
    
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                         timeoutInterval:30];
    
    NSURLResponse *responseMetadata;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                         returningResponse:&responseMetadata 
                                                     error:&error];
    
    BOOL result = NO;
    if (data)
    {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        
        // Prepare the objects used to extract an error message returned from the server.
        _errorMessageBuilder = [[NSMutableString alloc] init];

        // Read the XML data returned from the authenticate service.
        [parser parse];
        
        // If there is no error message, the login was a success.
        result = [_errorMessageBuilder length] == 0;
        if (!result) 
        {
            *errorMessage = [NSString stringWithString:_errorMessageBuilder];
        }
        [_errorMessageBuilder release];
        _errorMessageBuilder = nil;
        
        
        
        
        [parser release];
        
        NSLog(@"================================");
        NSLog(@"================================");
        for (SebesMapService * mservice in [self basemaps]) { 
            NSLog(@"url '%@' label '%@'",mservice.url,mservice.label);
        }
        NSLog(@"================================");
        NSLog(@"================================");
        for (SebesMapService * mservice in [self livemaps]) { 
            NSLog(@"url '%@' label '%@'",mservice.url,mservice.label);
        }
    }
    else 
    {
        *errorMessage = [error localizedDescription];
    }
    
    return result;

}

#pragma mark - NSXMLParserDelegate members

- (void)    parser:(NSXMLParser *)parser 
   didStartElement:(NSString *)elementName 
      namespaceURI:(NSString *)namespaceURI 
     qualifiedName:(NSString *)qName 
        attributes:(NSDictionary *)attributeDict
{
    NSLog(@"ElementName'%@'",elementName);
    
    if([elementName isEqualToString:@"basemaps"])
    {
        _isBasemaps = YES;
    }
    if([elementName isEqualToString:@"livemaps"])
    {
        _isLivemaps = YES;
    }
    if([elementName isEqualToString:@"mapservice"])
    {
        
            
        NSString *labelString = (NSString *)[attributeDict objectForKey:@"label"];
        NSString *typeString = (NSString *)[attributeDict objectForKey:@"type"];
        NSString *alphaString = (NSString *)[attributeDict objectForKey:@"alpha"];
        NSString *visibleString = (NSString *)[attributeDict objectForKey:@"visible"];
        SebesMapService *mapService = [[SebesMapService alloc] init];
        [mapService setLabel:labelString];
        [mapService setType:typeString];
        [mapService setAlpha:alphaString];
        [mapService setVisible:visibleString];
        
        if(_isBasemaps)
        { 
            if(![self basemaps])
                [self setBasemaps:[[NSMutableArray alloc] init]];
        
            [[self basemaps] addObject:mapService];
        }
        
        if(_isLivemaps)
        { 
            if(![self livemaps])
                [self setLivemaps:[[NSMutableArray alloc] init]];
            
            [[self livemaps] addObject:mapService];
        }
    }
}

- (void)    parser:(NSXMLParser *)parser 
   foundCharacters:(NSString *)string
{
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] init];
    }
    [currentStringValue appendString:string];
}

- (void)    parser:(NSXMLParser *)parser 
     didEndElement:(NSString *)elementName 
      namespaceURI:(NSString *)namespaceURI 
     qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"mapservice"])
    {
        NSString *valueString = [NSString stringWithString:currentStringValue];
        NSString *urlString =[valueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(_isBasemaps)
        { 
            SebesMapService *mapService = [[self basemaps] lastObject];
            [mapService setUrl:urlString];
        }
        
        
        if(_isLivemaps)
        { 
            SebesMapService *mapService = [[self livemaps] lastObject];
            [mapService setUrl:urlString];
        }
        
    }
    
    if([elementName isEqualToString:@"basemaps"])
    {
        _isBasemaps = NO;
    }
    if([elementName isEqualToString:@"livemaps"])
    {
        _isLivemaps = NO;
    }

    [currentStringValue release];
    currentStringValue = nil;
    
}

@end
