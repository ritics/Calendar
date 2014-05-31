//
//  BNMhelperWords.m
//  BNCalView
//
//  Created by Reinis Lācis on 23/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import "BNMhelperWords.h"
#import "BNMWordCountItem.h"


@implementation BNMhelperWords



/**
* Saskaita cik reizes vārdi atkārtojas
* Sakārto pēc biežuma un alfabētiskā secībā
*/
+(NSArray *)countWords:(NSMutableDictionary *)notesDic
{
    
    if (notesDic == nil) {return nil;}
    
    NSMutableDictionary *noteWordCountDic = [[NSMutableDictionary alloc]init];
  
    /*
    // vārdu atdalītāji, ja lieto split
    //NSString *splitChars = @" ~'!@£$\%^&*\\()_-=+\\{}[]\n\r\t";
     NSArray *myWords = [dateWithNote.note componentsSeparatedByCharactersInSet:
    [NSCharacterSet characterSetWithCharactersInString:splitChars]];
    */
    
    
    for(id key in notesDic) {

        BNMDateNoteItem *dateWithNote = (BNMDateNoteItem *)[notesDic objectForKey:key];
        NSMutableArray *regexWords = [[NSMutableArray alloc] init];
        
        // ja ir tukša piezīme, tad izlaiž
        if (dateWithNote.note == nil) {continue;}
        
        // regex versija, sadala tekstu vārdos
        NSString *yourString = dateWithNote.note;
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"(\\w+)"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        
        [regex enumerateMatchesInString:yourString
                                options:0
                                  range:NSMakeRange(0, [yourString length])
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
            {
                // your code to handle matches here
                NSRange accessTokenRange = [match rangeAtIndex:1];
                NSString *value = [yourString substringWithRange:accessTokenRange];
                NSLog(@"Value: %@", value);
                [regexWords addObject:value];
            }
        ];
        
        
        
        NSString *word;
        for(word in regexWords) {
            // izmantojot regex sekojošās tukšo vārdu pārbaudes vairs nav vajadzīgas
            // notrimo ja tukšs vārds
            NSString *lword = [[word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]lowercaseString];
        
            if (lword == nil || [lword isEqualToString:@""]) {
                // tukšos vārdus izlaiž
            }
            else if ([noteWordCountDic objectForKey:lword] == nil) {
                // vārds nav atrasts, pievieno
                [noteWordCountDic setObject:[NSNumber numberWithInteger:1] forKey:lword];
            }
            else {
                // vārds ir atrasts, palielina skaitu
                NSInteger count = [[noteWordCountDic objectForKey:lword] integerValue] + 1;
                [noteWordCountDic setObject:[NSNumber numberWithInteger:count] forKey:lword];
            }
        }
    }
    
    // izveido objektu masīvu kārtošanai
    NSMutableArray *WordCount =[[NSMutableArray alloc] init];
    for(id key in noteWordCountDic) {
        [WordCount addObject:[[BNMWordCountItem alloc]
                                        init:key
                                       count:[[noteWordCountDic objectForKey:key] integerValue]]];
        NSLog(@"%@ - %ld", key, (long)[[noteWordCountDic objectForKey:key] integerValue]);
    }
    
    // masīva kārtošanas secība
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,sortDescriptor2,nil];
    // sakārto masīvu
    NSArray *sortedWordCount = [WordCount sortedArrayUsingDescriptors:sortDescriptors];
    
    NSLog(@"sortedWordCount");
    for(BNMWordCountItem *wordCountItem in sortedWordCount) {
        NSLog(@"%@ - %ld", wordCountItem.word, (long)wordCountItem.count);
    }

    return sortedWordCount;
}


@end
