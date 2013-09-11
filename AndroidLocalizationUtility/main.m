//
//  main.m
//  AndroidLocalizationUtility
//
//  Created by Kostia Dombrovsky on 9/11/13.
//  Copyright (c) 2013 Kostia Dombrovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AndroidStringsParser.h"

NSString* TranslationsPath()
{
    return [NSString stringWithFormat: @"/Users/%@/Desktop/strings_to_translate", NSUserName()];
}

void removePreviousTranslationFolder()
{
    [NSFileManager.defaultManager removeItemAtPath: TranslationsPath() error: nil];
}

int main(int argc, const char* argv[])
{
    @autoreleasepool
    {
        removePreviousTranslationFolder();

        NSString* projectDirectory   = @"/Users/kdombrovsky/Documents/My Projects/mpc-remote-android/mpc-remote";
        NSString* resourcesDirectory = [projectDirectory stringByAppendingPathComponent: @"res"];

        //Parse default strings
        AndroidStringsParser* parser = [AndroidStringsParser new];
        [parser parse: [resourcesDirectory stringByAppendingPathComponent: @"values/strings.xml"]];

        NSDictionary* defaultStrings = parser.strings;
        NSArray*      defaultKeys    = parser.keys;

        //Look for other strings.xml files
        NSFileManager* fileManager = [NSFileManager defaultManager];
        for (NSString* path in [fileManager contentsOfDirectoryAtPath: resourcesDirectory error: nil])
        {
            if ([path isEqualToString: @"values"] || [path rangeOfString: @"values"].location == NSNotFound)
                continue;

            NSString* fullPath = [resourcesDirectory stringByAppendingPathComponent: path];
            for (NSString* fileName in [fileManager contentsOfDirectoryAtPath: fullPath error: nil])
            {
                if ([fileName isEqualToString: @"strings.xml"])
                {
                    AndroidStringsParser* translationsParser = [AndroidStringsParser new];
                    [translationsParser parse: [fullPath stringByAppendingPathComponent: fileName]];

                    NSMutableString* fileToTranslate = [NSMutableString new];
                    for (NSString* key in defaultKeys)
                    {
                        NSString* string = [translationsParser.strings objectForKey: key];
                        if (string.length)
                            continue;

                        [fileToTranslate appendFormat: @"    <!-- %@ -->\n", [defaultStrings objectForKey: key]];
                        [fileToTranslate appendFormat: @"    <string name=\"%@\"></string>\n\n", key];
                    }



                    if (fileToTranslate.length)
                    {
                        [fileToTranslate insertString: @"<resources>\n" atIndex: 0];
                        [fileToTranslate insertString: @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>\n" atIndex: 0];
                        [fileToTranslate appendString: @"</resources>"];


                        NSString* outputPath = [TranslationsPath() stringByAppendingPathComponent: path];
                        [fileManager createDirectoryAtPath: outputPath
                               withIntermediateDirectories: YES
                                                attributes: nil
                                                     error: nil];

                        [fileToTranslate writeToFile: [outputPath stringByAppendingPathComponent: fileName]
                                          atomically: YES
                                            encoding: NSUTF8StringEncoding
                                               error: nil];
                    }


//                    NSLog(@"%@", fileToTranslate);
                }
            }
        }
    }
    return 0;
}

