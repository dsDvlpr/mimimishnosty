//
//  DSPhoto.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 26.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhoto.h>

@interface DSPhoto : NSObject <NYTPhoto>

@property (strong, nonatomic, nullable) NSString *URLString;
@property (nonatomic, nullable) UIImage *image;
@property (nonatomic, nullable) NSData *imageData;
@property (nonatomic, nullable) UIImage *placeholderImage;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionTitle;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionSummary;
@property (nonatomic, nullable) NSAttributedString *attributedCaptionCredit;

@end
