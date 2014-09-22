//
//  ImageUtil.h
//  coin
//
//  Created by duomai on 13-12-25.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject
/**
 *	@brief	更改image的大小
 *
 *	@param 	image 	原来image
 *	@param 	reSize 	更改后的大小
 *
 *	@return	更改大小后的image
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
