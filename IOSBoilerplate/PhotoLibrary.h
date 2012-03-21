#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotoLibrary : UIViewController
<UIImagePickerControllerDelegate, 
UINavigationControllerDelegate>
{
    UIImageView *imageView;
    UIViewController *parentViewController;
    UIImage *selectedImage;
    BOOL newMedia;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) UIViewController *parentViewController;
@property (nonatomic, retain) UIImage *selectedImage;

-(id)initWithView: (UIViewController *)parentView;
@end