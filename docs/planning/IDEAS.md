# Abbey Root Ideas

## Formatting Cleanup Notes

This file is the normalized Markdown structure for the IDEAS.md cleanup.

## Abbey Expansion Ideas

### Kali Linux Security Node

Add a Kali Linux VM as a controlled Abbey-managed security testing
worker.

Kali provides specialized security tooling while Abbey remains the
source of truth for:

-   Approved targets
-   Scan profiles
-   Raw evidence
-   Findings
-   Assessments
-   Remediation tracking

Potential commands:

    abbey security inventory
    abbey security scan TARGET --profile PROFILE
    abbey security report
    abbey security assess --latest

### Edge01 Service Role

Develop edge01 into a small production-like service host.

Responsibilities:

-   Reverse proxy
-   Stable services
-   Monitoring
-   Dashboards
-   Public Abbey Root site

Keep ubuntu-dev01 focused on development and experimentation.

### Self-Hosted Abbey Root Website

Use the unused Abbey Root domain as a self-hosted proving ground while
keeping BradCooke.com on GitHub Pages.

Goals:

-   Test deployment workflows
-   Test monitoring
-   Test security scanning
-   Provide a public Abbey presence

### Mini-Enterprise Direction

Grow Abbey through operational maturity:

-   Service catalog
-   Environment separation
-   Configuration management
-   Identity management
-   Secrets management
-   Monitoring
-   Backup tracking
-   Deployment history
-   Incident workflow

### Voice Analysis Project

Continue toward a usable first voice model.

Remaining work:

-   Human review of fact lock
-   More scenarios
-   Context modes
-   Real-world validation

### Abbey Root as Platform

Abbey Root should become the framework and operating platform.

Projects should eventually live separately:

-   bradcooke.com
-   abbey-voice
-   bread-pitt
-   abbeyroot-site

### Bread Pitt Project

Create Bread Pitt as an independent Abbey-managed project for:

-   Recipes
-   Bake logs
-   Starter history
-   Environmental data
-   AI-assisted analysis

Workflow:

    Recipe
    -> Bake
    -> Observation
    -> Analysis
    -> Lessons learned

### Raspberry Pi Environmental Monitoring

Use Raspberry Pi devices as Abbey-managed sensor nodes.

Initial goals:

-   Kitchen temperature and humidity
-   Bread fermentation context
-   Data closet monitoring

Potential future sensors:

-   Dough temperature
-   Plant monitoring
-   Soil moisture
-   Refrigerator monitoring

Implementation order:

1.  Prepare Raspberry Pi.
2.  Add sensor support.
3.  Collect readings.
4.  Generate summaries.
5.  Integrate with Bread Pitt.
6.  Add AI analysis.

Core principle:

> Prove the smallest useful workflow first, then turn repeated work into
> Abbey commands.

