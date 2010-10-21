#emacs: -*- coding: utf-8; mode: python-mode; py-indent-offset: 4; tab-width: 4; indent-tabs-mode: t -*-
#ex: set sts=4 ts=4 sw=4 et:
"""
   ext.quote
   ~~~~~~~~~

   Compile the quotes

   :copyright: Copyright 2010 Yaroslav O. Halchenko
   :license: BSD
"""

from docutils import nodes
from docutils.parsers.rst import directives, Directive
from docutils.parsers.rst.directives import body

from sphinx.locale import _
from sphinx.environment import NoUri
from sphinx.util.compat import Directive, make_admonition


class quote_node(nodes.Admonition, nodes.Element): pass
class quotelist(nodes.General, nodes.Element): pass

class Quote(Directive):
    """
    A quote entry, displayed (if configured) in the form of an admonition.
    """

    has_content = True
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = False
	option_spec = {
		'author': directives.unchanged,
		'affiliation': directives.unchanged,
		'date': directives.unchanged,
		'group': directives.unchanged,
		'source': directives.unchanged}

    def run(self):
        state = self.state
        env = self.state.document.settings.env
        options = self.options

        targetid = 'index-%s' % env.new_serialno('index')
        targetnode = nodes.target('', '', ids=[targetid])
		targetnode['classes'] = ['epigraph']

        node = state.block_quote(self.content, self.content_offset)
        for element in node:
            if isinstance(element, nodes.block_quote):
                element['classes'] += ['epigraph']

		signode = [nodes.attribution('--', '--')]
		# Embed all components within attributions
		siglb = nodes.line_block('')
		# Pre-format some
		if 'date' in options:
			options['date'] = '[%(date)s]' % options
		if 'source' in options:
			options['source'] = 'Source: %(source)s' % options
		for el in ['author', 'date', 'affiliation', 'source']:
			if el in options:
				siglb += [nodes.inline('', '  '+options[el], classes=[el])]
		signode[0].extend(siglb)
		node[0].extend(signode)
        return [targetnode] + node;



def process_quotes(app, doctree):
    # collect all quotes in the environment
    # this is not done in the directive itself because it some transformations
    # must have already been run, e.g. substitutions
    env = app.builder.env
    if not hasattr(env, 'quote_all_quotes'):
        env.quote_all_quotes = []
    ## for node in doctree.traverse(quote_node):
    ##     try:
    ##         targetnode = node.parent[node.parent.index(node) - 1]
    ##         if not isinstance(targetnode, nodes.target):
    ##             raise IndexError
    ##     except IndexError:
    ##         targetnode = None
    ##     env.quote_all_quotes.append({
    ##         'docname': env.docname,
    ##         'lineno': node.line,
    ##         'quote': node.deepcopy(),
    ##         'target': targetnode,
    ##     })


class QuoteList(Directive):
    """
    A list of all quote entries.
    """

    has_content = False
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = False
	option_spec = {
		'entries': lambda a: directives.choice(a, ('all', 'random')),
		'grouping': lambda a: directives.choice(a, ('month', 'group', None))}

    def run(self):
        # Simply insert an empty quotelist node which will be replaced later
        # when process_quote_nodes is called
        return [quotelist('')]



def process_quote_nodes(app, doctree, fromdocname):
    ## if not app.config['quote_include_quotes']:
    ##     for node in doctree.traverse(quote_node):
    ##         node.parent.remove(node)

    # Replace all quotelist nodes with a list of the collected quotes.
    # Augment each quote with a backlink to the original location.
    env = app.builder.env

    if not hasattr(env, 'quote_all_quotes'):
        env.quote_all_quotes = []

    for node in doctree.traverse(quotelist):
        ## if not app.config['quote_include_quotes']:
        ##     node.replace_self([])
        ##     continue

        content = []

        for quote_info in env.quote_all_quotes:
            para = nodes.paragraph(classes=['quote-source'])
            filename = env.doc2path(quote_info['docname'], base=None)
            description = _('(The <<original entry>> is located in '
                            ' %s, line %d.)') % (filename, quote_info['lineno'])
            desc1 = description[:description.find('<<')]
            desc2 = description[description.find('>>')+2:]
            para += nodes.Text(desc1, desc1)

            # Create a reference
            newnode = nodes.reference('', '', internal=True)
            innernode = nodes.emphasis(_('original entry'), _('original entry'))
            try:
                newnode['refuri'] = app.builder.get_relative_uri(
                    fromdocname, quote_info['docname'])
                newnode['refuri'] += '#' + quote_info['target']['refid']
            except NoUri:
                # ignore if no URI can be determined, e.g. for LaTeX output
                pass
            newnode.append(innernode)
            para += newnode
            para += nodes.Text(desc2, desc2)
            #para += nodes.Text("XXX", "YYY")

            # (Recursively) resolve references in the quote content
            quote_entry = quote_info['quote']
            env.resolve_references(quote_entry, quote_info['docname'],
                                   app.builder)

            # Insert into the quotelist
            content.append(quote_entry)
            content.append(para)

        node.replace_self(content)


def purge_quotes(app, env, docname):
    if not hasattr(env, 'quote_all_quotes'):
        return
    env.quote_all_quotes = [quote for quote in env.quote_all_quotes
                          if quote['docname'] != docname]


def quotes_noop(self, node):
	pass

def setup(app):
	## app.add_config_value('quotes_include_quotes', False, False)
	#import pydb
	#pydb.debugger()
    app.add_node(quotelist)
    app.add_node(quote_node,
                 html=(quotes_noop, quotes_noop),
                 latex=(quotes_noop, quotes_noop),
                 text=(quotes_noop, quotes_noop))

    app.add_directive('quote', Quote)
    app.add_directive('quotelist', QuoteList)
    app.connect('doctree-read', process_quotes)
    app.connect('doctree-resolved', process_quote_nodes)
    app.connect('env-purge-doc', purge_quotes)
