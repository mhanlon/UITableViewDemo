//
//  ViewController.m
//  UITableViewDemo
//
//  Created by Matthew Hanlon on 5/14/15.
//  Copyright (c) 2015 Q.I. Software. All rights reserved.
//

#import "ViewController.h"

static NSString* reuseableTableViewCellIdentifier = @"TableViewCell";

@interface ViewController ()
{
    BOOL _isInsertingNewRestaurant;
}
@property (nonatomic, strong) UIButton *startInsertingButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSArray *favoriteRestaurants;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.title = NSLocalizedString(@"Favorite Restaurants", nil);
        self.favoriteRestaurants = @[@"Ronnie's Seafood, Charlton, Mass.", @"Ronnie's Seafood, Auburn, Mass.", @"Union Oyster House", @"Legal Seafood", @"Five Guys"];
        // A sort of more clear (and old) way of initializing this array would look like this:
        // self.favoriteRestaurants = [NSArray arrayWithObjects:@"Ronnie's Seafood, Charlton, Mass.", @"Ronnie's Seafood, Auburn, Mass.", @"Union Oyster House", @"Legal Seafood", @"Five Guys", nil];
        _isInsertingNewRestaurant = NO;
        self.addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [self.addButton addTarget:self action:@selector(beginInsertingRestaurant:) forControlEvents:UIControlEventTouchUpInside];
        
        self.tableView.tableFooterView = self.addButton; // Being lazy and adding our add button to the bottom of our table view
                                                         // You'd want to make this look a bit nicer than this.
        
        // TODO: Make a view which shows off the behavior of adding an item at the end of the array and the insertion method
        //      Right now the + button at the bottom of our tableview turns on "insertion" mode where we can insert or re-order
        //      items in our list.
        //      For this task, maybe make a button that simply inserts a new restaurant at the end of the list by default, without
        //      requiring any more taps from the user.
        //      The old button could remain, or it could turn into an 'Edit' button, or you could decide that you don't want people
        //      to change their restaurant preference around.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRestaurant:(id)sender
{
    // This is where you'd insert your *other* insertion code, should you choose that challenge.
}

- (void)beginInsertingRestaurant:(id)sender
{
    // Toggle our editing state so we enter the editing state and then, when we press the button again,
    // we exit the editing state.
    _isInsertingNewRestaurant = !_isInsertingNewRestaurant;
    [self.tableView setEditing:_isInsertingNewRestaurant animated:NO];
}

#pragma mark -- UITableViewController delegate methods --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoriteRestaurants.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseableTableViewCellIdentifier];
    if ( cell == nil )
    {
        // Initialize one if we don't have a re-usable one lying around, like the grocery bags you leave in the car and forget to take into the shop when you need them
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseableTableViewCellIdentifier];
    }
    
    cell.textLabel.text = self.favoriteRestaurants[indexPath.row];
    // A more clear (and old) way of writing this could look like this:
    // cell.textLabel.text = [self.favoriteRestaurants objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -- TableView Editing (Insertion, Deletion, Reordering) Methods --

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _isInsertingNewRestaurant )
    {
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleInsert )
    {
        // Code to handle insertion
        _isInsertingNewRestaurant = NO; // Reset our editing state
        NSMutableArray* mutableRestaurants = [NSMutableArray arrayWithArray:self.favoriteRestaurants];
        NSInteger insertedRowPosition = ( indexPath.row + 1 );
        [mutableRestaurants insertObject:@"Dunkin Donuts" atIndex:insertedRowPosition]; // We'll insert our new fave *after* our selected row

        // TODO: Show an alert to ask the user for their favorite restaurant
        // (which is probably still Dunkin Donuts, but it's worth checking)
        // See https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html for an example
        self.favoriteRestaurants = [NSArray arrayWithArray:mutableRestaurants];
        
        // The actual indexPath at which we insert the object is one up, so reload only that one
        NSIndexPath* insertedIndexPath = [NSIndexPath indexPathForRow:insertedRowPosition inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[insertedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        // Code to handle deletion
        NSMutableArray* mutableRestaurants = [NSMutableArray arrayWithArray:self.favoriteRestaurants];
        [mutableRestaurants removeObjectAtIndex:indexPath.row];
        self.favoriteRestaurants = [NSArray arrayWithArray:mutableRestaurants];
        
        // Fade our rows out of sight our tableview
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView setEditing:NO animated:YES];
}

#pragma mark -- Reordering --
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray* mutableRestaurants = [NSMutableArray arrayWithArray:self.favoriteRestaurants];
    id movingRestaurant = [mutableRestaurants objectAtIndex:sourceIndexPath.row];
    [mutableRestaurants removeObjectAtIndex:sourceIndexPath.row];
    [mutableRestaurants insertObject:movingRestaurant  atIndex:destinationIndexPath.row];
    self.favoriteRestaurants = [NSArray arrayWithArray:mutableRestaurants];
}

@end
