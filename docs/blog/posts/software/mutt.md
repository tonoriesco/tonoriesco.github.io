---
title: Mutt el rápido
date: 2020-12-15
featured_image: "/images/software/mutt.jpg"
author: Tono Riesco
omit_header_text: true
draft: false
---

# Introducción

Normalmente en mi día a día utilizo máquinas Mac desde hace años pero sigo teniendo que acceder a servidores y máquinas donde no tengo las aplicaciones gráficas habituales como son los editores o el correo electrónico.

Por eso configuro y utilizo vim como editor de texto o mutt como cliente de correo electrónico.

Ninguno de los dos son Plug & Play, no son nada intuitivos a veces y si los acabas de instalar o acceder a ellos no te puedes imaginar que vayan a ayudarte en nada para tu trabajo diario. La verdad es que se pueden encontrar infinidad de artículos y videos en Youtube sobre como usar y configurar las herramientas de consola y demuestran que al no quitar las manos del teclado las tareas se hacen mucho más rápidas.

El problema de mutt es la configuración, drivers, teclados, acentos, pdf, etc.. Cosas que nos encontramos habitualmente en nuestros correos y que no tenemos que configurar porque el mail user agent (MUA) que utilizamos ya lo tiene todo.

Una alternativa es utilizar siempre web services. Esto funciona hasta que solo se tiene una consola de interface, entonces nos damos cuenta que hemos olvidado los comandos y trucos para utilizar los editores o los correos desde la consola.

## Configuración Mutt

Para instalar mutt, lo mejor en Mac es utilizar "brew"

```bash
brew install mutt
```

Ésta es la configuración para un correo externo con imap, smpt, etc. Yo utilizo un directorio en mi home que hay que renombrarlo :

```bash
/Users/tono/.mutt
```

Dentro del directorio se puede poner todo en un fichero llamado muttrc o separarlo en ficheros para cada cosa. Yo creo que es una solución mejor porque se pueden hacer diferentes configuraciones para el trabajo, personal, etc. Y utilizarlas dependiendo del correo que se quiera leer.

### muttrc

Este es el principal y en el que se incluyen todos los demás:

```bash
source ~/.mutt/colors.solar
source ~/.mutt/muttrc.trabajo
source ~/.mutt/gpg.rc

#set sidebar_visible = yes


set abort_nosubject = no
set mail_check = 60
set timeout = 10
set sort = "reverse-date-received"
# set signature = "~/.mutt/signature"
set copy = no


set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"


set editor=vim
```

### colors.solar

La configuración de colores de mutt que me gusta a mi:

```bash
# vim: filetype=muttrc

#
#
# make sure that you are using mutt linked against slang, not ncurses, or
# suffer the consequences of weird color issues. use "mutt -v" to check this.

# custom body highlights -----------------------------------------------
# highlight my name and other personally relevant strings
#color body          color136        color234        "(ethan|schoonover)"
# custom index highlights ----------------------------------------------
# messages which mention my name in the body
#color index         color136        color234        "~b \"phil(_g|\!| gregory| gold)|pgregory\" !~N !~T !~F !~p !~P"
#color index         J_cream         color230        "~b \"phil(_g|\!| gregory| gold)|pgregory\" ~N !~T !~F !~p !~P"
#color index         color136        color37         "~b \"phil(_g|\!| gregory| gold)|pgregory\" ~T !~F !~p !~P"
#color index         color136        J_magent        "~b \"phil(_g|\!| gregory| gold)|pgregory\" ~F !~p !~P"
## messages which are in reference to my mails
#color index         J_magent        color234        "~x \"(mithrandir|aragorn)\\.aperiodic\\.net|thorin\\.hillmgt\\.com\" !~N !~T !~F !~p !~P"
#color index         J_magent        color230        "~x \"(mithrandir|aragorn)\\.aperiodic\\.net|thorin\\.hillmgt\\.com\" ~N !~T !~F !~p !~P"
#color index         J_magent        color37         "~x \"(mithrandir|aragorn)\\.aperiodic\\.net|thorin\\.hillmgt\\.com\" ~T !~F !~p !~P"
#color index         J_magent        color160        "~x \"(mithrandir|aragorn)\\.aperiodic\\.net|thorin\\.hillmgt\\.com\" ~F !~p !~P"

# for background in 16 color terminal, valid background colors include:
# base03, bg, black, any of the non brights

# basic colors ---------------------------------------------------------
color normal        color241        color234
color error         color160        color234
color tilde         color235        color234
color message       color37         color234
color markers       color160        color254
color attachment    color254        color234
color search        color61         color234
#color status        J_black         J_status
color status        color241        color235
color indicator     color234        color136
color tree          color136        color234                                    # arrow in threads

# basic monocolor screen
mono  bold          bold
mono  underline     underline
mono  indicator     reverse
mono  error         bold

# index ----------------------------------------------------------------

#color index         color160        color234        "~D(!~p|~p)"               # deleted
#color index         color235        color234        ~F                         # flagged
#color index         color166        color234        ~=                         # duplicate messages
#color index         color240        color234        "~A!~N!~T!~p!~Q!~F!~D!~P"  # the rest
#color index         J_base          color234        "~A~N!~T!~p!~Q!~F!~D"      # the rest, new
color index         color160        color234        "~A"                        # all messages
color index         color166        color234        "~E"                        # expired messages
color index         color33         color234        "~N"                        # new messages
color index         color33         color234        "~O"                        # old messages
color index         color61         color234        "~Q"                        # messages that have been replied to
color index         color240        color234        "~R"                        # read messages
color index         color33         color234        "~U"                        # unread messages
color index         color33         color234        "~U~$"                      # unread, unreferenced messages
color index         color241        color234        "~v"                        # messages part of a collapsed thread
color index         color241        color234        "~P"                        # messages from me
color index         color37         color234        "~p!~F"                     # messages to me
color index         color37         color234        "~N~p!~F"                   # new messages to me
color index         color37         color234        "~U~p!~F"                   # unread messages to me
color index         color240        color234        "~R~p!~F"                   # messages to me
color index         color160        color234        "~F"                        # flagged messages
color index         color160        color234        "~F~p"                      # flagged messages to me
color index         color160        color234        "~N~F"                      # new flagged messages
color index         color160        color234        "~N~F~p"                    # new flagged messages to me
color index         color160        color234        "~U~F~p"                    # new flagged messages to me
color index         color235        color160        "~D"                        # deleted messages
color index         color245        color234        "~v~(!~N)"                  # collapsed thread with no unread
color index         color136        color234        "~v~(~N)"                   # collapsed thread with some unread
color index         color64         color234        "~N~v~(~N)"                 # collapsed thread with unread parent
# statusbg used to indicated flagged when foreground color shows other status
# for collapsed thread
color index         color160        color235        "~v~(~F)!~N"                # collapsed thread with flagged, no unread
color index         color136        color235        "~v~(~F~N)"                 # collapsed thread with some unread & flagged
color index         color64         color235        "~N~v~(~F~N)"               # collapsed thread with unread parent & flagged
color index         color64         color235        "~N~v~(~F)"                 # collapsed thread with unread parent, no unread inside, but some flagged
color index         color37         color235        "~v~(~p)"                   # collapsed thread with unread parent, no unread inside, some to me directly
color index         color136        color160        "~v~(~D)"                   # thread with deleted (doesn't differentiate between all or partial)
#color index         color136        color234        "~(~N)"                    # messages in threads with some unread
#color index         color64         color234        "~S"                       # superseded messages
#color index         color160        color234        "~T"                       # tagged messages
#color index         color166        color160        "~="                       # duplicated messages

# message headers ------------------------------------------------------

#color header        color240        color234        "^"
color hdrdefault    color240        color234
color header        color241        color234        "^(From)"
color header        color33         color234        "^(Subject)"

# body -----------------------------------------------------------------

color quoted        color33         color234`
color quoted1       color37         color234
color quoted2       color136        color234
color quoted3       color160        color234
color quoted4       color166        color234

color signature     color240        color234
color bold          color235        color234
color underline     color235        color234
color normal        color244        color234
#
color body          color245        color234        "[;:][-o][)/(|]"    # emoticons
color body          color245        color234        "[;:][)(|]"         # emoticons
color body          color245        color234        "[*]?((N)?ACK|CU|LOL|SCNR|BRB|BTW|CWYL|\
                                                     |FWIW|vbg|GD&R|HTH|HTHBE|IMHO|IMNSHO|\
                                                     |IRL|RTFM|ROTFL|ROFL|YMMV)[*]?"
color body          color245        color234        "[ ][*][^*]*[*][ ]?" # more emoticon?
color body          color245        color234        "[ ]?[*][^*]*[*][ ]" # more emoticon?

## pgp

color body          color160        color234        "(BAD signature)"
color body          color37         color234        "(Good signature)"
color body          color234        color234        "^gpg: Good signature .*"
color body          color241        color234        "^gpg: "
color body          color241        color160        "^gpg: BAD signature from.*"
mono  body          bold                            "^gpg: Good signature"
mono  body          bold                            "^gpg: BAD signature from.*"

# yes, an insance URL regex
color body          color160        color234        "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
# and a heavy handed email regex
#color body          J_magent        color234        "((@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]),)*@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]):)?[0-9a-z_.+%$-]+@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\])"

# Various smilies and the like
#color body          color230        color234        "<[Gg]>"                            # <g>
#color body          color230        color234        "<[Bb][Gg]>"                        # <bg>
#color body          color136        color234        " [;:]-*[})>{(<|]"                  # :-) etc...
# *bold*
#color body          color33         color234        "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
#mono  body          bold                            "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
# _underline_
#color body          color33         color234        "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
#mono  body          underline                       "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
# /italic/  (Sometimes gets directory names)
#color body         color33         color234        "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"
#mono body          underline                       "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"

# Border lines.
#color body          color33         color234        "( *[-+=#*~_]){6,}"

#folder-hook .                  "color status        J_black         J_status        "
#folder-hook gmail/inbox        "color status        J_black         color136        "
#folder-hook gmail/important    "color status        J_black         color136        "
```
  
### muttrc.trabajo

hay tambien un muttrc.personal. Dependiendo de lo que haga, activo uno u otro. Se pueden poner juntos, pero no me gusta. Perfiero tener todo separado.

```bash
set folder = "imaps://imap.trabajo.com:993"
set spoolfile = "+INBOX"
set mbox = "+INBOX"
set postponed = "+Drafts"
set record = "+Sent Items"
set trash = "+Trash"

set from = "direccion@trabajo"
set realname = "Tono Riesco"

# Imap settings
set imap_user = "direccion@trabajo"
set imap_pass = "password_trabajo"

# Smtp settings
set smtp_url = "smtp://login@smtp.trabajo.com:587"
set smtp_pass = "password_trabajo"

set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"

set ssl_use_tlsv1 = yes

set editor=vim
set smtp_authenticators = 'gssapi:login'
```

### muttrc.personal

```bash

set folder = "imaps://mail.personal.com:993"
set spoolfile = "+INBOX"
set mbox = "+INBOX"
set postponed = "+Drafts"
set record = "+Sent"
set trash = "+Trash"


set from = "login@riesco.ch"
set realname = "Tono Riesco"

# Imap settings
set imap_user = "login@riesco.ch"
set imap_pass = "password_personal"

# Smtp settings
set smtp_url = "smtp://login@riesco.ch@mail.personal.com:587"
set smtp_pass = "password_personal"

set ssl_use_tlsv1 = yes
```

### gpg.rc

Por último, el fichero de la configuración de GPG.

```bash
# GPG/PGP
set pgp_sign_as = 91AA7B2B930CD0B83E2DFB2DBF60DA29BA02C961
set crypt_use_gpgme = yes
set crypt_autosign = no
set crypt_verify_sig = yes
set crypt_replysign = yes
set crypt_replyencrypt = yes
set crypt_replysignencrypted = yes
```
