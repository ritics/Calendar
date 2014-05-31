//
//  BNMToDoItem.h
//  ToDoList
//
//  Created by Reinis Lācis on 13/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMDateNoteItem : NSObject


// varētu būt datums formā YYYYMMDD
/**
 *  Piezīmes unikāls identifikators
 *  datums formātā YYYYMMDD
 */
@property (nonatomic, strong) NSString *identifier;


/**
 *  Datumam pievienotās piezīmes teksts
 */
@property (nonatomic, strong) NSString *note;


/**
 *  <#Description#>
 */
@property (nonatomic, strong) NSDate *date;



/**
 *  <#Description#>
 *
 *  @param note         <#note description#>
 *  @param creationDate <#creationDate description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithNote:(NSString *)note date:(NSDate *)date;
- (id)initWithDate:(NSDate *)date;

@end
