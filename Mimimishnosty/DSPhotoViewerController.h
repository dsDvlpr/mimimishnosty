//
//  DSPhotoViewerController.h
//  Photo Viewer
//
//  Created by Dmitry Sharygin on 31.12.16.
//  Copyright © 2016 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DSPhotoViewerController : NSObject

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSArray *photosURLStrings;
@property (strong, nonatomic) UIImageView *imageView;

-(instancetype)initWithPhotosURLs:(NSArray *)photosURLs inViewController:(UIViewController *)vc andImageView:(UIImageView *)imageView;

- (void) presentPhotoViewController;

@end
