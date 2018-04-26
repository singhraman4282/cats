//
//  PhotoObject.h
//  flicker
//
//  Created by Raman Singh on 2018-04-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PhotoObject : NSObject
@property (nonatomic) NSString *photoID;
@property (nonatomic) NSString *owner;
@property (nonatomic) NSString *secret;
@property (nonatomic) NSString *server;
@property (nonatomic) int farm;
@property (nonatomic) NSString *title;
@property (nonatomic) int ispublic;
@property (nonatomic) int isfriend;
@property (nonatomic) int isfamily;
@property (nonatomic) NSString *photoURL;
@property (nonatomic) UIImage *image;
-(NSString *)makeURL;

@end
