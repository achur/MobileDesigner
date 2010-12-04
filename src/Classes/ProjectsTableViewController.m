//
//  ProjectsTableViewController.m
//  MobileDesigner
//

#import "ProjectsTableViewController.h"
#import "Project.h"

@implementation ProjectsTableViewController

@synthesize delegate;

- initInManagedObjectContext:(NSManagedObjectContext *)context
{
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
		request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name"
																						 ascending:YES
																						selector:@selector(caseInsensitiveCompare:)]];
		
		request.predicate = nil;
		request.fetchBatchSize = 20;
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
										   initWithFetchRequest:request
										   managedObjectContext:context
										   sectionNameKeyPath:@"firstLetterOfName"
										   cacheName:nil];
		
		[request release];
		
		self.fetchedResultsController = frc;
		[frc release];
		
		self.titleKey = @"name";
		self.searchKey = @"name";
	}
	return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
	Project *proj = (Project *)managedObject;
	[self.navigationController popViewControllerAnimated:NO];
	[delegate openProject:proj];
}


@end
