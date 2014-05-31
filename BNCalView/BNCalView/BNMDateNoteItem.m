//
//  BNMToDoItem.m
//  ToDoList
//
//  Created by Reinis Lācis on 13/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import "BNMDateNoteItem.h"

@implementation BNMDateNoteItem





/**
 *  Konstruktors
 *
 *  @param note <#note description#>
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithNote:(NSString *)note date:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.note = note;
        self.date = date;
        
        //Optionally for time zone converstions
        //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        //NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
        // create a unique identifier for this object, helps with state restoration
        // NSUUID *uuid = [[NSUUID alloc] init];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        self.identifier = [formatter stringFromDate:date];
        
    }
    return self;
}



/**
 *  Description
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.note = nil;
        self.date = date;
        
        //Optionally for time zone converstions
        // [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        // NSString *stringFromDate = [formatter stringFromDate:myNSDateInstance];
        //create a unique identifier for this object, helps with state restoration
        // NSUUID *uuid = [[NSUUID alloc] init];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        self.identifier = [formatter stringFromDate:date];
        
    }
    return self;
}



#pragma mark - Object serialization

/**
 *  serializācijas atribūti
 *
 *  @return - masīvs ar atribūtu vārdiem
 */
- (NSArray *)keysForEncoding;
{
    return [NSArray arrayWithObjects:@"identifier",@"date",@"note",nil];
}



/**
 *  Deserializācija
 *  we are being created based on what was archived earlier
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        for (NSString *key in self.keysForEncoding) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}



/**
 *  serializācija
 *  we are asked to be archived, encode all our data
 *
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	for (NSString *key in self.keysForEncoding) {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}



@end
