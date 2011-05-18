//
//  Blocks.h
//  tvclient
//
//  Created by Sean Hess on 4/1/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//


// Blocks.h contains typedefs for various kinds of blocks

//return - name- parameter

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Block)();
typedef void(^StringBlock)(NSString *);
typedef void(^ArrayBlock)(NSArray *);
typedef void(^NumberBlock)(NSNumber *);
typedef void(^DictionaryBlock)(NSDictionary *);
typedef void(^ImageBlock)(UIImage *);
typedef void(^OrderedImageBlock)(int order, UIImage *);
