# Notification system API specification

Assignee: Bojan

## Overview

Notification should be implemented as a single method on `User` model. Suggestion: 

```ruby
class User
    def post_notifications(title, content, link)
        # send notifications
    end
end
```

`title` and `content` should be pretty self-explanatory. `link` means a link that takes the user directly to a web page that is related to the notifications (for example, the page of the voucher being approved, or the page of the user's job balance histroy page in the case of his job balance being changed). 

This method should send notifications in all the means that the User selected to accept. For example, if the User chose to accept notifications through both SMS and email, this method should both send an SMS and send an email. The caller or `User#post_notifications` should not need to care about the actual types of notifications being sent. 

Example run (yeah, right, this is my still-not-submitted-yet-and-probably-will-never-be-able-to-get-the-money-back voucher): 

```ruby
bro = User.find_by(name: 'Jiahao Li')

bro.send_notifications('Your voucher has been approved by Richard Hsu. ', 
    'Your voucher "Spring Rush Toscanini Voucher" has been approved by Richard Hsu. \ 
    You will be sent 70$. ', 
    vouchers_path(123))
```

## Technical Aspect

Since sending SMS and sending email could both take an unpredictable amount of time (network calls to APIs might be slow), sending notifications should be implemented as async background process. 

To do this, [Resque](https://github.com/resque/resque) seems to provide a really easy way to accomplish this. Check it out. Also, [twilio-ruby](https://github.com/twilio/twilio-ruby) seems also really helpful with sending SMSs through Twilio. 

Therefore, `User#post_notifications` should simply queue job(s) into Resque, and then immediately return, without waiting for the actual sending to finish. 