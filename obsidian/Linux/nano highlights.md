https://ourcodeworld.com/articles/read/796/how-to-enable-syntax-highlighting-for-yaml-yml-files-in-gnu-nano
## 1. List available Nano Syntax Highlight Files

As first step, discover which languages are available in nano to highlight its syntax with the following command:

```batch
ls /usr/share/nano/
```

Copy snippet

This will list all the nano syntax highlighting files in the given directory:

```markup
root@server:~$ ls /usr/share/nano/
asm.nanorc     fortran.nanorc   man.nanorc     ocaml.nanorc   ruby.nanorc
awk.nanorc     gentoo.nanorc    mgp.nanorc     patch.nanorc   sh.nanorc
c.nanorc       groff.nanorc     mutt.nanorc    perl.nanorc    tcl.nanorc
cmake.nanorc   html.nanorc      nano-menu.xpm  php.nanorc     tex.nanorc
css.nanorc     java.nanorc      nanorc.nanorc  pov.nanorc     xml.nanorc
debian.nanorc  makefile.nanorc  objc.nanorc    python.nanorc
```

Copy snippet

If you don't find the yaml.nanorc file, then you can install it with the next step.

## 2. Create YAML Nano Syntax Highlighting File

In order to provide syntax highlighting to your file, if the default file doesn't exist, you need to create the syntax highlighting file for this language. This file is the `yaml.nanorc` file and you need to create it in the mentioned directory. Run nano to create the file:

```batch
sudo nano /usr/share/nano/yaml.nanorc
```

Copy snippet

and paste the following content:

```bash
# Supports `YAML` files
syntax "YAML" "\.ya?ml$"
header "^(---|===)" "%YAML"

## Keys
color magenta "^\s*[\$A-Za-z0-9_-]+\:"
color brightmagenta "^\s*@[\$A-Za-z0-9_-]+\:"

## Values
color white ":\s.+$"
## Booleans
icolor brightcyan " (y|yes|n|no|true|false|on|off)$"
## Numbers
color brightred " [[:digit:]]+(\.[[:digit:]]+)?"
## Arrays
color red "\[" "\]" ":\s+[|>]" "^\s*- "
## Reserved
color green "(^| )!!(binary|bool|float|int|map|null|omap|seq|set|str) "

## Comments
color brightwhite "#.*$"

## Errors
color ,red ":\w.+$"
color ,red ":'.+$"
color ,red ":".+$"
color ,red "\s+$"

## Non closed quote
color ,red "['\"][^['\"]]*$"

## Closed quotes
color yellow "['\"].*['\"]"

## Equal sign
color brightgreen ":( |$)"
```

Copy snippet

[Visit the official repository of Nano Highlight](https://github.com/serialhex/nano-highlight), a spiffy collection of nano syntax highlighting files for more information and languages available for nano. This file will be automatically added into nano and will highlight yaml files. Save changes and proceed with the last step.

## 3. Create Test Yaml File to see results

As final step, you need to test wheter the highlight works or not. Proceed to create a test file with nano and write some YAML on it, for example:

```yaml
# app/config/config_prod.yml
imports:
    - { resource: config.yml }

monolog:
    handlers:
        main:
            type:         fingers_crossed
            action_level: critical
            handler:      grouped
        grouped:
            type:    group
            members: [streamed, deduplicated]
        streamed:
            type:  stream
            path:  '%kernel.logs_dir%/%kernel.environment%.log'
            level: debug
        deduplicated:
            type:    deduplication
            handler: swift
        swift:
            type:       swift_mailer
            from_email: 'from_email@test.com'
            # Or multiple receivers:
            # to_email:   ['to_email1@ourcodeworld.com', 'to_email2@ourcodeworld.com']
            to_email:   'to_email@ourcodeworld.com'
            subject:    'An Error Occurred! %%message%%'
            level:      debug
            formatter:  monolog.formatter.html
            content_type: text/html
```

Copy snippet

Save the file, edit it again and you will now see the YAML code highlighted.