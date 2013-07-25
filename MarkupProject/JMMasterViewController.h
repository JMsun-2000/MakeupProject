//
//  JMMasterViewController.h
//  MarkupProject
//
//  Created by Sun Jimmy on 6/5/13.
//  Copyright (c) 2013 Sun Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMDetailViewController;

#import <CoreData/CoreData.h>

@interface JMMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) JMDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
