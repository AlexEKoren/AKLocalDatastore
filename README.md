# AKLocalDatastore

For an app of mine I wrote my own sync library with querying capability to interface with Parse. However, that got really confusing and it was right around the time Parse Local Datastore came out. The only problem with Local Datastore is that it doesn't allow you to pin the data associated with PFFiles, only the pointer to them which lets you download them at a later date.

With that in mind, I built a small helper category to extend the functionality of PFObjects and basically download the data the first time you ask for the file, but keep it stored safely for any subsequent request. This will persist through any app closes or terminations, as long as the file was successfully downloaded. If not, it will just try to redownload it.

To enable this functionality, just add my PFObject+AKLocalDatastore.h and PFObject+AKLocalDatastore.m files to your project.

When you get a PFObject, here's what you need to do:

1. Set the name of the column that points to the objects PFFile: object.fileColumnName = @"File";
2. call "-(void)getFileDataWithBlock:(void(^)(NSData* fileData, AKFileDataRetrievalType retrievalType))block" and in that block do whatever you want with "fileData."

It's that easy!

In my demo project you'll see in the AppDelegate that I quickly just download all the files in one of my classes and pin them. You can do this whenever you want. The class I used had 2 columns: Name(String) and Image(File).

I then call reloadData in my AKTableViewController which does a Local Datastore query to find all the objects that have just been pinned.

In my AKTableViewControllers "cellForRowAtIndexPath" method, I get the object at that indexPath from my queried objects, set the column name of that object to "Image" (because that's where my file is) and then set an AKTableViewCell's object to that object.

Finally, in my AKTableViewCell's "setObject" method, I use the "Name" column to put a title on the cell and then load in the Image using my "getFileDataWithBlock" method. I also use the retrieval type to tell the user how the data was retrieved.

If you download my demo project and use your own Parse ID's and your own class and plug in all of the Parse Class Names and Column Names, you will be able to load them all into the AKTableViewController and then reload them by tapping the last cell. Tapping the last cell will trigger it to load from cache. The very first time you open the app the data will be from the parse database, and every time you open the app after that, it will be initially loaded from the local directory.

Tweet at me if you have any questions: @AlexEKoren

Enjoy!