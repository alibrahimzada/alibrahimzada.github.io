# Ali Reza Ibrahimzada — academic website

A standalone Jekyll website with a profile sidebar, biography, news, publications,
talks, service, and personal pages. The site-specific content, layouts, styles, and
deployment configuration live in this repository.

## Preview locally

On this Mac, use the existing Ruby/native-dependency launcher:

```sh
RUBYOPT=-EUTF-8 ./run.sh
```

Then open http://localhost:4000. The UTF-8 option supports the bibliography's
Unicode characters even when the shell has no UTF-8 locale.

On another machine with Ruby and the existing Gemfile's native prerequisites:

```sh
bundle install
RUBYOPT=-EUTF-8 bundle exec jekyll serve
```

## Edit content

- `_data/profile.yml`: sidebar name, position, portrait, email, and social links.
- `_pages/about.md`: biography and homepage section visibility.
- `_bibliography/papers.bib`: publications; `selected = {true}` adds an entry to the homepage.
- `_bibliography/bibtex.bib`: clean BibTeX citations; set `bib = {key}` in a
  `papers.bib` entry to show that citation behind its `Bib` button.
- `_pages/publications.md`: publication years and the `/publications/` page.
- `_news/`, `_internships/`, `_talks/`, `_services/`: homepage content.
- `_data/navigation.yml`: navigation links.
- `_data/display.yml`: footer attribution.
- `assets/css/global.css`: shared site styles.
- `assets/css/site.css`: site-specific styles.

The homepage uses `_layouts/about.html` and `_includes/widgets/`. Publication
cards use `_layouts/bib.html` with Jekyll Scholar, so there is no second publication
database to synchronize. BibTeX disclosures use native HTML details.
Publication rows place venue and ACM artifact badges in the cover column. A
`summary` field in a BibTeX entry supplies a short visible description; otherwise
the card keeps the abstract behind an `Abstract` button. The full publications page
has larger year headings and year navigation.
Only the layouts, collections, plugins, and assets used by the current site are
included.

## Deployment

The existing `.github/workflows/deploy.yml` builds the site and publishes to
`gh-pages` on pushes to `main` or `master`. `CNAME` preserves the custom domain.
Local edits do not deploy until committed and pushed.

## Attribution

The main homepage design and shared page shell include code adapted from
academic-homepage, licensed under MIT; see `LICENSE-academic-homepage`. `LICENSE`
is retained for the MIT-licensed source material used by the site.

## Citations and equal contribution

Publication cards display Google Scholar counts from
`_data/google_scholar_citations.json`, with a link to the paper. The date the
count was checked is available in the badge tooltip. These are saved counts, not live requests from visitors'
browsers. Refresh them before building or deploying:

```sh
RUBYOPT=-EUTF-8 bundle exec ruby bin/update-scholar-citations
```

The updater reads the public profile in `_data/profile.yml` and matches exact
normalized titles. Where a title differs, add `google_scholar_id = {ARTICLE_ID}`
to the BibTeX entry, using the portion after the colon in the Scholar paper URL's
`citation_for_view` parameter. Ambiguous or unmatched papers are reported and
existing counts retained. Papers without a match have no badge, rather than a
misleading zero. Zero counts are imported only from an uncited profile row.

Google may block automated requests. The updater fails without replacing the
cache if blocked or if no papers match. It also accepts a locally saved profile:
`bundle exec ruby bin/update-scholar-citations path/to/profile.html`.
A daily refresh is configured in `.github/workflows/deploy.yml` at **11:17 UTC**
(06:17 Chicago daylight time / 05:17 standard time). It runs on the default
branch once these changes are pushed. You can also use **Actions → Deploy → Run
workflow** on the default branch. No additional API key is needed.

A successful refresh commits only the citation JSON, then publishes the site in
the same run and requests a GitHub Pages build. A failed refresh produces a
warning and leaves the saved counts and live site untouched. Normal pushes and
pull requests continue to use the saved counts without contacting Scholar.
The workflow needs permission to push to the default branch (branch protection
must allow the bot), and Pages should keep its existing `gh-pages` branch source.
GitHub can delay scheduled jobs and disable schedules in inactive public repos.
For manual local refreshes, commit the updated JSON and deploy as before.

To mark equal contributors, add their **1-based positions** in the BibTeX author
list, separated by commas. For example, for a paper whose first two authors
contributed equally:

```bibtex
equal_contribution = {1,2},
```

This adds `*` after those authors and an “Equal contribution” note on both the
homepage and publications page. Leave author names unchanged so citation
formatting and coauthor links continue to work. Only add this field where the
paper credits equal contribution.

### Personal page

The `/personal/` page renders each Markdown file in `_personal/`, sorted by its
`order` field. The Markdown body supplies the text. For a photo section, add a
`slides` list to the front matter:

```yaml
---
title: A weekend away
order: 3
slides:
  - image: /assets/img/personal/weekend-1.jpg
    alt: A descriptive alternative for this photograph
    caption: A short caption
  - image: /assets/img/personal/weekend-2.jpg
    alt: A descriptive alternative for the second photograph
    caption: Another moment
---
Your story goes here, in Markdown.
```

Store your photos in a section-specific directory such as
`assets/img/personal/summer26/` and add the section in its own Markdown file,
such as `_personal/01-summer26.md`. Each slideshow starts automatically and
uses the image bars to switch photos. Keyboard arrow navigation is also supported.
A section with `kind: age`
embeds the live tracker; `/stats/` uses the same tracker. Its birth date is defined
in `_includes/widgets/age_tracker.html`. Since no birth time is specified, it
measures from midnight UTC. Animations respect reduced-motion preferences.
