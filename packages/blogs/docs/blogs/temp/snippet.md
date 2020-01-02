---
title: snippet test
date: 2019-11-08 20:45:35
excerpt: for snippet test perparse
tags:
  - aws
  - serveless
---

## overview
code snipeet is

<<< @/docs/blogs/temp/snip/index.js

## next
with vue path

<<< ./snip/index.js

## gothere
{{$page.path.replace(/[^/]+$/, '')}}

```
<<< {{$page.path.replace(/[^/]+$/, '')}}/snip/index.js
```
