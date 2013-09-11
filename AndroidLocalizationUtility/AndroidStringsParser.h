//
//  AndroidStringsParser.h
//  AndroidLocalizationUtility
//
//  Created by Kostia Dombrovsky on 9/11/13.
//  Copyright 2009-2013 Kostia Dombrovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndroidStringsParser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser*         _parser;
    NSString*            _key;
    NSMutableString*     _tagValue;

    NSMutableArray*      _mutableKeys;
    NSMutableDictionary* _mutableStrings;
}

@property (nonatomic, strong, readonly) NSArray*      keys;
@property (nonatomic, strong, readonly) NSDictionary* strings;

- (NSError*) parse: (NSString*) path;

@end