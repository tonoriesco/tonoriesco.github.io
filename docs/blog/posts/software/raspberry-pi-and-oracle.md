---
title: Raspberry Pi and Oracle
date: 2013-11-14
featured_image: "/images/posts/rpi-java.jpg"
author: Tono Riesco
omit_header_text: true
---

Long time working with the Raspberry Pi and having a lot of interfaces I didn't find anywhere how to make requested to the Oracle DB from the OS Raspbian.

Here are my experiences:

Install Raspbian as usual. There is thousand of how to all around.

Install Java SDK (I'm not a fan of Java... But I didn't find another system.)  The OCI libraries from Oracle doesn't work on ARM architectures. Now Java SDK is in the raspbian repositories.

I've been using [Instant Client](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html) from Oracle on Debian host without problems but there are not drivers for Raspbian yet.

I'm using always root to avoid using sudo for all commands!

```bash
root@host:~# apt-get install oracle-java7-jdk
```

Get the [ojdbc7 driver](http://www.oracle.com/technetwork/database/features/jdbc/jdbc-drivers-12c-download-1958347.html) from Oracle

Test that java is working well with:

```bash
root@host:~# java -version
java version "1.7.0\_40" Java(TM) SE Runtime Environment (build 1.7.0\_40-b43) Java HotSpot(TM) Client VM (build 24.0-b56, mixed mode)
```

Write a file **Conn.java** with the following code:

```java

import java.sql.\*; 
class Conn { public static void main (String\[\] args) throws Exception { Class.forName ("oracle.jdbc.OracleDriver");

Connection conn = DriverManager.getConnection ("jdbc:oracle:thin:@//ip\_or\_dns\_name\_of\_oracle\_server:port\_server/SID\_Database", "login\_database", "password\_database"); 

// @//machineName:port/SID,   userid,  password try { Statement stmt = conn.

createStatement(); 
try { ResultSet rset = stmt.executeQuery("select BANNER from SYS.V\_$VERSION");
try { while (rset.next()) System.out.println (rset.getString(1));   } 
finally {
    try { rset.close(); } 
    catch (Exception ignore) {} 
    }
    } finally { try { stmt.close(); } catch (Exception ignore) {} } } finally { try { conn.close(); } catch (Exception ignore) {} 
    }
    }
    }
```

Now, you can compile with:

```bash
javac  Conn.java
```

and run with:

```bash
java -cp /wherever\_you\_put\_the\_file/ojdbc7.jar:. Conn\
```

---

# Comments

### Bilal Inamdar on 02/10/2014 at 21:04

So what exactly will happen With this ?

See i have a similar problem just that i am using Beaglebone and it is arm debian so on there i want to
install instant client to use with PHP
target db is 11g can you help me with that ? please suggest something

### Tono on 03/10/2014 at 14:02

Well… suggest something… Probably, if you change to RPi instead of using the Beaglebone? 😉
Honestly, I cannot help you because I don’t know anything about this card, or the operating system.
If as you said, is a arm debian, I don’t understand why will not work my solution in your hardware if is just software!!
Regards.

---

### Will on 09/03/2015 at 16:47

I keep getting an error when I run
javac /home/pi/Desktop/Conn.java
The error message I get is:
javac: invalid flag: /home/pi/Desktop/Conn.Java
Usage: javac
use -help for a list of possible options

### Tono on 09/03/2015 at 16:56

Well… is strange… For me works….
Did you install the instant client? Java? Did you test with:

    java -version ?

I’m not an expert in java, honestly, but this error can came for thousand of things. Starting with a mistake in a word written on the code till some missing libraries…

Sorry but I cannot help you with java, the only thing that I can assure you is that the code works (right now is working) and connecting.

Regards.

---

### Belganon on 20/07/2017 at 11:39

Old post but It’s still working ♥

---

### Pawel on 28/11/2017 at 23:10

Hi,
The above procedure works as expected. However, any idea how to add mqtt client into You code? I have installed Mosquitto MQTT on Pi and I can publish it using mosquitto_pub but I have no idea how to put that into the above java code? Alternativelly, is there any way to use node.js with above code? Meaning use jdbc connection from jode.js? Normally I’d use oracledb but no such thing available for arm 🙁