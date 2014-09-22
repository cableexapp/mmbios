//
//  MCdes.h
//  des
//
//  Created by duomai on 13-12-24.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCdes : NSObject

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
@end
