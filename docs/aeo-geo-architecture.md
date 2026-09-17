# AEO/GEO architecture

## Serving boundary

- `blog.drinkingdojo.com` is served by this repository through GitHub Pages (`CNAME` and the GitHub Pages API agree).
- `drinkingdojo.com` is a separate Nuxt application served by Google Frontend. It is not built from this repository.
- `Drinking-Dojo-CMS` is an empty GitHub repository as of 2026-09-06.

This change therefore improves the public blog only. Main-app product, offer, availability, or event data must be implemented in the separate Nuxt source once that source is identified.

## Structured-data policy

The shared head emits:

- `Organization` and `WebSite` on every crawlable page.
- `BlogPosting` on post pages, using existing title, excerpt, URL, and dates.
- `ItemList` on paginated home pages, using the posts actually rendered there.
- `FAQPage` only when questions and matching visible answers exist in page front matter.

`Product`, `Offer`, `AggregateRating`, `Review`, and `Event` are deliberately omitted. This repository has no verified price, availability, SKU, review, rating, or owned event records. Adding those types without source data would misrepresent the offering.

## Content and crawlability

`/drinking-games-guide/` provides extractable comparisons, audience-led use cases, concise answers, responsible-use boundaries, and links to the live games. `robots.txt` permits general crawling and advertises the generated sitemap. The same HTML is served to users and crawlers.

## Verification

Run:

```sh
bundle exec jekyll build --trace
ruby scripts/validate_structured_data.rb _site
```

The validator parses every JSON-LD block, checks required schema types and content-backed FAQs, confirms key crawl files and pages, and checks that a made-up route is absent.
