//
//  ViewController.m
//  StandardBrowser
//
//  Created by hishinuma on 2015/07/18.
//  Copyright (c) 2015年 binsent. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// storyboard上のUIパーツとコードの紐付け
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browserBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browserForwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;

// storyboard上のUIパーツのイベントとコードの紐付け
- (IBAction)onTapBrowserBackButton:(id)sender;
- (IBAction)onTapBrowserForwardButton:(id)sender;
- (IBAction)onTapRefreshButton:(id)sender;
- (IBAction)onTapStopButton:(id)sender;

@end

@implementation ViewController

#pragma mark -- Lifecycle

/*
 ロード時にコール
 ※1度しか呼ばれない
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    // リクエスト
    NSString *urlString     = @"http://google.co.jp";
    NSURL *requestUrl       = [NSURL URLWithString:urlString];
    [self loadWebViewRequestWithUrl:requestUrl];
}

/*
 画面表示直前にコール
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateToolBarButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- Private

/*
 引数のURLを用いてWebページのロードを開始する
 @param url :リクエストするURL
 */
- (void)loadWebViewRequestWithUrl:(NSURL *)url
{
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

/*
 ツールバー内に配置されている各ボタンの状態を更新する
 */
- (void)updateToolBarButtons
{
    // 戻るボタン
    if ([self.webView canGoBack]) {
        // 一つ前のページへの遷移：可能
        self.browserBackButton.enabled = YES;
    }
    else {
        // 一つ前のページへの遷移：不可能
        self.browserBackButton.enabled = NO;
    }
    
    // 進むボタン
    if ([self.webView canGoForward]) {
        // 一つ後のページへの遷移：可能
        self.browserForwardButton.enabled = YES;
    }
    else {
        // 一つ後のページへの遷移：不可能
        self.browserForwardButton.enabled = NO;
    }
    
    // 中止ボタン
    if ([self.webView isLoading]) {
        self.stopButton.enabled = YES;
    }
    else {
        self.stopButton.enabled = NO;
    }
}

#pragma mark -- <UIWebViewDelegate>

/*
 ロード時にコール
 @param webView
 @param request
 @param navigationType
 @return YES:ロードを許可する NO:ロードは許可しない
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateToolBarButtons];
    return YES;
}

/*
 読み込み開始時にコール
 @param webView
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateToolBarButtons];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 読み込み終了時にコール
 @param webView
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateToolBarButtons];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*
 読み込み失敗時にコール
 @param webView
 @param error
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateToolBarButtons];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -- Button Action Method

/*
 戻るボタンタップ時にコール
 */
- (IBAction)onTapBrowserBackButton:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

/*
 進むボタンタップ時にコール
 */
- (IBAction)onTapBrowserForwardButton:(id)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

/*
 更新ボタンタップ時にコール
 */
- (IBAction)onTapRefreshButton:(id)sender
{
    [self.webView reload];
}

/*
 中止ボタンタップ時にコール
 */
- (IBAction)onTapStopButton:(id)sender
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
}

@end
