//
//  BNMWordCountItem.h
//  BNCalView
//
//  Created by Reinis Lācis on 23/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMWordCountItem : NSObject

@property (nonatomic,strong) NSString * word;
@property (nonatomic) NSInteger count;


- (id)init:(NSString *)word count:(NSInteger)count;

@end
