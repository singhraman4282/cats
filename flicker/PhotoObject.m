//
//  PhotoObject.m
//  flicker
//
//  Created by Raman Singh on 2018-04-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

#import "PhotoObject.h"

@implementation PhotoObject
-(NSString *)makeURL {
    NSString *url = [NSMutableString new];
    url = [NSString stringWithFormat:@"https://farm%d.staticflickr.com/%@/%@_%@_m.jpg",self.farm, self.server, self.photoID, self.secret];
    
    //https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
    self.photoURL = url;
    return url;
}
@end
