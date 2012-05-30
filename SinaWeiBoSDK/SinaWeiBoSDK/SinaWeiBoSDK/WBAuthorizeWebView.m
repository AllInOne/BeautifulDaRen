//
//  WBAuthorizeWebView.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
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
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorizeWebView.h"
#import <QuartzCore/QuartzCore.h> 
#import "ViewHelper.h"

@interface WBAuthorizeWebView ()
@property (nonatomic, retain) NSURL * requestUrl;
@end

@implementation WBAuthorizeWebView

@synthesize delegate;
@synthesize webView = _webView;
@synthesize requestUrl = _requestUrl;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.navigationItem.title = @"认证";

        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onDoneButtonClicked:) title:@"完成"]];
    }
    return self;
}

- (void)onDoneButtonClicked:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)loadRequestWithURL:(NSURL *)url
{
    self.requestUrl = url;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	_webView.delegate = self;
	[self.view addSubview:_webView];
    
	NSURLRequest *request = [NSURLRequest requestWithURL:_requestUrl];
	[_webView loadRequest:request];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_webView setDelegate:nil];
    [_webView stopLoading];

    [_requestUrl release];
    [_webView release];
    [super dealloc];
}
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        
        if ([delegate respondsToSelector:@selector(authorizeWebView:didReceiveAuthorizeCode:)])
        {
            [delegate authorizeWebView:self didReceiveAuthorizeCode:code];
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }
    
    return YES;
}

@end
