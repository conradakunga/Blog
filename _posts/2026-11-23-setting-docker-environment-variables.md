---
layout: post
title: Setting Docker Environment Variables
date: 2026-11-23 19:36:02 +0300
categories:
    - Docker
---

In a previous post, "[Setting Time Zones In Your Docker Containers]({% post_url 2026-11-18-setting-time-zones-in-your-docker-containers %})", we looked at how to set the **timezone** in a **container** so as to ensure that the **host and the container are using the same timezone**.

It looked like this:

```json
services:
  mysql:
    image: mysql:latest
    container_name: mysqldemo
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mystrongpassword123
      MYSQL_DATABASE: testdb
      TZ: Africa/Nairobi
    ports:
      - "3307:3306"
```

The variable we are setting here is this one:

```yaml
TZ: Africa/Nairobi
```

Which is usually good enough.

The problem arises when you have **multiple containers**, all of which you need to have the **same timezone**.

It can get **tedious** having to set it manually, not to mention **error prone**, from **typos**.

It is also a nightmare if you need to change **all of them.**

A solution to this is to use a [.env](https://upsun.com/blog/what-is-env-file/) file, that you keep the root of the folder with your `docker-compose.yaml`

Within this, setup your variables, on per line.

```c#
TZ=Africa/Nairobi
```

Then in your `docker-compose.yaml`, specify the timezone as follows:

```yaml
 - TZ=${TZ}
```

This bit, `${TZ}` gets evaluated when you start your container.

When you startup your container, the engine will replace the bit between the **placeholders** with the value from the `.env` file.

If I ever need to change my timezone, **I can do it in one place**.

This is especially handy when you have a `docker-compose.yaml` that has **multiple containers**.

### TLDR

**Use an .`env` file to set environmental variables in your `docker-compose.yaml`**

Happy hacking!
