//
//  BNMWordCountItem.m
//  BNCalView
//
//  Created by Reinis Lācis on 23/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import "BNMWordCountItem.h"

@implementation BNMWordCountItem

-(id)init:(NSString *)word count:(NSInteger)count {
    self = [super init];
    if (self)
    {
        self.word = word;
        self.count = count;
    }
    return self;
}

@end
