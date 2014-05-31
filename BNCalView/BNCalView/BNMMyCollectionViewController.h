//
//  BNMMyCollectionViewController.h
//  BNCalView
//
//  Created by Reinis Lācis on 17/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNMMyCollectionViewCell.h"
#import "BNMMySupplementaryView.h"


@interface BNMMyCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

// masīvs kurā ir kalendārā rādāmie datumi
@property (strong, nonatomic) NSMutableArray *datesInView;
// dictionary ar rādāmajiem datumiem
@property (strong, nonatomic) NSMutableDictionary *datesInViewDic;
// dictionary ar datumiem kuriem ir pievienotas piezīmes
@property (strong, nonatomic) NSMutableDictionary *datesWithNotesDic;
// vārdu skaits piezīmēs
@property (strong, nonatomic) NSMutableDictionary *noteWordCountDic;

@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *myLayout;


// nepieciešama navigācijai starp skatiem
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;


@end
