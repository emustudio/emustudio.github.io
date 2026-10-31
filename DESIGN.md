---
name: emuStudio Website
description: The Computer Lab — practical, approachable, technical.
colors:
  signal-coral: "rgb(255, 69, 69)"
  soft-coral: "#FF7B7B"
  link-hover: "#6165FF"
  action-blue: "#007bff"
  action-blue-hover: "#0069d9"
  download-teal: "#17a2b8"
  download-teal-hover: "#138496"
  secondary-slate: "#6c757d"
  secondary-slate-hover: "#5a6268"
  white: "#fff"
  body-ink: "#212529"
  navbar-charcoal: "#343a40"
  footer-charcoal: "#333333"
  panel-grey: "#e9ecef"
  card-border: "rgba(0,0,0,.125)"
  docs-purple: "#7253ed"
  docs-ink: "#5c5962"
  docs-heading: "#27262b"
  docs-sidebar: "#f5f6fa"
  docs-border: "#eeebee"
typography:
  headline:
    fontFamily: "Oswald, sans-serif"
    fontSize: "2.5rem"
    fontWeight: 500
    lineHeight: 1.2
  body:
    fontFamily: "Roboto Condensed, sans-serif"
    fontSize: "18px"
    fontWeight: 400
    lineHeight: "30px"
  label:
    fontFamily: "Oswald, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.5
  docs-headline:
    fontFamily: 'system-ui, -apple-system, blinkmacsystemfont, "Segoe UI", roboto, "Helvetica Neue", arial, sans-serif, "Segoe UI Emoji"'
    fontSize: "2.25rem"
    fontWeight: 300
    lineHeight: 1.25
  docs-body:
    fontFamily: 'system-ui, -apple-system, blinkmacsystemfont, "Segoe UI", roboto, "Helvetica Neue", arial, sans-serif, "Segoe UI Emoji"'
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.6
  docs-code:
    fontFamily: '"SFMono-Regular", menlo, consolas, monospace'
    fontSize: "0.75em"
    lineHeight: 1.4
rounded:
  control: "0.25rem"
  panel: "0.3rem"
  docs-control: "4px"
  annotation: "50%"
spacing:
  xs: "0.25rem"
  sm: "0.5rem"
  md: "1rem"
  card: "1.25rem"
  lg: "1.5rem"
  xl: "2rem"
  paragraph: "30px"
components:
  button-primary:
    backgroundColor: "{colors.action-blue}"
    textColor: "{colors.white}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "0.375rem 0.75rem"
  button-primary-hover:
    backgroundColor: "{colors.action-blue-hover}"
    textColor: "{colors.white}"
  button-download:
    backgroundColor: "{colors.download-teal}"
    textColor: "{colors.white}"
    rounded: "{rounded.panel}"
    padding: "0.5rem 1rem"
  button-secondary:
    backgroundColor: "{colors.secondary-slate}"
    textColor: "{colors.white}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "0.375rem 0.75rem"
  card:
    backgroundColor: "{colors.white}"
    rounded: "{rounded.control}"
    padding: "{spacing.card}"
  navigation:
    backgroundColor: "{colors.navbar-charcoal}"
    padding: "0.5rem 1rem"
  docs-search:
    backgroundColor: "{colors.white}"
    textColor: "{colors.docs-ink}"
    rounded: "0"
  docs-navigation:
    backgroundColor: "{colors.docs-sidebar}"
    textColor: "{colors.docs-purple}"
  screenshot-marker:
    backgroundColor: "{colors.white}"
    textColor: "#000"
    rounded: "{rounded.annotation}"
    width: "26px"
    height: "26px"
---

# Design System: emuStudio Website

## Overview

**Creative North Star: "The Computer Lab"**

Practical, approachable, technical. The public website pairs condensed headings and body text with coral accents, dark navigation, pale introductory panels, and straightforward controls. Real application screenshots explain the product and provide the main visual evidence.

The documentation is a distinct, quieter part of the same project: system typography, purple links, a pale sidebar, searchable navigation, code samples, and annotated screenshots. Keep each area's existing vocabulary when extending it. The shared character is instructional clarity, not an identical palette or font stack across all three sites.

This record describes the incumbent implementation. It is based on `css/style.scss`, the templates in `_includes/`, Bootstrap 4.5.0 loaded by those templates, the installed just-the-docs 0.12.0 theme, generated documentation CSS, and the user-docs custom Sass. Bootstrap's fetched stylesheet matches the integrity hash in the templates. Browser inspection was unavailable; viewport behavior and states below are source-derived, not a completed visual or accessibility audit.

**Key Characteristics:**

- Condensed public-site typography with coral identity accents.
- Functional blue, teal, and slate action controls.
- Mostly flat surfaces, pale panels, borders, and selective subtle shadows.
- Separate documentation typography, palette, and navigation.
- Actual emulator screenshots with numbered instructional callouts.

## Colors

The public palette combines warm coral identity accents with cool functional controls; documentation uses its own restrained purple-and-grey theme. Frontmatter values are authoritative for this record.

The sidecar's tonal ramps are generated preview aids, not color scales used by the website. Its component snippets are isolated samples of existing styles; navigation and search examples do not reproduce the full application behavior.

### Primary

- **Signal Coral** (`signal-coral`): introductory-panel headings and the special section-heading treatment. Ordinary headings retain the body ink unless a specific selector changes them.
- **Soft Coral** (`soft-coral`): ordinary public-site text links. They change to `link-hover` on hover; navbar, footer, and button selectors supply their own colors.

### Secondary

- **Action Blue** (`action-blue`): getting-started actions on the public site.
- **Download Teal** (`download-teal`): downloadable distribution buttons.
- **Secondary Slate** (`secondary-slate`): version selection and modal dismissal.
- **Documentation Purple** (`docs-purple`): documentation links, navigation, and search focus accents. This belongs to the documentation theme, not the public site's action hierarchy.

### Neutral

- **White** and **Body Ink**: public page canvas, card surfaces, and default text.
- **Navbar Charcoal** and **Footer Charcoal**: the public site's enclosing navigation and footer bands.
- **Panel Grey** and **Card Border**: introductory panels and light card outlines.
- **Documentation Ink**, **Documentation Heading**, **Documentation Sidebar**, and **Documentation Border**: reading text, headings, navigation background, and structural dividers respectively.

**The Context Rule.** Preserve the public-site and documentation palettes in their own contexts; a shared project identity does not make their accent roles interchangeable.

## Typography

**Display Font:** Oswald, with a sans-serif fallback, for public-site headings and uppercase button labels.

**Body Font:** Roboto Condensed, with a sans-serif fallback, for the public site. Documentation uses the system stack in `docs-body`; code uses `docs-code`.

**Character:** Narrow public-site letterforms give technical material a direct, compact voice. Documentation favors familiar system text and a conventional reading hierarchy.

- **Public headings:** the `headline` token describes the main heading. The remaining Bootstrap heading sizes descend through 2rem, 1.75rem, 1.5rem, 1.25rem, and 1rem, using the same heading family and weight.
- **Public body and labels:** use the frontmatter roles. Navigation links use the body family at 16px and uppercase text; the brand retains mixed case. Lead copy uses Bootstrap's 1.25rem size and light weight.
- **Documentation headings:** `docs-headline` is the larger-screen first-level heading; below the theme's 31.25rem breakpoint it is 2rem. Second-level headings move from 1.125rem to 1.5rem at that breakpoint; third-level headings are 1rem.
- **Documentation body:** the root size is 0.875rem below the theme's 31.25rem breakpoint and 1rem above it. Content uses the `docs-body` line height; sidebar and shell text use 1.4. Theme rem dimensions follow that root-size change.
- **Code:** preserve the documentation monospace role and syntax highlighting. Code is content, not a decorative font substitute.

## Layout

The public site uses a centered Bootstrap container with 15px side gutters. Container maximum widths are 540px, 720px, 960px, and 1140px at the 576px, 768px, 992px, and 1200px breakpoints respectively. Below those thresholds, the container is fluid. Columns stack according to their existing Bootstrap classes; do not assume every row changes at the same breakpoint.

The navbar is fixed at the top, with 51px body padding reserved for it. Its menu collapses below 992px. The homepage introductory panel divides into a logo column and explanatory text at the large breakpoint. Getting-started cards use an icon and text row from the medium breakpoint. Paragraph spacing follows `paragraph`; the footer has a separate 200px top margin.

Documentation uses a sidebar and reading column from the theme's 50rem breakpoint. The sidebar is 15.5rem wide there; at 66.5rem it becomes at least 16.5rem and grows with the outer margin. The reading column is capped at 50rem. Below 50rem the navigation is a toggled header menu. Main content padding grows from 1rem to 2rem as the theme's breakpoints apply. Preserve the theme's search and navigation layout rather than substituting the public navbar.

Annotated screenshots are constrained to the available width and retain their image aspect ratio. Numbered callouts use percentage coordinates, clamped to a 13px inset, so their centers stay inside the image. Control-reference tables reserve 92px for icons and callout numbers, with explanatory text in the remaining column.

## Elevation & Depth

Mostly flat surfaces, with pale panels and borders providing separation. Getting-started cards have an outline and no resting shadow. The inherited article-tile style adds a subtle shadow (`0 0.15em 0.35em 0 rgba(0, 0, 0, 0.135)`); this is a specific template treatment, not a default for every container.

Bootstrap buttons use colored focus halos. Screenshot dialogs use the framework's modal overlay. Documentation uses tonal navigation states and dividers; theme-provided button shadows remain local to those controls.

**The Selective Depth Rule.** Keep ordinary content surfaces flat; apply an existing shadow only to the component or state that already owns it.

## Shapes

Use the existing modestly rounded rectangular controls and cards. Introductory panels and screenshot dialogs use the slightly larger panel radius. Documentation controls retain the theme's own radius; the search field is square. Circular black-and-white screenshot numbers are the instructional exception, not a general badge style.

## Components

### Buttons

Straightforward and functional. Public button text is uppercase Oswald. Primary, download, and secondary variants retain their distinct action colors, darker hover/active states, and Bootstrap focus halos. Download buttons use the larger Bootstrap size, including 1.25rem text. Dropdown version selection uses the secondary variant and a caret.

### Cards / Containers

Getting-started cards are white, lightly outlined rectangles with the `card` padding. Their heading, description, and action form a simple content stack, optionally alongside an icon. Introductory panels use the pale panel fill, with 2rem by 1rem padding on narrow screens and 4rem by 2rem from 576px. Do not apply the legacy article-tile heading scale to these cards.

### Inputs / Fields

The documentation search field fills its header area, uses a white surface without a perimeter border, and reserves leading space for a search icon. Its leading padding changes from 2.5rem to 3.5rem at the sidebar breakpoint; text changes from 1rem to 0.875rem. Focus accents the search icon. No general public-site form system is established by the current pages.

### Navigation

Public navigation is a charcoal band with a small logo, mixed-case brand, uppercase links, a tagline, and a collapsible menu. Links are translucent white, becoming brighter on hover/focus; the active page is white. The footer is a separate dark band with white links.

Documentation navigation is hierarchical, scrollable when fixed, and paired with search. Active links are heavier and use the same subtle directional gradient as hover. Preserve nested expanders and the mobile menu behavior supplied by the theme.

### Screenshots and Control References

Public screenshot thumbnails open centered Bootstrap dialogs with larger images and a secondary Close button. User-documentation annotations pair circular numbers with explanatory table rows. Markers stay 26px across and use a 2px black border; cropped toolbar icons use the existing 32px by 30px control-icon slots. These are real UI references, not decorative illustrations.

### Interaction Details

Public text links and inherited article image effects use `225ms ease` transitions. Article imagery scales to 1.2 on hover while its dark overlay changes from 0.4 to 0.2 opacity. Bootstrap controls retain their own 150ms transitions and reduced-motion overrides. The public stylesheet suppresses ordinary link outlines and underlines; record that as an existing accessibility limitation, not a rule to repeat or evidence of accessible focus behavior.

## Do's and Don'ts

### Do:

- **Do** preserve the current font and palette roles within each site area.
- **Do** use actual application screenshots and keep numbered callouts aligned with their explanations.
- **Do** reuse existing Bootstrap or just-the-docs component states and responsive behavior in their respective contexts.
- **Do** check the relevant templates and generated CSS when changing a recorded token; this document captures the implementation rather than replacing its source styles.

### Don't:

- **Don't** recolor every action coral; the incumbent design distinguishes identity accents from action variants.
- **Don't** replace documentation system text and sidebar navigation with the public site's condensed typography and navbar.
- **Don't** turn selective tile shadows into a global card treatment.
- **Don't** treat inherited outline suppression, untested contrast, or source-derived breakpoints as proof of accessibility or successful browser validation.
