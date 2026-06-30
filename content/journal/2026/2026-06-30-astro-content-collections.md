# Astro Content Collections and the First Publishing Pipeline

Today marked an important shift in the Abbey Root project. Rather than simply learning Astro, I began integrating it into the long-term publishing architecture for BradCooke.com.

## Goals

- Learn the fundamentals of Astro.
- Preserve the Single Source of Truth philosophy.
- Begin building a content-driven website instead of a page-driven website.

## Accomplishments

### Learned Astro Fundamentals

Built the first Astro pages and learned the core concepts:

- Pages
- Layouts
- Components
- Routing
- Front matter
- Hot reload during development

Created a reusable Layout.astro and Nav.astro component to eliminate duplicated page structure.

### Configured Content Collections

Configured Astro Content Collections to use the repository's external content/ directory instead of storing content inside the Astro project.

This allows Markdown to remain the authoritative source while Astro becomes the rendering engine.

Added schema validation requiring publishable pages to include metadata such as:

- title
- description

This ensures content is validated during the build process rather than allowing incomplete pages to be published.

### First Markdown-Driven Pages

Converted the following pages to render directly from Markdown:

- About
- Projects

The page flow is now:

text content/pages/about.md         ↓ Astro Content Collection         ↓ getEntry()         ↓ render()         ↓ Layout         ↓ Generated HTML 

This successfully separates content from presentation.

## Lessons Learned

One useful lesson came from troubleshooting the initial implementation.

The first issue was caused by the Astro development server using a stale content index after changing the content collection configuration. Restarting the development server rebuilt the content graph and resolved the problem.

The second issue resulted from an Astro 7 API change. The previous page.render() method has been replaced with the newer render(page) helper.

Both issues reinforced the value of debugging one layer at a time rather than guessing.

## Architectural Direction

Today's work confirmed the desired long-term architecture:

text Markdown         ↓ Content Collections         ↓ Astro         ↓ Generated Static Website 

The website should consume content rather than contain content.

## Next Steps

- Replace the individual page wrappers with a single dynamic route.
- Generate pages automatically from Markdown.
- Begin generating navigation from content.
- Continue evolving the publishing pipeline toward automated BradCooke.com deployments.
