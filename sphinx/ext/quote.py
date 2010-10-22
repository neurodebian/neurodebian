#emacs: -*- coding: utf-8; mode: python-mode; py-indent-offset: 4; tab-width: 4; indent-tabs-mode: t -*-
#ex: set sts=4 ts=4 sw=4 et:
"""
   ext.quote
   ~~~~~~~~~

   Compile the quotes

   :copyright: Copyright 2010 Yaroslav O. Halchenko
   :license: BSD
"""

import operator
from random import sample

from docutils import nodes
from docutils.parsers.rst import directives, Directive
from docutils.parsers.rst.directives import body

from sphinx.environment import NoUri
from sphinx.util.compat import Directive, make_admonition


class quote_node(nodes.Body, nodes.Element): pass
class quotes(nodes.General, nodes.Element): pass

def _info(msg):
	# print "I: ", msg
	pass

def _prep_tags(options):
	"""Extract tags listed in a string"""
	options['tags'] = set((x.strip()
						   for x in
						   options.get('tags', '').split(',')))

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
		'tags': directives.unchanged,	# list of tags per quote
		'source': directives.unchanged}

    def run(self):
        state = self.state
        env = self.state.document.settings.env
        options = self.options
		if hasattr(env, 'new_serialno'):
			targetid = 'index-%s' % env.new_serialno('index')
		else:
			targetid = "index-%s" % env.index_num
        targetnode = nodes.target('', '', ids=[targetid])
		targetnode['classes'] = ['epigraph']

        node = quote_node()
		node += nodes.block_quote(
			'',
			nodes.paragraph('', '\n'.join(self.content), classes=['text']))
		#state.nested_parse(self.content, self.content_offset, node)

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
		node.line = self.lineno
		# tune up options
		_prep_tags(self.options)
		node.options = options
        return [targetnode] + [node]



def process_quotes(app, doctree):
    # collect all quotes in the environment
    # this is not done in the directive itself because it some transformations
    # must have already been run, e.g. substitutions
	_info("process_quotes")

    env = app.builder.env
    if not hasattr(env, 'quote_all_quotes'):
        env.quote_all_quotes = []
    for node in doctree.traverse(quote_node):
        try:
            targetnode = node.parent[node.parent.index(node) - 1]
            if not isinstance(targetnode, nodes.target):
                raise IndexError
        except IndexError:
            targetnode = None
        env.quote_all_quotes.append({
            'docname': env.docname,
            'lineno': node.line,
            'quote': node, #.deepcopy(),
            'target': targetnode,
        })


class Quotes(Directive):
    """
    A list of all quote entries.
    """

    has_content = False
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = False
	option_spec = {
		'random': directives.positive_int, # how many to randomly output
		'group': directives.unchanged,	   # what group to show
		'tags': directives.unchanged,	# list of tags to be matched
		#'sections': lambda a: directives.choice(a, ('date', 'group'))
		}

    def run(self):
        # Simply insert an empty quotes node which will be replaced later
        # when process_quote_nodes is called
		res = quotes('')
		# tags which must be matched
		if 'tags' in self.options:
			_prep_tags(self.options)
		res.options = self.options
		_info("Run Quotes %s" % res)
        return [res]



def process_quote_nodes(app, doctree, fromdocname):
    ## if not app.config['quote_include_quotes']:
    ##     for node in doctree.traverse(quote_node):
    ##         node.parent.remove(node)

    # Replace all quotes nodes with a list of the collected quotes.
    # Augment each quote with a backlink to the original location.
    env = app.builder.env

    if not hasattr(env, 'quote_all_quotes'):
        env.quote_all_quotes = []

	#_info("process_quote_nodes '%s' %i"
	#	  % (fromdocname, len(env.quote_all_quotes)))

    for node in doctree.traverse(quotes):
        ## if not app.config['quote_include_quotes']:
        ##     node.replace_self([])
        ##     continue

        content = []
		filters = []
		loptions = node.options

		# Filter by tags?
		if 'tags' in loptions:
			ltags = loptions['tags']
			filters.append(
				lambda quote: set.issuperset(
					quote.options['tags'], ltags))
		# Filter by group?
		if 'group' in loptions:
			loptions['group']
			filters.append(
				lambda quote:
				quote.options.get('group', '') == loptions['group'])

        for quote_info in env.quote_all_quotes:
            quote_entry = quote_info['quote']
			if not reduce(operator.__and__,
						  [f(quote_entry) for f in filters],
						  True):
				continue
			## Commented out mechanism to back-reference original
			## location
			##
            ## para = nodes.paragraph(classes=['quote-source'])
            ## filename = env.doc2path(quote_info['docname'], base=None)
            ## description = _('(The <<original entry>> is located in '
            ##                 ' %s, line %d.)') % (filename, quote_info['lineno'])
            ## desc1 = description[:description.find('<<')]
            ## desc2 = description[description.find('>>')+2:]
            ## para += nodes.Text(desc1, desc1)

            ## # Create a reference
            ## newnode = nodes.reference('', '', internal=True)
            ## innernode = nodes.emphasis(_('original entry'), _('original entry'))
            ## try:
            ##     newnode['refuri'] = app.builder.get_relative_uri(
            ##         fromdocname, quote_info['docname'])
            ##     newnode['refuri'] += '#' + quote_info['target']['refid']
            ## except NoUri:
            ##     # ignore if no URI can be determined, e.g. for LaTeX output
            ##     pass
            ## newnode.append(innernode)
            ## para += newnode
            ## para += nodes.Text(desc2, desc2)
            ## #para += nodes.Text("XXX", "YYY")

            # (Recursively) resolve references in the quote content
            env.resolve_references(quote_entry, quote_info['docname'],
                                   app.builder)

            # Insert into the quotes
            content.append(quote_entry)
            ## content.append(para)

		# Handle additional quotes options

		# Select a limited number of random samples
		if loptions.get('random', None):
			# Randomly select desired number of quotes
			content = sample(content, loptions['random'])

		# Group items into sections and intersperse the list
		# with section nodes
		if loptions.get('sections', None):
			raise NotImplementedError
			term = loptions['sections']
			terms = [q.options.get(term, None) for q in content]
			terms = list(set([x for x in terms if x]))
			# Simply sort according to what to group on,
			# and then insert sections?
			#import pydb
			#pydb.debugger()
			section = nodes.section('')
			section.extend(nodes.title('', 'XXX'))
			section += content[:2]
			section.parent = content[0].parent
			content = [ section ]

		# Substitute with the content
        node.replace_self(content)



def purge_quotes(app, env, docname):
    if not hasattr(env, 'quote_all_quotes'):
        return
	_info("purge_quotes")
    env.quote_all_quotes = [quote for quote in env.quote_all_quotes
                          if quote['docname'] != docname]


def quotes_noop(self, node):
	pass

def setup(app):
	## app.add_config_value('quotes_include_quotes', False, False)
	#import pydb
	#pydb.debugger()
    app.add_node(quotes)
    app.add_node(quote_node,
                 html=(quotes_noop, quotes_noop),
                 latex=(quotes_noop, quotes_noop),
                 text=(quotes_noop, quotes_noop))

    app.add_directive('quote', Quote)
    app.add_directive('quotes', Quotes)
    app.connect('doctree-read', process_quotes)
    app.connect('doctree-resolved', process_quote_nodes)
    app.connect('env-purge-doc', purge_quotes)
