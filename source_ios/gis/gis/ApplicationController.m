
#import "ApplicationController.h"
#import "SebesApplication.h"

@interface ApplicationController ()

@end

@implementation ApplicationController

@synthesize delegate = _delegate;

- (void) setGroupes:(NSMutableArray *)groupes
{
    _groupes = groupes;
}

- (NSMutableArray *) groupes
{
    return _groupes;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 44.0;
	self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    SebesApplication * app = [self.groupes objectAtIndex:indexPath.row];
    
    NSString *color = app.name;
    cell.textLabel.text = color;
    
	cell.textLabel.textColor = [UIColor whiteColor];
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate != nil) {
        SebesApplication * app = [self.groupes objectAtIndex:indexPath.row];
        [_delegate applicationSelected:app ];
    }
}

@end
