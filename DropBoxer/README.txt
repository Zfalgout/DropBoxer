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
Show a success message upon completion of the upload.
Handle file upload errors.
Replace the checkmarks for the cells with a label that will hold the number of pictures selected.
Add a button to the upload screen to take the user back to the photo library for more uploads.
Create a progress bar.


Nice to haves:
Storing user info in the keychain so he or she doesn't have to log into DB each time the app runs.
Think of a better place for DB authentication.
Allow the user to edit the photo before upload.
