//
//  OnlineTextureSelectorViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>

@protocol TextureSelectorDelegate<NSObject>

- (void)imageSelected:(UIImage *)img;

@end


@interface OnlineTextureSelectorViewController : UIViewController <UIWebViewDelegate> {
	UITextField* urlBar;
	UIButton* chooserButton;
	UIWebView* webView;
	id <TextureSelectorDelegate> delegate;
}

@property (retain) IBOutlet UIButton *chooserButton;
@property (retain) IBOutlet UITextField *urlBar;
@property (retain) IBOutlet UIWebView *web;
@property (assign) id <TextureSelectorDelegate> delegate;


- (IBAction)navigate:(UIButton*)sender;
- (IBAction)selectImage:(UIButton*)sender;

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navType;

- (id)initWithDelegate:(id) del; //need to change declaration.



@end
