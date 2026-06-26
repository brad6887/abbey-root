# BradCooke.com Content Pipeline

This document defines how information flows from Abbey Root into BradCooke.com.

It serves as the architectural contract between the infrastructure, documentation, AI workflows, and the published website.

---

# Philosophy

The website should never be the source of truth.

Instead, information should originate from the systems that own it, then flow through documentation and AI-assisted workflows before being published.

The pipeline follows this model:

text Configuration       ↓ Structured Data       ↓ Documentation       ↓ AI Assistance       ↓ Website 

Each layer builds upon the previous one.

---

# Guiding Principles

## Single Source of Truth

Every piece of information has one authoritative source.

Examples:

| Information | Source |
|------------|--------|
| Server inventory | Ansible inventory |
| Host configuration | host_vars |
| Group configuration | group_vars |
| Docker configuration | Docker Compose |
| Automation | Ansible playbooks |
| Documentation | Markdown |
| Website navigation | site-structure.md |

Generated files should never become the authoritative source.

---

## Build Once, Use Everywhere

Information should be entered once and reused many times.

For example:

text Inventory         │         ├── Configure server         ├── Homepage         ├── Architecture documentation         ├── AI context         └── Website 

Avoid maintaining duplicate information whenever practical.

---

## Documentation Before Presentation

Documentation exists independently of the website.

The website is simply another way of presenting the documentation.

If the website disappeared tomorrow, the documentation should remain complete.

---

## AI Assists Creation

AI should accelerate work rather than replace understanding.

AI may:

- summarize
- organize
- explain
- generate drafts
- suggest improvements
- produce diagrams
- assist with code

Final technical accuracy remains the responsibility of the repository owner.

---

## Markdown First

Markdown is the preferred interchange format.

Markdown should be readable:

- in GitHub
- in a text editor
- by AI tools
- by website generators

Whenever possible, documentation should be written once in Markdown and reused everywhere.

---

# Content Sources

## Infrastructure

Generated from:

- Ansible inventory
- host_vars
- group_vars
- facts
- templates

Produces:

- Architecture documentation
- Server documentation
- Homepage configuration
- Website content

---

## Docker

Generated from:

- Docker Compose
- Container configuration

Produces:

- Container documentation
- Service documentation
- Website pages

---

## Projects

Written manually.

AI may assist with editing, organization, and summaries.

Produces:

- Project pages
- Portfolio entries
- Documentation

---

## Journal

Written manually.

AI may assist with:

- formatting
- summaries
- editing
- weekly recaps

Produces:

- Journal pages
- Timeline
- Recent updates

---

## Interests

Written manually.

Topics include:

- Music
- Running
- Cooking
- Cocktails
- Travel
- Plants
- Warhammer
- Gaming
- Future hobbies

These pages represent personal experiences and learning.

---

# AI Workflow

The AI development server assists throughout the pipeline.

Potential capabilities include:

- Generate page outlines
- Summarize Git commits
- Generate project write-ups
- Create diagrams
- Produce code examples
- Draft documentation
- Review documentation
- Detect missing documentation
- Generate weekly summaries
- Suggest improvements

The AI server enhances productivity but does not replace source documentation.

---

# Publishing Pipeline

Conceptually the workflow becomes:

text Infrastructure         │         ▼ Git Repository         │         ▼ Markdown Documentation         │         ▼ AI Enhancement         │         ▼ Website Generation         │         ▼ BradCooke.com 

Every improvement made to Abbey Root should naturally move through this pipeline.

---

# Future Automation

Potential automation includes:

- Generate architecture documentation
- Generate inventory pages
- Generate server pages
- Generate Docker documentation
- Summarize Git history
- Generate project timelines
- Produce release notes
- Build diagrams
- Validate documentation
- Publish BradCooke.com

Eventually, publishing the website should become a repeatable automated workflow.

Example:

bash ./publish.sh 

The publish process may eventually:

1. Refresh generated documentation
2. Update architecture
3. Generate AI summaries
4. Build the website
5. Validate links
6. Publish the site

---

# Manual vs Generated Content

## Manually Maintained

- Project documentation
- Journal entries
- Personal interests
- Design decisions
- Lessons learned

---

## AI Assisted

- Editing
- Summaries
- Diagrams
- Draft articles
- Documentation improvements
- Project write-ups

---

## Automatically Generated

- Architecture documentation
- Inventory summaries
- Homepage configuration
- Server inventory
- Website navigation data
- Generated indexes

Generated files should never be edited manually.

---

# Long-Term Vision

Abbey Root should become a self-documenting platform.

Changes made to infrastructure should naturally produce updated documentation.

Documentation should naturally feed AI workflows.

AI should assist in transforming documentation into polished website content.

BradCooke.com becomes the public presentation of the work already taking place inside Abbey Root.

The goal is to spend time building, learning, and documenting—not repeatedly copying information between systems.

Build once.

Document once.

Reuse everywhere.
