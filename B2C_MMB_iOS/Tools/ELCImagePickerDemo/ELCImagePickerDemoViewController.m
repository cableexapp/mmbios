//
//  ELCImagePickerDemoViewController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerDemoViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"
#import "MCDefine.h"

@interface ELCImagePickerDemoViewController ()

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@end

@implementation ELCImagePickerDemoViewController

//Using generated synthesizers


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.backScrollView setContentSize:CGSizeMake(320, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 20)];
}


#pragma mark - 多选
- (IBAction)launchController
{
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 9;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
	elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}


#pragma mark - 单选
- (IBAction)launchSpecialController
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.specialLibrary = library;
    NSMutableArray *groups = [NSMutableArray array];
    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0]];
        }
    } failureBlock:^(NSError *error) {
        self.chosenImages = nil;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
    }];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
	ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
	tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
	
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    

    
	CGRect workingFrame = _scrollView.frame;
	workingFrame.origin.x = 0;

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
	
	for (NSDictionary *dict in info) {
	
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
        
		UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;

		[_scrollView addSubview:imageview];
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
	}
    
    self.chosenImages = images;
	[_scrollView setPagingEnabled:YES];
	[_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    for(int i=0;i<self.chosenImages.count;i++)
    {
//        NSLog(@"image = %@",[self.chosenImages objectAtIndex:i]);
    }
    [self.delegate loadImageBtn:self.chosenImages WithFlag:YES];
}

//Cancel
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
