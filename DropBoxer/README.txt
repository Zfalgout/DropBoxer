Dropboxer

This app was built and designed to allow a user to pick one or multiple photos from his or her photo library and upload them to their Dropbox account.

InitialVC:
    This was built to accomodate asking the user for permission to his or her photo library.  Before this view was in place, the first time a user logged in, the SavedPhotosVC would load before the user gave permission, meaning that the collection view would be empty.  It also allows me to display a message to the user if he or she has not approved DrobBoxer for access to the phone's photo library.   This could also give me an opportunity in the future to add an animation to the logo before the app 'loads' (from a user's point of view).

SavedPhotosVC:
    This view allows the users to select their photos for upload.  It utilizes an instance of PhotoLibraryVM to access the photo library.  There's a current limit to 20 photos for upload.  I wanted to give the users the ability to upload more than one, but allowing the user to upload all of their photos could lead to issues and I didn't have the bandwidth to test.

UploadVC:
    This is the final view for the user in the upload flow.  It utilizes an instance of DropboxVM to authroize the user and upload the photos.  After the upload is complete, the user is prompted with a button to take him or her back to the previous screen.

PhotoCell and RoundedButtonView :
    Both of these are responsible for setting the UI for the cells in the collection view and buttons respectively.

StatefulImage:
    I originally was just passing straight photos to the array used to fill the ImageViews inside of each cell.  This worked up until I added a checkmark to the selected cells.  An issue came up when a user would select a photo and then scroll them off the screen.  Because cells are reused in collection views, the selected cells would lose their checkmarks.  I needed a way to hold state, so I created this class.  It just holds a photo and a boolean value to determine if the photo had been selected so far.

DropboxVM:
    This is the file used for connecting and uploading to Dropbox.  This extracts all of this functionality from the view controllers to something more centralized.

PhotoLibraryVM:
    This is the file used for accessing the phone's photo library.  This extracts all of this functionality from the view controllers to something more centralized.


TODO:

Nice to haves:
Give the user some indication that work is being done after he or she clicks the upload button and before the progress circle gets animated.
Storing user info in the keychain so he or she doesn't have to log into DB each time the app runs.
Think of a better place for DB authentication.
Allow the user to edit the photo before upload.
Possibly show a message if the user doesn't have any photos in their photo library when they open the app.
