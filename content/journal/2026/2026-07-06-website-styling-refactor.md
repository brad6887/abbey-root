---
title: "Website Styling Refactor"
description: "Website Refactor to use modualr CSS architecture"
date: 2026-07-06
draft: false
tags:
  - Abbey Root
  - website
  - astro
  - css
  - styling
  - frontend
  - refactor
---

# Website Styling Refactor

## Summary

Refactored the Abbey Root website to use a modular CSS architecture. Styling is now organized into dedicated stylesheet files instead of being embedded within Astro components, providing a cleaner separation of presentation and application logic. The session also introduced a shared design foundation with automatic light/dark mode support and initial mobile-responsive improvements.

## Accomplishments

- Created a dedicated `site/src/styles/` directory.
- Added `global.css` for shared typography, colors, and global styling.
- Added `navigation.css` for site navigation styles.
- Added `layout.css` for page layout styling.
- Added `project.css` for project pages and project cards.
- Updated `Layout.astro` to import the shared stylesheets.
- Removed embedded `<style>` blocks from Astro components and layouts.
- Added automatic light/dark mode support using `prefers-color-scheme`.
- Improved mobile responsiveness for navigation and project metadata.
- Verified the website builds successfully after the refactor.

## Lessons Learned

- Centralizing styles makes Astro components easier to read and maintain.
- CSS custom properties provide a simple foundation for consistent theming.
- Validating with a production build after structural refactoring helps catch issues such as leftover embedded CSS before they become larger problems.

## Next Steps

- Review the site on desktop, tablet, and mobile screen sizes to identify additional responsive improvements.
- Consider adding a user-selectable light/dark mode toggle in addition to automatic system preference detection.
- Continue refining typography, spacing, and component styling as additional pages are developed.
- Establish a consistent visual design system for future website enhancements.
