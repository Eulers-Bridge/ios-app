//
//  EBAddContactViewController.m
//  Isegoria
//
//  Created by Alan Gao on 31/08/2016.
//  Copyright © 2016 Eulers Bridge. All rights reserved.
//

#import "EBAddContactViewController.h"
#import "EBSearchUserTableViewController.h"


@implementation EBAddContactViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    EBSearchUserTableViewController *resultController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchUserResult"];
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultController];
    self.searchBar = searchController.searchBar;
    searchController.searchResultsUpdater = self;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

@end
