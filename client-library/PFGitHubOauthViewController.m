//
//  PFGitHubOauthViewController.m
//  Percero
//
//  Created by Jeff Wolski on 4/16/13.
//
//

#import "PFGitHubOauthViewController.h"

@interface PFGitHubOauthViewController (){
    NSString *oauthURLString;
    NSString *oauthTokenURLString;
    NSString *oauthClientId;
    NSString *oauthRedirectURI;
    NSString *oauthClientSecret;
    NSString *oauthScope;
    NSString *oauthState;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *transitionView;

@end

@implementation PFGitHubOauthViewController

- (void) gotACode{
    // The PFOauthCompletedView nib shouold be in the client app, if not then use the default "Got a Code" meessage
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PFOauthCompletedView" ofType:@"nib"];
    
    if (path){
        self.transitionView = [[[NSBundle mainBundle] loadNibNamed:@"PFOauthCompletedView" owner:nil options:nil] lastObject];
        [self.view addSubview:self.transitionView];
    }
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    oauthURLString = @"https://github.com/login/oauth/authorize";
    oauthTokenURLString = @"https://github.com/login/oauth/access_token";
    oauthClientId = @"13262a8ae5e6f1a1d24f";
    oauthRedirectURI = @"http://percero.io/oauth.html";
    oauthClientSecret = @"d03c8603efa329958bfb927e055aec12f6c9c56c";
    oauthScope = @"user,repo,public_repo";
    oauthState = [[NSUUID UUID] UUIDString];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    [self.webView loadRequest:[self oauthURLRequest]];
}

- (NSURLRequest *) oauthURLRequest {
    
    NSString * urlString = oauthURLString;
    
    
    if (urlString) {
        
        if (oauthClientId) {
            urlString = [NSString stringWithFormat:@"%@?client_id=%@",urlString,oauthClientId];
            
            if (oauthRedirectURI) {
                urlString = [NSString stringWithFormat:@"%@&redirect_uri=%@",urlString,oauthRedirectURI];
            }
            
            if (oauthScope) {
                urlString = [NSString stringWithFormat:@"%@&scope=%@",urlString,oauthScope];
            }
            
            if (oauthState) {
                urlString = [NSString stringWithFormat:@"%@&state=%@",urlString,oauthState];
            }
            
            
        } else{
            urlString = nil;
        }
    }
    
    NSURL * oauthURL = [NSURL URLWithString:urlString];
    
    NSURLRequest * result = [NSURLRequest requestWithURL:oauthURL];
    
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void) requestAccessTokenWithCode:(NSString *) oauthCode{
    
    NSMutableURLRequest *oauthRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:oauthTokenURLString]];
    [oauthRequest setHTTPMethod: @"POST"];
    [oauthRequest setValue:@"text/html" forHTTPHeaderField:@"Content-type"];
    //    NSString * postString = [NSString stringWithFormat:@"client_id:%@&redirect_uri:%@&client_secret:%@&code:%@", oauthClientId, oauthRedirectURI, oauthClientSecret, oauthCode];
    NSString * postString = [NSString stringWithFormat:@"client_id:%@&client_secret:%@&code:%@", oauthClientId, oauthClientSecret, oauthCode];
    
    [oauthRequest setValue:[NSString stringWithFormat:@"%d", postString.length] forHTTPHeaderField:@"Content-length"];
    [oauthRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:oauthRequest returningResponse:&response error:&error];
    responseData = nil;
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"responseData:%@",responseString);
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL shouldStart = YES;
    
    NSString * parametersString = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject] ;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    for (NSString *parameter in [parametersString componentsSeparatedByString:@"&"]) {
        NSArray *peices = [parameter componentsSeparatedByString:@"="];
        if([peices count] >= 2)
            parameters[peices[0]] = peices[1];
    }
    
//    NSLog(@"url:%@", parameters);
    
    NSString *requestState = [parameters valueForKey:@"state"];
    NSString *errorString = [parameters valueForKey:@"error"];
    
    if (requestState) {
        if ([requestState isEqualToString:oauthState]){
            NSString *code = [parameters valueForKey:@"code"];
            if (code) {
                shouldStart = NO;
                
                [self requestAccessTokenWithCode:code];
                [self gotACode];
                [webView loadHTMLString:[NSString stringWithFormat: @"Got a code:%@",code] baseURL:nil];
                [self.delegate authenticationSucceededWithCode:code];
            }
        } else {
            shouldStart = NO;
            [webView loadHTMLString:@"States do not match!" baseURL:nil];
            [self.delegate authenticationFailed];
        }
    }
    
    
    if (errorString) {
        shouldStart = NO;
        [webView loadHTMLString:[NSString stringWithFormat: @"Got an error:%@", errorString] baseURL:nil];
        [self.delegate authenticationFailed];

    }
    
    
    
    return shouldStart;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

@end
