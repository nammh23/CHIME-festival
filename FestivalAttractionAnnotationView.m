//
//  FestivalAttractionAnnotationView.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/7/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalAttractionAnnotationView.h"
#import "FestivalAttractionAnnotation.h"
#import "Constants.h"
@import Firebase;
@import FirebaseStorageUI;
@implementation FestivalAttractionAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        FestivalAttractionAnnotation *attractionAnnotation = self.annotation;
        switch (attractionAnnotation.type) {
            case AttractionOcean:
                self.image = [UIImage imageNamed:@"ocean"];
                break;
            case AttractionChurch:
                self.image = [UIImage imageNamed:@"church"];
                break;
            case AttractionBuilding:
                self.image = [UIImage imageNamed:@"building"];
                break;
            case AttractionAssociation:
                self.image = [UIImage imageNamed:@"association"];
                break;
            case AttractionCustom:
                self.image = [self drawImage:[UIImage imageNamed:@"Test"] inImage:[UIImage imageNamed:@"CustomPin"]atPoint:CGPointMake(7.25, 2)];
                break;
            default:
                self.image = [UIImage imageNamed:@"Pin"];
                break;
        }
    }
    
    return self;
}

- (id)initWithCustomAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(NSString*)avatarURL {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    FestivalAttractionAnnotation *attractionAnnotation = self.annotation;
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *imageTmp = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
    if(imageTmp != nil){
        imageView.image = imageTmp;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:avatarURL];
        [imageView sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }

    switch (attractionAnnotation.type) {
        case AttractionCustom:
            self.image = [self drawImage:imageView.image inImage:[UIImage imageNamed:@"CustomPin"]atPoint:CGPointMake(7.25, 2)];
            break;
        default:
            self.image = [UIImage imageNamed:@"Pin"];
            break;
    }
    return self;
}

- (UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    UIImage* mask = [UIImage imageNamed:@"CircularMask"];
    UIImage* profileImage = [self maskImage:fgImage withMask:mask];
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [profileImage drawInRect:CGRectMake( point.x, point.y, 40, 40)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}
@end
