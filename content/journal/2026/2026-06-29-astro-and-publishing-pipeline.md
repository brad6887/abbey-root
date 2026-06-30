# Abbey Root Journal

Date: 2026-06-29

# Astro and the Publishing Pipeline

Today marked the beginning of the BradCooke.com publishing platform.

Rather than immediately building a website, the focus was on defining the architecture that will support the site for years to come.

## Major Accomplishments

### Defined the Publishing Architecture

Established the separation between infrastructure, documentation, content, and presentation.

text ansible/     Infrastructure as Code  docs/     Technical documentation  content/     Publishing source  site/     Astro website project 

This reinforces the Single Source of Truth philosophy used throughout Abbey Root.

### Established the Content Philosophy

Created documentation describing how content should flow through the system.

Key principles include:

- Markdown is the source of truth.
- Generated artifacts are disposable.
- The website is an output, not the primary source.
- AI enhances content but does not replace the original Markdown.

### Hybrid Content Discovery

Decided on a hybrid publishing model.

By default:

- Folder structure determines website organization.
- Metadata customizes behavior only when necessary.

Example:

text content/plants/lady-madonna.md 

naturally becomes:

text /plants/lady-madonna/ 

without requiring additional configuration.

### Created the First Publishing Prototype

Developed the first proof-of-concept website builder.

Current workflow:

text content/       ↓ tools/build-website.sh       ↓ website/ 

Although intentionally simple, it demonstrates the complete end-to-end publishing pipeline.

### Introduced Astro

Installed:

- Node.js 24 LTS
- npm
- Astro

Created the initial Astro project on ubuntu-dev01 and verified the development server was running successfully.

The initial Astro page was successfully viewed from another system on the network.

## Architectural Decisions

Responsibilities are now divided between systems.

### rocky-ansible01

- Git repository
- Ansible
- Documentation
- Content generation
- Repository management

### ubuntu-dev01

- Node.js
- npm
- Astro
- Website development
- Website preview and build

### ai-worker01

Future responsibilities include:

- AI-assisted editing
- Content enhancement
- Metadata generation
- Summaries
- Publishing assistance

## Lessons Learned

Modern static site generators are fundamentally different from manually authored HTML websites.

Instead of writing HTML directly:

text Markdown         ↓ Astro         ↓ HTML 

Astro generates traditional static HTML while providing reusable layouts, components, and automation.

This preserves the simplicity of static websites while dramatically improving maintainability.

## Next Steps

- Integrate Astro with the external content/ directory.
- Learn Astro layouts and components.
- Replace the prototype HTML generator with an Astro-based build process.
- Continue treating Markdown as the canonical publishing source.
- Begin generating the first real BradCooke.com pages.

## Looking Ahead

Today represents the transition from building infrastructure to building the publishing platform that will ultimately power BradCooke.com.

The long-term vision remains:

text Infrastructure         ↓ Generated Documentation         ↓ Markdown         ↓ AI Enhancement         ↓ Astro         ↓ BradCooke.com 

The architecture now has a solid foundation, allowing future work to focus on content, automation, and AI-assisted publishing rather than restructuring the project.
