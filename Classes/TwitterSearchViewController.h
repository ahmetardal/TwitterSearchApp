//
//  TwitterSearchViewController.h
//  TwitterSearch
//
//  Created by Ahmet Ardal on 4/26/11.
//  Copyright 2011 Ahmet Ardal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@interface TwitterSearchViewController: UIViewController<UITableViewDelegate,
                                                         UITableViewDataSource,
                                                         UITextFieldDelegate,
                                                         ASIHTTPRequestDelegate>
{
    UITextField *searchKeywordTextField;
    UITableView *searchResultsTableView;
    NSArray *searchResults;
}

@property (nonatomic, retain) IBOutlet UITextField *searchKeywordTextField;
@property (nonatomic, retain) IBOutlet UITableView *searchResultsTableView;
@property (nonatomic, retain) NSArray *searchResults;

@end
