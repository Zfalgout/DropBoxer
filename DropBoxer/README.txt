Dropboxer

Architecture:

Dropboxer uses an MVVM architecture.  The views and associated view controllers as slim and rely on the underlying view
models to do all of the heavy lifting.  DropboxVM.swift is the file responsible for handling all calls associated with
Dropbox.

SavedPhotosVC.swift is the main view that the user interacts with.  It is what displays the user's photo library and is
the delegate for the UIImagePickerController class that handles the user's photo library.  

The first time the app is launched, the user is prompted to allow DropBoxer to have access to the photos on the phone.
This means that the functionality to grab the photos fails the first time.  After that it works.  Need to figure it out.

TODO:
Add check marks to the cells when a user clicks on them.
Handle file upload errors.
Figure out a limit for the number of photos that can be uploaded at once.
Show a success message upon completion of the upload.
Add a button to the upload screen to take the user back to the photo library for more uploads.
Create a progress bar.


Nice to haves:
Storing user info in the keychain so he or she doesn't have to log into DB each time the app runs.
Think of a better place for DB authentication.
Allow the user to edit the photo before upload.
