# inbox-notifier

This CLI tool checks a user-configurable directory for the presence of any files, printing them if present.

This is intended to be used as part of a shell startup script to notify the user of files in an inbox directory on shell startup.

Example use case:

- Set `~/dev/inbox` as your inbox
- You're on a plane, create a file at `~/dev/inbox/plane_notes.txt` while offline to write down some thoughts
- Later, when not on the plane, you open up a shell and inbox-notifier notifies you of the presence of `plane_notes.txt` in the inbox, reminding you to move it to your notes app

Usage:

    $ inbox-notifier --dir="~/dev/inbox"

    You have files in your inbox!

    - plane_notes.txt, created on 2020-01-04
