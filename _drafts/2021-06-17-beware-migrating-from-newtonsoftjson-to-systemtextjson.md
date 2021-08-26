---
layout: post
title: Beware - Migrating From Newtonsoft.Json To System.Text.Json
date: 2021-06-17 08:43:26 +0300
categories:
    - System.Text.Json
published: false
---
1. Remove usings to Newtonsoft
2. JsonProperty change
3. JsonConveter change
4. internal properties are not serialized
5. Delimited properties are not serialized correctly

