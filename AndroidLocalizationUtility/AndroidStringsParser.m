//
//  AndroidStringsParser.m
//  AndroidLocalizationUtility
//
//  Created by Kostia Dombrovsky on 9/11/13.
//  Copyright 2009-2013 Kostia Dombrovsky. All rights reserved.
//

#import "AndroidStringsParser.h"

@interface AndroidStringsParser ()
@end

@implementation AndroidStringsParser

- (NSError*) parse: (NSString*) path
{
    NSData* data = [NSData dataWithContentsOfFile: path];
    _parser = [[NSXMLParser alloc] initWithData: data];
    _parser.delegate = self;
    [_parser parse];

    _keys    = [NSArray arrayWithArray: _mutableKeys];
    _strings = [NSDictionary dictionaryWithDictionary: _mutableStrings];
    return nil;
}

- (id) result
{
    return nil;
}

#pragma mark NSXMLParserDelegate

- (void) parser: (NSXMLParser*) parser
didStartElement: (NSString*) elementName
   namespaceURI: (NSString*) namespaceURI
  qualifiedName: (NSString*) qualifiedName
     attributes: (NSDictionary*) attributeDict
{
    if ([elementName isEqualToString: @"resources"])
    {
        _mutableStrings = [NSMutableDictionary new];
        _mutableKeys    = [NSMutableArray new];
    }
    else if ([elementName isEqualToString: @"string"])
        _key = attributeDict[@"name"];

    _tagValue = nil;
}

- (void) parser: (NSXMLParser*) parser foundCharacters: (NSString*) string
{
    if (_tagValue)
        [_tagValue appendString: string];
    else
        _tagValue = [NSMutableString stringWithString: string];
}

- (void) parser: (NSXMLParser*) parser
  didEndElement: (NSString*) elementName
   namespaceURI: (NSString*) namespaceURI
  qualifiedName: (NSString*) qName
{
    if ([elementName isEqualToString: @"string"])
    {
        [_mutableKeys addObject: _key];
        _mutableStrings[_key] = _tagValue;
    }

    _tagValue = nil;
}

@end