//
//  main.m
//  InstrumentsParser
//
//  Created by pantengfei on 14-7-29.
//  Copyright (c) 2014年 ___bidu___. All rights reserved.
//

#import "XRRun.h"
#import "InstrumentsParserApp.h"

#define targetProcess @"Recipes"

@implementation XRRun

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        startTime = [[decoder decodeObject] doubleValue];
        endTime   = [[decoder decodeObject] doubleValue];
        runNumber = [[decoder decodeObject] unsignedIntegerValue];

        trackSegments = [decoder decodeObject];

        // Totally not sure about these
        envVals = [[decoder decodeObject] boolValue];
        execname = [[decoder decodeObject] boolValue];
        terminateTaskAtStop = [[decoder decodeObject] boolValue];
        pid = [decoder decodeObject][@"_pid"];
        launchControlProperties = [[decoder decodeObject] boolValue];
        args = [[decoder decodeObject] boolValue];

        InstrumentsParserApp *shareAppData = [InstrumentsParserApp getInstance];
        NSString *xcodeVersion = [shareAppData xcodeVersion];

        //if xcode version is given
        if (xcodeVersion == nil || [xcodeVersion  isEqual: @""]) {
            
            //run xcodebuild -version to get the current machine xcode version
            NSTask *task = [[NSTask alloc] init];
            NSPipe *out = [NSPipe pipe];
            NSFileHandle *file = out.fileHandleForReading;

            [task setLaunchPath:@"/usr/bin/xcodebuild"];

            NSArray *arguments;
            NSString* newpath = [NSString stringWithFormat:@"-version"];
            NSLog(@"shell script path: %@", newpath);
            arguments = [NSArray arrayWithObjects:newpath, nil];
            [task setArguments: arguments];
            [task setStandardOutput: out];

            //execute the xcode commandline script
            [task launch];
            [task waitUntilExit];

            NSData *data = [file readDataToEndOfFile];
            [file closeFile];

            //manipulate the output string
            NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

            if (output == nil) {
                printf("xcodebuild -version command can't be execute.\n");
                exit(1);
            }

            NSString *versionString = [output componentsSeparatedByString:@"\n"][0];
            xcodeVersion = [versionString stringByReplacingOccurrencesOfString: @"Xcode " withString:@""];
            NSLog (@"Xcode version : %@", xcodeVersion);
        }


        //if xcode version is 6.4 or 6.3
        if ([xcodeVersion  hasPrefix: @"6.4"] || [xcodeVersion hasPrefix:@"6.3"]) {
            [decoder decodeObject];
            [decoder decodeObject];
        } else if ([xcodeVersion hasPrefix:@"7"]) { //if the xcode version is in 7
            [decoder decodeObject];
            [decoder decodeObject];
            [decoder decodeObject]; //patch for XCode 7
        } //else no => [decoder decodeObject];

    }
    return self;
}

- (void)dealloc
{
}


@end