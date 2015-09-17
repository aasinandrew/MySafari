//
//  ViewController.m
//  MySafari
//
//  Created by Andrew  Nguyen on 7/15/15.
//  Copyright (c) 2015 Andrew Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property CGPoint newPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    [self.webView.scrollView setDelegate:self];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com"]]];

}

- (void)checkForwardAndBackButtons {

    if (self.webView.canGoBack) {
        self.backButton.enabled = YES;
    } else {
        self.backButton.enabled = NO;
    }

    if (self.webView.canGoForward) {
        self.forwardButton.enabled = YES;
    } else {
        self.forwardButton.enabled = NO;
    }
}

#pragma mark - TextField Delagate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSURL *url;
    if ([textField.text containsString:@"https://www."]) {
        url = [NSURL URLWithString:textField.text];
    } else if ([textField.text containsString:@"www."]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", textField.text]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.%@",textField.text]];
    }

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - WebView Delagate Methods
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self checkForwardAndBackButtons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.urlTextField.text = webView.request.URL.absoluteString;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self checkForwardAndBackButtons];
}

#pragma mark - Button Presses
- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self.webView goBack];
}
- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    [self.webView goForward];
}
- (IBAction)onStopButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}
- (IBAction)onPlusButtonPressed:(UIButton *)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Feature!"
                                                                   message:@"Coming soon!"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {

        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ScrollView Delagate Methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.newPoint = scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y > self.newPoint.y) {
        self.urlTextField.hidden = YES;
    } else {
        self.urlTextField.hidden = NO;
    }
}

@end
