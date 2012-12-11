//
//  GetConfigXml.h
//  gis
//
//  Created by mishanet on 08/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigXmlOperation.h"

@interface GetConfigXml : ConfigXmlOperation<NSXMLParserDelegate> {
    BOOL _buildErrorMessage;
    BOOL _isBasemaps;
    BOOL _isLivemaps;
    NSMutableString *_errorMessageBuilder;
    NSMutableString * currentStringValue;
    NSMutableArray *_basemaps;
    NSMutableArray *_livemaps;
}

- (void) setBasemaps:(NSMutableArray *)basemaps;
- (NSMutableArray *) basemaps;
- (void) setLivemaps:(NSMutableArray *)livemaps;
- (NSMutableArray *) livemaps;


@end
