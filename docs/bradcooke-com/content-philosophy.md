# BradCooke.com Content Philosophy

BradCooke.com should be built from reusable Markdown content, not from hand-edited website pages.

The goal is to create a publishing pipeline where content can be written once, improved with AI where useful, and reused across multiple outputs.

## Core Principle

Markdown is the source of truth.

The website is an output.

Generated files are disposable.

## Content Flow

Infrastructure becomes generated documentation.

Generated documentation becomes Markdown content.

Markdown content may be enhanced with AI.

Enhanced Markdown becomes the website.

Over time, the same Markdown source may also generate RSS feeds, PDFs, search indexes, project summaries, release notes, newsletters, and social posts.

## Repository Roles

### ansible/

Infrastructure as Code.

This contains inventory, roles, playbooks, templates, variables, and automation used to manage the lab.

### docs/

Technical documentation for Abbey Root.

This includes infrastructure notes, generated documentation, status updates, backup documentation, and internal design decisions.

### content/

Public-facing source material for BradCooke.com.

This contains Markdown content that may eventually become website pages, articles, journal entries, project pages, or other published material.

### homepage/

Configuration for the internal lab dashboard.

Homepage is not BradCooke.com. It is a lab service managed by Ansible.

## Content Directory Purpose

The content directory is a publishing source, not simply a website folder.

Content should be organized by topic or purpose.

Current examples:

- abbey-root

- aix

- cooking

- interests

- journal

- linux

- music

- notes

- pages

- plants

## Pages vs Topics

### pages/

Timeless site pages.

Examples:

- About

- Now

- Uses

- Contact

- Projects

### journal/

Chronological updates and project logs.

### abbey-root/

Public-facing articles and summaries about the Abbey Root lab.

### linux/, aix/, plants/, music/, cooking/

Topic-based writing areas.

These may eventually become sections of BradCooke.com.

## AI Responsibilities

AI may assist with:

- Rewriting rough notes into readable drafts

- Creating summaries

- Suggesting titles

- Creating descriptions

- Generating metadata

- Suggesting internal links

- Creating image alt text

- Drafting release notes

- Detecting stale content

- Producing alternate formats

AI should not replace the source of truth.

Human-authored Markdown remains the canonical content.

## Generated Content Rules

Generated output should be treated as disposable.

Do not manually edit generated website files.

If something needs to change, update the source Markdown, templates, scripts, or automation.

Then regenerate the output.

## Publishing Philosophy

BradCooke.com should grow gradually.

The first goal is not to build a perfect website.

The first goal is to create a working end-to-end publishing pipeline:

Markdown -> Build Process -> Generated Site

Once that works, the pipeline can be improved.

Working beats pretty.

Reproducible beats manual.

Markdown first.

## Content Discovery Model

BradCooke.com will use a hybrid content discovery model.

Folders determine organization by default.

Metadata customizes behavior only when needed.

Example:

A file stored as:

content/plants/lady-madonna.md

would naturally become:

/plants/lady-madonna/

Most content should not require any special configuration.

Metadata (front matter) may be added later for optional information such as:

- title
- description
- date
- tags
- featured
- draft
- menu
- weight

The guiding rule is simple:

Folders define the structure.

Metadata customizes the behavior.

The default path should always work without requiring metadata.
