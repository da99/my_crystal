

lib vs app
==========

Only difference is `lib` adds `shard.lock` to `.gitignore`.

Notes
======

* SHARDS\_INSTALL\_PATH must be an absolute path: $PWD/my/dir
  because the value is used outside of target directory.

* cat diff | grep -v -i -P "vlc|webkit|xdg|xdm|xorg|lossless|screen|thunar|XFCE|gnome|mate|volume|vorbi|usb|totem|sound|qt5|cutter|python|ruby|lightdm|cinnam" >/tmp/crystal

* Reading a request body: https://stackoverflow.com/questions/45414568/read-request-body-without-deleting-it


Snippets
========

* Stopping a dev server when the spawning process dies:
```crystal
pid = ENV["CONTROLLER_PID"] # pass this value from the shell script

spawn {
  loop {
    system("kill -0 #{pid}")
  is_alive = $?.normal_exit? && $?.exit_code == 0

  if !is_alive
    puts "=== Process gone: #{pid}. Exiting."
    server.close
    break
  end
  }
}

```
