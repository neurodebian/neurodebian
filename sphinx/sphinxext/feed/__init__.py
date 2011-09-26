from fsdict import FSDict
import feedgenerator
from urllib import quote_plus
import os.path
import directives

#global
feed_entries = None

#constant unlikely to occur in a docname and legal as a filename
MAGIC_SEPARATOR = '---###---'

def parse_date(datestring):
    try:
        parser = parse_date.parser
    except AttributeError:
        import dateutil.parser
        parser = dateutil.parser.parser()
        parse_date.parser = parser
    return parser.parse(datestring)
    
def setup(app):
    """
    see: http://sphinx.pocoo.org/ext/appapi.html
    this is the primary extension point for Sphinx
    """
    from sphinx.application import Sphinx
    if not isinstance(app, Sphinx): return
    app.add_config_value('feed_title', '', 'html')
    app.add_config_value('feed_base_url', '', 'html')
    app.add_config_value('feed_description', '', 'html')
    app.add_config_value('feed_filename', 'rss.xml', 'html')
    
    app.connect('html-page-context', create_feed_item)
    app.connect('build-finished', emit_feed)
    app.connect('builder-inited', create_feed_container)
    app.connect('env-purge-doc', remove_dead_feed_item)
    
def create_feed_container(app):
    """
    create lazy filesystem stash for keeping RSS entry fragments, since we
    don't want to store the entire site in the environment (in fact, even if
    we did, it wasn't persisting for some reason.)
    """
    global feed_entries
    rss_fragment_path = os.path.realpath(os.path.join(app.outdir, '..', 'rss_entry_fragments'))
    feed_entries = FSDict(work_dir=rss_fragment_path)
    app.builder.env.feed_url = app.config.feed_base_url + '/' + \
        app.config.feed_filename

def create_feed_item(app, pagename, templatename, ctx, doctree):
    """
    Here we have access to nice HTML fragments to use in, say, an RSS feed.
    We serialize them to disk so that we get them preserved across builds.
    
    We also inject useful metadata into the context here.
    """
    global feed_entries
    from absolutify_urls import absolutify
    metadata = app.builder.env.metadata.get(pagename, {})
    
    if 'date' not in metadata:
        return #don't index dateless articles
    try:
        pub_date = parse_date(metadata['date'])
        app.builder.env.metadata.get(pagename, {})
    except ValueError, exc:
        #probably a nonsensical date
        app.builder.warn('date parse error: ' + str(exc) + ' in ' + pagename)
        return
    
    # RSS item attributes, w/defaults:
    #     title, link, description, author_email=None,
    #     author_name=None, author_link=None, pubdate=None, comments=None,
    #     unique_id=None, enclosure=None, categories=(), item_copyright=None,
    #     ttl=None,
    link = app.config.feed_base_url + '/' + ctx['current_page_name'] + ctx['file_suffix']
    item = {
      'title': ctx.get('title'),
      'link': link,
      'unique_id': link,
      'description': absolutify(ctx.get('body'), link),
      'pubdate': pub_date
    }
    if 'author' in metadata:
        item['author'] = metadata['author']
    feed_entries[nice_name(pagename, pub_date)] = item
    
    #Now, useful variables to keep in context
    ctx['rss_link'] = app.builder.env.feed_url 
    ctx['pub_date'] = pub_date

def remove_dead_feed_item(app, env, docname):
    """
    TODO:
    purge unwanted crap
    """
    global feed_entries
    munged_name = ''.join([MAGIC_SEPARATOR,quote_plus(docname)])
    for name in feed_entries:
        if name.endswith(munged_name):
            del(feed_entries[name])

def emit_feed(app, exc):
    global feed_entries
    import os.path
    
    title = app.config.feed_title
    if not title:
        title = app.config.project

    feed_dict = {
      'title': title,
      'link': app.config.feed_base_url,
      'feed_url': app.config.feed_base_url,
      'description': app.config.feed_description
    }
    if app.config.language:
        feed_dict['language'] = app.config.language
    if app.config.copyright:
        feed_dict['feed_copyright'] = app.config.copyright
    feed = feedgenerator.Rss201rev2Feed(**feed_dict)
    app.builder.env.feed_feed = feed
    ordered_keys = feed_entries.keys()
    ordered_keys.sort(reverse=True)
    for key in ordered_keys:
        feed.add_item(**feed_entries[key])     
    outfilename = os.path.join(app.builder.outdir,
      app.config.feed_filename)
    fp = open(outfilename, 'w')
    feed.write(fp, 'utf-8')
    fp.close()

def nice_name(docname, date):
    """
    we need convenient filenames which incorporate dates for ease of sorting and
    guid for uniqueness, plus will work in the FS without inconvenient
    characters. NB, at the moment, hour of publication is ignored.
    """
    return quote_plus(MAGIC_SEPARATOR.join([date.isoformat(), docname]))
