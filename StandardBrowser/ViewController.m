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
@property (weak, nonatomic) IBOutlet UIWebView *webView;                    // WebView
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browserBackButton;    // 戻るボタン
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browserForwardButton; // 進むボタン
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;           // 読み込み中止ボタン

// storyboard上のUIパーツのイベントとコードの紐付け
- (IBAction)onTapBrowserBackButton:(id)sender;      // 戻るボタンタップイベント
- (IBAction)onTapBrowserForwardButton:(id)sender;   // 進むボタンタップイベント
- (IBAction)onTapRefreshButton:(id)sender;          // 再読込ボタンタップイベント
- (IBAction)onTapStopButton:(id)sender;             // 読み込み中止ボタンタップイベント

@end

@implementation ViewController

// pragma markについて
// http://zutto-megane.com/objective-c/post-404/
#pragma mark - Lifecycle

/*
 ロード時にコールされる
 ※1度しか呼ばれない
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // webViewイベントが通知されるようdelegateを設定
    self.webView.delegate = self;
    
    // リクエスト作成
    NSString *requestURLString  = @"http://google.co.jp";
    NSURL *requestUrl           = [NSURL URLWithString:requestURLString];
    
    // webViewページを作成したリクエストでロード
    [self loadWebViewRequestWithURL:requestUrl];
}

/*
 画面表示直前にコールされる
 画面を切り替える度に呼ばれる
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ツールバー内に配置されているボタン表示状態を更新
    [self updateToolBarButtons];
}

/*
 メモリ警告時にコールされる
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - <UIWebViewDelegate>

/*
 ロード時にコール
 @param webView
 @param request
 @param navigationType
 @return YES:ロードを許可する NO:ロードは許可しない
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // ツールバー内に配置されているボタン表示状態を更新
    [self updateToolBarButtons];
    
    return YES;
}

/*
 読み込み開始時にコール
 @param webView
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // ツールバー内に配置されているボタン表示状態を更新
    [self updateToolBarButtons];
    
    // ステータスバーにインジケータを表示する
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 読み込み終了時にコール
 @param webView
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // ツールバー内に配置されているボタン表示状態を更新
    [self updateToolBarButtons];
    
    // ステータスバーのインジケータを非表示にする
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*
 読み込み失敗時にコール
 @param webView
 @param error
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // ツールバー内に配置されているボタン表示状態を更新
    [self updateToolBarButtons];
    
    // ステータスバーのインジケータを非表示にする
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Button Action Method

/*
 戻るボタンタップ時にコール
 */
- (IBAction)onTapBrowserBackButton:(id)sender
{
    // webViewでページが戻れるかで判別
    if ([self.webView canGoBack]) {
        // webViewのページを一つ戻る
        [self.webView goBack];
    }
}

/*
 進むボタンタップ時にコール
 */
- (IBAction)onTapBrowserForwardButton:(id)sender
{
    // webViewでページが進めるかで判別
    if ([self.webView canGoForward]) {
        // webViewのページを一つ進める
        [self.webView goForward];
    }
}

/*
 更新ボタンタップ時にコール
 */
- (IBAction)onTapRefreshButton:(id)sender
{
    // webViewで現在表示されているページを再読み込み
    [self.webView reload];
}

/*
 中止ボタンタップ時にコール
 */
- (IBAction)onTapStopButton:(id)sender
{
    // webViewが読み込み中かで判別
    if ([self.webView isLoading]) {
        // webViewの読み込みを中止
        [self.webView stopLoading];
    }
}

#pragma mark - Private

/*
 引数のURLを用いてWebページのロードを開始する
 @param url :リクエストするURL
 */
- (void)loadWebViewRequestWithURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

/*
 ツールバー内に配置されている各ボタンの状態を更新する
 */
- (void)updateToolBarButtons
{
    // 戻るボタン表示状態更新(webViewでページが戻れるかで判別)
    if ([self.webView canGoBack]) {
        // 一つ前のページへの遷移：可能 → 戻るボタンを活性状態に変更
        self.browserBackButton.enabled = YES;
    }
    else {
        // 一つ前のページへの遷移：不可能 → 戻るボタンを非活性状態に変更
        self.browserBackButton.enabled = NO;
    }
    
    // 進むボタン表示状態更新(webViewでページが進めるかで判定)
    if ([self.webView canGoForward]) {
        // 一つ後のページへの遷移：可能 → 進むボタンを活性状態に変更
        self.browserForwardButton.enabled = YES;
    }
    else {
        // 一つ後のページへの遷移：不可能 → 進むボタンを非活性状態に変更
        self.browserForwardButton.enabled = NO;
    }
    
    // 中止ボタン表示状態更新(webViewでページが読み込み中かで判別)
    if ([self.webView isLoading]) {
        // 読み込み状態：読み込み中 → 中止ボタンを活性状態に変更
        self.stopButton.enabled = YES;
    }
    else {
        // 読み込み状態：読み込み中でない → 中止ボタンを非活性状態に変更
        self.stopButton.enabled = NO;
    }
}

@end
