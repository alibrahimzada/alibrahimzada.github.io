module Jekyll
  class NewsArchivePage < Page
    def initialize(site, year, posts)
      @site = site
      @base = site.source
      @dir = File.join("news", year.to_s)
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(site.source, "_layouts"), "archive-news.html")
      self.data["archive_year"] = year
      self.data["posts"] = posts
    end
  end

  class NewsArchiveGenerator < Generator
    safe true
    priority :low

    def generate(site)
      news_collection = site.collections["news"]
      return unless news_collection

      news_by_year = news_collection.docs.group_by { |post| post.date.year }

      news_by_year.each do |year, posts|
        next if site.pages.any? { |page| page.url == "/news/#{year}/" }

        posts = posts.sort_by(&:date).reverse
        site.pages << NewsArchivePage.new(site, year, posts)
      end
    end
  end

  class BlogArchiveGenerator < Generator
    safe true
    priority :low

    def generate(site)
      blogs_collection = site.collections["blogs"]
      return unless blogs_collection

      blogs_by_year = blogs_collection.docs.group_by { |post| post.date.year }

      blogs_by_year.each do |year, posts|
        next if site.pages.any? { |page| page.url == "/blog/#{year}/" }

        posts = posts.sort_by(&:date).reverse
        page = Page.new(site, site.source, File.join("blog", year.to_s), "index.html")
        page.read_yaml(File.join(site.source, "_layouts"), "archive-year.html")
        page.data["archive_year"] = year
        page.data["posts"] = posts
        site.pages << page
      end
    end
  end
end
