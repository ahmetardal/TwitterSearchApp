//
//  TwitterSearchViewController.m
//  TwitterSearch
//
//  Created by Ahmet Ardal on 4/26/11.
//  Copyright 2011 Ahmet Ardal. All rights reserved.
//

#import "TwitterSearchViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

static const NSInteger kMaxResultCount = 50;

@interface TwitterSearchViewController(Private)
- (void) startTwitterSearchWithKeyword:(NSString *)keyword;
@end

@implementation TwitterSearchViewController

@synthesize searchKeywordTextField, searchResultsTableView, searchResults;

- (void) initialize
{
    self.searchResults = nil;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return self;
    }
    
    [self initialize];
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.searchKeywordTextField setFont:[UIFont systemFontOfSize:15]];
    [self.searchKeywordTextField becomeFirstResponder];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
}

- (void) dealloc
{
    [self.searchKeywordTextField release];
    [self.searchResultsTableView release];
    [self.searchResults release];
    [super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (void) startTwitterSearchWithKeyword:(NSString *)keyword
{
    // url-encode the search text
    keyword = [keyword stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    keyword = [keyword stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    keyword = [keyword stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];

    // start search request
    NSString *url = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@&rpp=%d",
                     keyword, kMaxResultCount];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startAsynchronous];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSLog(@"startTwitterSearchWithKeyword - url: %@", url);
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"requestFinished - %@", responseString);
    NSDictionary *json = [responseString JSONValue];
    self.searchResults = [json objectForKey:@"results"];
    
    [self.searchResultsTableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                               withRowAnimation:UITableViewRowAnimationFade];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:@"Request failed."
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
    [av release];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@""] == NO) {
        [self startTwitterSearchWithKeyword:textField.text];
    }
    return NO;
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResults == nil) {
        return 0;
    }

    return [self.searchResults count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellId] autorelease];
    }
    
    NSString *tweetText = @"";
    if (self.searchResults != nil) {
        NSDictionary *tweet = [self.searchResults objectAtIndex:indexPath.row];
        NSString *username = [tweet objectForKey:@"from_user"];
        NSString *text = [tweet objectForKey:@"text"];
        tweetText = [NSString stringWithFormat:@"[%@]: %@", username, text];
    }

    cell.textLabel.numberOfLines = 5;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = tweetText;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
