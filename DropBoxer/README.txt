Dropboxer

Architecture:

Dropboxer uses an MVVM architecture.  The views and associated view controllers as slim and rely on the underlying view
models to do all of the heavy lifting.  DropboxVM.swift is the file responsible for handling all calls associated with
Dropbox.

SavedPhotosVC.swift is the main view that the user interacts with.  It is what displays the user's photo library and is
the delegate for the UIImagePickerController class that handles the user's photo library.  

The first time the app is launched, the user is prompted to allow DropBoxer to have access to the photos on the phone.
This means that the functionality to grab the photos fails the first time.  After that it works.  Need to figure it
out.

TODO:
Create another initial VC that will mimic the launch screen.  This is where the user will be asked for permission for
the app to access photos.  It will also give me a chance to add some animation to the launch.


Nice to haves:
Storing user info in the keychain so he or she doesn't have to log into DB each time the app runs.
Think of a better place for DB authentication.
Allow the user to edit the photo before upload.
Update the progress circle color to match the checkmark of the success message.
