---
title: "Abbey Root Leaves the House"
description: "AbbeyRoot.com moved from an internal sites01 release to its first public, HTTPS-served home."
date: 2026-08-12
session_update: "docs/session-updates/2026-08-12-abbeyroot-com-public-launch.md"
tags:
  - abbey
  - abbeyroot-com
  - publishing
  - sites01
  - infrastructure
---

# Abbey Root Leaves the House

AbbeyRoot.com is public.

It still needs work, which is probably the most honest possible state for an
Abbey website to launch in. The point was not to declare the project finished.
The point was to give it a real home and stop treating the website like a
permanent internal preview.

The site now running at AbbeyRoot.com is the rebuilt version that separates
Abbey from BradCooke.com. BradCooke.com keeps the personal projects, Orchid
Rescue, the Museum, and its own new journal. AbbeyRoot.com keeps Abbey's
engineering story and the complete historical journal that shows how those
sites grew together and eventually split apart.

That history matters. Moving every old entry into a perfectly classified final
home would make the result cleaner, but it would also erase the development
path. The Abbey journal is allowed to show its seams.

The deployment followed the release workflow Abbey gained earlier today.

On `ubuntu-dev01`, Abbey built 158 pages, validated the home page and journal,
checked the remote target, and previewed the transfer without changing
anything. The real publish then uploaded the generated site into a timestamped
release on `sites01`, compared the remote files with the artifact that had
already passed validation, and moved the `current` symlink only after they
matched.

The active release became:

`/srv/www/abbeyroot.com/releases/20260812T234126Z`

The original bootstrap release stayed in place as the rollback target.

Publishing the files was only half of making the site public. The domain still
pointed at Hostinger, while `sites01` was intentionally available only inside
the lab.

The public path now runs through the existing edge:

`abbeyroot.com -> home router -> Nginx Proxy Manager -> sites01`

Nginx Proxy Manager accepts `abbeyroot.com` and `www.abbeyroot.com`, terminates
HTTPS with a Let's Encrypt certificate, redirects plain HTTP to HTTPS, and
forwards the request to native nginx on `sites01`. The router still exposes
only ports 80 and 443 to the proxy host. The management interfaces and SSH did
not become public just because the website did.

There was one very small piece of archaeology during the DNS cutover. The old
A record had a 50-second TTL, but Hostinger's current editor requires at least
60 seconds. Ten additional seconds of patience was the price of progress.

Both public names now resolve to the reverse proxy. The proxy returns the
deployed Abbey site over HTTP/2, and the HTTP version redirects to HTTPS.

This is not the final AbbeyRoot.com design. It is the first version with the
right responsibilities, the right content boundary, and a deployment path I
trust.

That is enough to put it on the internet.
