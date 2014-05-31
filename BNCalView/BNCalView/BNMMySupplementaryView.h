//
//  BNMMySupplementaryView.h
//  BNCalView
//
//  Created by Reinis Lācis on 18/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNMMySupplementaryView : UICollectionReusableView

// labelis kurā hederī rāda mēnesi
// lai strādātu outlet storyboard garfiskajai kontrolei ir jāuzstāda
// pareizā klase, šajā gadījumā hederis ir ar tipu BNMMySupplementaryView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextM;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevM;


@end
