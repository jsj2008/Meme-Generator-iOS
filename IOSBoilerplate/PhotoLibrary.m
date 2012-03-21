//
//  PhotoLibrary.m
//  IOSBoilerplate
//
//  Created by Lee Wei Yeong on 21/03/2012.
//  Copyright (c) 2012 IC. All rights reserved.
//

#import "PhotoLibrary.h"
#import "AsyncImageExample.h"
#import "SVProgressHUD.h"
#import "NSURLConnectionWithTag.h"

@implementation PhotoLibrary
@synthesize imageView, parentViewController, selectedImage;

-(id)initWithView: (UIViewController *)parentView
{
    if (self = [super init])
    {
        [self setParentViewController:parentView];
        newMedia = NO;
    }
    return self;
}
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
        UIImage *image = [info 
                          objectForKey:UIImagePickerControllerOriginalImage];
        imageView.image = image;

        selectedImage = [image copy];
        AsyncImageExample *parentView = (AsyncImageExample *) parentViewController;
        parentView.toolbar.barStyle = UIBarStyleDefault;
        [parentView.toolbar sizeToFit];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                         target:parentView
                                         action:@selector(buttonPressed:)];
        [parentView.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, shareButton, flexibleSpace, nil]];
        [flexibleSpace release];
        [SVProgressHUD showInView:parentView.view];
        /*
         NSURL *requestURL   = [NSURL URLWithString:@"https://api.imgur.com/oauth/request_token"];
         NSURL *accessURL    = [NSURL URLWithString:@"https://api.imgur.com/oauth/access_token"];
         NSURL *authorizeURL = [NSURL URLWithString:@"https://api.imgur.com/oauth/authorize"];
         NSString *scope = @"http://api.imgur.com/";
         NSString *myConsumerKey = @"511280b201b2ccdbca3045259eac707304f69b8d7";
         NSString *myConsumerSecret = @"df7d396f15dc458a7abcee01c44dbb56";
         */
        // generate meme //
        NSString *username = @"generate.meme";
        NSString *password = @"password";
        NSString *langCode = @"en";
        //        int generatorId = 45, imageId = 20;   // Insanity-Wolf        
        int generatorId = 2, imageId = 166088; // Y-U-No
        NSString *text0    = @"first line";
        NSString *text1    = @"second line";
        NSString *sz_url = [NSString stringWithFormat:@"http://version1.api.memegenerator.net/Instance_Create?username=%@&password=%@&languageCode=%@&generatorID=%d&imageID=%d&text0=%@&text1=%@",
                            username,password,langCode,generatorId,imageId,
                            [text0 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                            [text1 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"%@", sz_url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sz_url]];
        [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:parentView startImmediately:YES tag:[NSNumber numberWithInt:0]];
        /*
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, 
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
         */
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    NSLog(@"imagePickerControllerDidCancel(): %@ %@", self, picker);
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
@end
