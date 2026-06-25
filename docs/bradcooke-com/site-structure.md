# BradCooke.com Site Structure

This document defines the logical structure of BradCooke.com.

It is the single source of truth for the site's organization and content.

Implementation details (HTML, CSS, Hugo, Astro, Jekyll, etc.) are intentionally excluded from this document.

---

# Vision

BradCooke.com is a personal portfolio and a living journal of the things I build, learn, and enjoy.

Abbey Root is the site's largest ongoing project, documenting my Linux lab, automation, AI workflows, and infrastructure. Alongside it, the site captures other interests—including music, running, cooking, cocktails, travel, plants, gaming, and other hobbies—as opportunities to learn, create, and share.

The common thread is continuous learning. Whether I'm writing an Ansible playbook, composing a song, training for a race, or experimenting with a new recipe, the goal is to document the process, reflect on what I learned, and improve over time.

The site should evolve continuously rather than attempting a perfect initial launch.

---

# Goals

The website should:

- Showcase technical skills.
- Document Abbey Root.
- Serve as a professional portfolio.
- Capture personal projects and hobbies.
- Encourage continuous learning.
- Be AI-assisted wherever practical.
- Be easy to maintain.
- Be generated from reusable content whenever possible.

---

# Primary Navigation

- Home
- About
- Abbey Root
- Projects
- Journal
- Interests
- Resources
- Contact

---

# Home

## Purpose

Provide an overview of who I am and what I'm currently working on.

## Content

- Welcome message
- Featured projects
- Current Abbey Root status
- Recent journal entries
- Latest articles
- Quick links
- Featured photos or screenshots

---

# About

## Purpose

Introduce myself professionally and personally.

## Content

- Professional background
- IT experience
- Technologies
- Linux journey
- AI interests
- Home lab philosophy
- Personal interests
- Current goals

---

# Abbey Root

## Purpose

Document the Linux lab.

This section is the technical heart of the website.

---

## Overview

- Mission
- Architecture
- Infrastructure philosophy
- Current environment
- Future roadmap

---

## Servers

Each server receives its own page.

Example sections

- Purpose
- Operating system
- Hardware or VM information
- Installed software
- Running containers
- Configuration notes
- Lessons learned
- Future improvements

Current servers include

- Proxmox
- ubuntu-dev01
- ai-worker01
- rocky-ansible01

---

## Infrastructure

Topics include

- Networking
- DNS
- Time synchronization
- Templates
- Virtual machines
- Security
- Backup
- Monitoring

---

## Docker

Each container should have documentation covering

- Purpose
- Configuration
- Docker Compose
- Screenshots
- Notes
- Lessons learned

---

## Automation

Topics include

- Ansible inventory
- Roles
- Playbooks
- Templates
- Jinja
- Handlers
- Vault
- Helper scripts
- Automation philosophy

---

## AI

Topics include

- Open WebUI
- Local AI models
- AI workflows
- Prompt engineering
- Website generation
- Documentation generation
- Code generation
- Future AI experiments

---

# Projects

## Purpose

Long-form documentation of significant projects.

Each project should contain

- Overview
- Goal
- Planning
- Implementation
- Challenges
- Lessons learned
- Future ideas

Examples

- Homepage Dashboard
- Automated Documentation
- Website Generation
- Docker Services
- Monitoring
- AI Workflows
- Security Experiments
- Infrastructure as Code

---

# Journal

## Purpose

Chronological updates documenting progress.

Possible entries

- Daily lab work
- Weekly summaries
- Project milestones
- New technologies learned
- Infrastructure changes
- AI experiments
- Successes
- Mistakes
- Lessons learned

Journal entries should be frequent and informal.

---

# Interests

## Purpose

Capture learning outside the lab.

Every hobby is an opportunity to learn, build, and create content.

---

## Music

Topics

- Songwriting
- Guitar
- Mandolin
- Recording
- Home studio
- AI-assisted music
- Equipment

---

## Running

Topics

- Race training
- Garmin data
- Lessons learned
- Running routes
- Gear
- Goals
- Race reports

---

## Cooking

Topics

- Recipes
- Techniques
- Meal planning
- Favorite meals
- Experiments
- Outdoor cooking

---

## Cocktails

Topics

- Cocktail recipes
- Home bar
- Spirits
- Mixology
- Glassware
- Garnishes

---

## Travel

Topics

- Trips
- Photography
- National parks
- Interesting places
- Travel notes
- Recommendations

---

## Plants

Topics

- Orchids
- Houseplants
- Plant care
- Bloom updates
- Repotting
- Growing techniques

---

## Warhammer

Topics

- Army building
- Painting
- Terrain
- Battle reports
- Hobby projects

---

## Gaming

Topics

- Fallout
- Strategy games
- Interesting discoveries
- Mods
- Reviews

---

## Future Interests

The Interests section should continue to grow as new hobbies develop.

---

# Resources

Useful references.

Examples

- Documentation
- GitHub repositories
- Books
- Videos
- Tutorials
- Favorite software
- Learning resources

---

# Contact

Professional contact information.

Include

- Email
- GitHub
- LinkedIn
- Other professional links

---

# Content Sources

Whenever possible, information should originate from one authoritative source.

Potential sources include

- Git repositories
- Ansible inventory
- Host variables
- Docker Compose files
- Markdown documentation
- Project notes
- AI-generated summaries
- Journal entries

Avoid duplicate information whenever practical.

---

# AI Workflow

The AI development server should assist with creating and maintaining the website.

Possible responsibilities include

- Generate page outlines
- Write project summaries
- Create documentation
- Generate diagrams
- Explain code
- Produce screenshots
- Suggest improvements
- Draft blog posts
- Organize notes
- Summarize Git commits
- Generate release notes
- Assist with deployment

The objective is to automate as much of the content creation process as practical while ensuring the final content reflects my own work and experience.

---

# Guiding Principles

- Learn by building.
- Document continuously.
- Publish early.
- Improve often.
- Prefer automation over manual work.
- Rebuild rather than repair when practical.
- Let projects generate documentation.
- Let documentation generate the website.
- Let AI accelerate creation, not replace understanding.

---

# Success Criteria

BradCooke.com should become

- A professional portfolio.
- A living technical journal.
- Documentation for Abbey Root.
- A personal knowledge base.
- A place to share hobbies and interests.
- A demonstration of AI-assisted development.
- A site that continues to evolve over time.

The website should accurately reflect not just what I know today, but what I'm learning next.
