//
//  BNMMyCollectionViewCell.h
//  BNCalView
//
//  Created by Reinis Lācis on 17/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNMDateNoteItem.h"

@interface BNMMyCollectionViewCell : UICollectionViewCell


// vienas rūtiņas saturs
@property (strong, nonatomic) IBOutlet UILabel *labelView;
@property (strong, nonatomic) BNMDateNoteItem *noteForDate;
@property (strong, nonatomic) NSDate *date;



@end
