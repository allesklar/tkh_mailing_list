# TKH Mailing List



## 0.11.1.1

* Debugging the admin_mailers layout. Added stylesheet to asset pipeline


## 0.11.1

* Debugged admin mailer layout
* Emphasized email address in list of contact messages in daily digest admin email.


## 0.11

* Admin daily digest emails are also sent in HTML.


## 0.10.10

* Added an invisible field in the contact form to trick spam robots.


## 0.10.9.1

* Fixed dependency bug of admin digest email rake task.


## 0.10.9

* Created an admin daily digest email. The rake task can be called from a cron job.


## 0.10.8

* Removed html_safe method from flash messages in profiles update method. Message is rawified in tkh_toolbox gem.
* Corrected the profile form twitter handle hint.
* Create activity feed item upon profile updates.


## 0.10.7

* Added navigation around show and edit views.
* Debugged public profile.


## 0.10.6

* Added a deprecation notice to the details recource views. Details has been deprecated in favor of the members resource.


## 0.10.5

* Debugged the my profile view when urls are nil.


## 0.10.4

* Fixed a bug in private profile


## 0.10.3

* Added rel-nofollow to public profile links.
* Removed http and https from profile link anchors.
* Debugged and improved public profile view and links.


## 0.10.2

* Imported manually the jcrop files so host application does not need to install any gems.


## 0.10.1

* Private profile viewing and editing
* Public profile view
* User can add portrait photo to their profile and crop it on the fly


## 0.10

* Added a member resource for admins to update user records. Users are scoped as members.
* Added a profile resource for users to view and edit their own info.


## 0.9.2

* Fixed up details user form


## 0.9.1

* Added permissions to details protected attributes.


## 0.9

* Upgraded gem to Rails 4


## 0.0.2

* Added a rake task file and an add_teacher_status migration generator.
* Added a destroy action to the details controller to enable admin to delete users.
* Added generator for locale files.


## 0.0.1

* Initial release
