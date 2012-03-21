//
//  AsyncImageExample.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "AsyncImageExample.h"
#import "NYXImagesKit.h"

@implementation AsyncImageExample

@synthesize imageView, toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialisation
        if (response == nil) {
            response = [[NSMutableDictionary alloc] init];
        }
        if (photoLibrary == nil) {
            photoLibrary = [[PhotoLibrary alloc] initWithView:self];
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Imgur";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction) buttonPressed:(id) sender
{
    //    NSLog(@"buttonPressed()");
	// Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:[response objectForKey:@"imageURL"]];
	SHKItem *item = [SHKItem URL:url title:@"Meme Generator+"];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	// Display the action sheet
	[actionSheet showFromToolbar:self.toolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = photoLibrary;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
    }
}

// ====================
// Callbacks
// ====================
#pragma mark NSURLConnection delegate methods
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([error code] == kCFURLErrorNotConnectedToInternet)
    {
        /*
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:@"No Connection Error"
                                                                 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfoDict];
        */
    }
    [SVProgressHUD dismissWithError:[error localizedDescription]];
}
-(void)connection:(NSURLConnectionWithTag *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSLog(@"didReceiveResponse()");
}
-(void)connection:(NSURLConnectionWithTag *)connection didReceiveData:(NSData *)data
{
    //    NSLog(@"didReceiveData(%@)", connection.tag);
    if ([connection.tag intValue] == 0)
    {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"data = %@", dataString);
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSError *error = nil;
        NSDictionary *jsonObjects = [jsonParser objectWithString:dataString error:&error];
        [jsonParser release], jsonParser = nil;
        NSDictionary *results = [jsonObjects objectForKey:@"result"];
        NSString *instanceID = [results objectForKey:@"instanceID"];
        //        NSLog(@"instanceID = %@", instanceID);

        // Screen size //
        /*
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
        int width = (int) screenSize.width, height = (int) screenSize.height;
        */
        // upload meme //
        NSString *sz_url = [NSString stringWithFormat:@"http://images.memegenerator.net/instances/%@.jpg", instanceID];
        //        NSString *sz_url = [NSString stringWithFormat:@"http://images.memegenerator.net/instances/%dx%d/%@.jpg", width, height, instanceID];
        NSURL *url   = [NSURL URLWithString:sz_url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
        
        // merge images here //
        NSLog(@"Meme image %@ %f %f", img, img.size.width, img.size.height);
        NSLog(@"Selected image %@ %f %f", photoLibrary.selectedImage, photoLibrary.selectedImage.size.width, photoLibrary.selectedImage.size.height);

        UIImage *topImage = photoLibrary.selectedImage; // photo album
        UIImage *bottomImage = img;                     // meme
        CGFloat newWidth = MAX(topImage.size.width, bottomImage.size.width);
        CGFloat newHeight = topImage.size.height + bottomImage.size.height;
        NSLog(@"%f %f", newWidth, newHeight);
        CGSize newSize = CGSizeMake(newWidth, newHeight);
        UIGraphicsBeginImageContext( newSize );
        [topImage drawInRect:CGRectMake(0,0,topImage.size.width,topImage.size.height)]; //blendMode:kCGBlendModeNormal alpha:0.8];
        [bottomImage drawInRect:CGRectMake(0,topImage.size.height,bottomImage.size.width,bottomImage.size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();        
        //UIImage* rotated = [img rotateInDegrees:217.0f];
        NSData   *imageData = UIImagePNGRepresentation(newImage);
        NSString *imageB64  = [[imageData base64EncodingWithLineLength:0] encodedURLString];
        NSDictionary *plistDict = [Plist getDictionary:@"settings"];
        NSString *key = [plistDict objectForKey:@"imgur_dev_key"];
        NSString *uploadCall = [NSString stringWithFormat:@"key=%@&image=%@",key,imageB64];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.imgur.com/2/upload.json"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%d",[uploadCall length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[uploadCall dataUsingEncoding:NSUTF8StringEncoding]];
        [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self startImmediately:YES tag:[NSNumber numberWithInt:1]];
    }
    else if ([connection.tag intValue] == 1)
    {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSLog(@"data = %@", dataString);
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSError *error = nil;
        NSDictionary *jsonObjects = [jsonParser objectWithString:dataString error:&error];
        [jsonParser release], jsonParser = nil;
        NSDictionary *uploads = [jsonObjects objectForKey:@"upload"];
        NSDictionary *links   = [uploads objectForKey:@"links"];
        NSString *imageURL    = [links objectForKey:@"original"];
        //        NSLog(@"image url = %@", imageURL);
        if (!imageURL)
        {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Unable to fetch image" forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"world" code:200 userInfo:details];
            [SVProgressHUD dismissWithError:[error localizedDescription]];   
        }
        else if (![response objectForKey:@"imageURL"])
        {
            [response setObject:imageURL forKey:@"imageURL"];
        }
    }
}
-(void)connectionDidFinishLoading:(NSURLConnectionWithTag *)connection
{
    if ([connection.tag intValue] == 1)
    {
        NSString *imageURL = [response objectForKey:@"imageURL"];
        if (imageURL)
        {          
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            NSArray *chunks = [imageURL componentsSeparatedByString: @"/"];
            NSUInteger count = [chunks count];
            self.title = [chunks objectAtIndex:count-1];
            [self.imageView setImageWithURL:[NSURL URLWithString:imageURL]];
            [SVProgressHUD dismissWithSuccess:@"Ok!"];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)dealloc {
    [imageView release];
    
    [super dealloc];
}

@end
