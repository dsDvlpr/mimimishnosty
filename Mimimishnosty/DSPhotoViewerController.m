//
//  DSPhotoViewerController.m
//  Photo Viewer
//
//  Created by Dmitry Sharygin on 31.12.16.
//  Copyright © 2016 Dmitry Sharygin. All rights reserved.
//

#import "DSPhotoViewerController.h"
#import "UIImageView+AFNetworking.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "DSPhoto.h"
#import <AFImageDownloader.h>

@interface DSPhotoViewerController () <NYTPhotosViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) DSPhoto *currentPhoto;
@property (strong, nonatomic) NYTPhotosViewController *photoViewController;

@end

@implementation DSPhotoViewerController

-(instancetype)initWithPhotosURLs:(NSArray *)photosURLs inViewController:(UIViewController *)vc andImageView:(UIImageView *)imageView {
    
    self = [super init];
    if (self) {
        self.photosURLStrings = photosURLs;
        self.viewController = vc;
        self.imageView = imageView;
        
        [self updateMainImageView];
        [self initializePhotos];
        [self downloadPhotos];

        self.photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos
                                                                      initialPhoto:self.currentPhoto
                                                                          delegate:self];

    }
    
    return self;
    
}

#pragma mark - Gestures

- (void) handleImageViewTap:(UITapGestureRecognizer*) recognizer {
    
    NSLog(@"Image tapped");
    [self presentPhotoViewController];
    
}

#pragma mark - Methods

- (void) updateMainImageView {
    
    NSURL *URL = [NSURL URLWithString: [self.photosURLStrings firstObject]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak DSPhotoViewerController *weakSelf = self;
    
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       
                                       NSLog(@"\n\nDownloaded");
                                       
                                       weakSelf.imageView.image = image;
                                       
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       NSLog(@"\n\nNOT Downloaded");
                                       ;
                                   }];
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTap:)];
    
    [self.imageView addGestureRecognizer:tapRecognizer];

    
}

- (void) presentPhotoViewController {
    
    self.photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos
                                                                  initialPhoto:self.currentPhoto
                                                                      delegate:self];
    
    [self.viewController presentViewController:self.photoViewController
                       animated:YES
                     completion:^{
                         ;
                     }];
    
}


- (void) initializePhotos {
    
    for (NSString *urlString in self.photosURLStrings) {
        
        DSPhoto *photo = [[DSPhoto alloc] init];
        photo.URLString = urlString;
        if (!self.photos) {
            self.photos = [NSMutableArray array];
        }
        
        [self.photos addObject:photo];
        self.currentPhoto = [self.photos firstObject];
    }
}

- (void) downloadPhotos {
    
    for (NSString *URLString in self.photosURLStrings) {
        
        NSInteger currentIndex = [self.photosURLStrings indexOfObject:URLString];
        
        NSURL *url = [NSURL URLWithString:URLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        __weak DSPhotoViewerController *weakSelf = self;
        NSLog(@"\nDownloading photo %ld...", (long)currentIndex);
        
        [[AFImageDownloader defaultInstance]
         downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
             
             DSPhoto * currentPhoto = [self.photos objectAtIndex:currentIndex];
             currentPhoto.image = responseObject;
             [weakSelf.photoViewController updateImageForPhoto:currentPhoto];
             NSLog(@"\nPhoto downloaded %ld", (long)currentIndex);
             
         }
         failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             NSLog(@"\nCANNOT download photo %ld \nError:%@", (long)currentIndex, [error userInfo]);
             ;
         }];
        
    }
    
}

#pragma mark - NYTPhotosViewControllerDelegate

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
    
    self.currentPhoto = photo;
    
}


- (void)photosViewControllerWillDismiss:(NYTPhotosViewController *)photosViewController {
    
    self.imageView.image = self.currentPhoto.image;
    
}


@end
