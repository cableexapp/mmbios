//
//  MCMoreCell.h
//  coin
//
//  Created by duomai on 13-12-24.
//  Copyright (c) 2013年 tiny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCFChenMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avState;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
- (void)startAnimation;
- (void)failAcimation;
- (void)stopAnimation;
- (void)noDataAnimation;
- (void) noClasses;
- (void) noB2BInvoice;
- (void) HomeImprovementGalleryOrders;

-(void)noSearchResult;

@end
