//
//  ELCImagePickerDemoViewController.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"

@protocol LoadImageBtnDelegate <NSObject>

- (void) loadImageBtn:(NSMutableArray *) ImageArray WithFlag:(BOOL) flag;

@end

@interface ELCImagePickerDemoViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> 
{
}
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy) NSMutableArray *chosenImages;

@property (assign,nonatomic) id<LoadImageBtnDelegate> delegate;

// the default picker controller
- (IBAction)launchController;

// a special picker controller that limits itself to a single album, and lets the user
// pick just one image from that album.
- (IBAction)launchSpecialController;

@end

