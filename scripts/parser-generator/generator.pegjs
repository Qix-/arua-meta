start = grammar

COMMENT_CHAR = '#'
TERMINAL_NAME_CHAR = [A-Z_]
NONTERMINAL_NAME_CHAR = [a-z_]
ANY_BUT_NL = [^\r\n]
LITERAL_CHAR = "'"
ANY_BUT_LITERAL_CHAR = [^']
LABEL_CHAR = ':'
RULE_OPT_BEGIN_CHAR = '[ '
RULE_OPT_END_CHAR = ' ]'
RULE_GROUP_BEGIN_CHAR = '('
RULE_GROUP_END_CHAR = ')'
CHAR_CLASS_BEGIN_CHAR = '['
CHAR_CLASS_END_CHAR = ']'
ANY_CHAR_CLASS_CHAR = [^ \r\n\t\]]
QUANTIFIER_CHAR = [\+\*]
WS = [ \t]
OR_CHAR = '|'
EOF = !.

nl = "\r"? "\n"
wsnl = WS / nl
rnl = WS* (nl WS*)?

comment = COMMENT_CHAR contents:$(ANY_BUT_NL*)
	{ return null }

terminal_name = $(TERMINAL_NAME_CHAR+)
nonterminal_name = $(NONTERMINAL_NAME_CHAR+)

terminal_name_rule = name:terminal_name
	{ return { type: 'rule', value:  name } }
nonterminal_name_rule = name:nonterminal_name
	{ return { type: 'rule', value:  name } }

rule_end = nl nl

literal_character = '\\' / ("\\" LITERAL_CHAR) / ANY_BUT_LITERAL_CHAR
literal = LITERAL_CHAR str:$(literal_character+) LITERAL_CHAR
	{
		return {
			type: 'literal',
			value: str
		};
	}

character_class = cls:$(CHAR_CLASS_BEGIN_CHAR ANY_CHAR_CLASS_CHAR+ CHAR_CLASS_END_CHAR)

nonterminal_rule_label = name:nonterminal_name WS* LABEL_CHAR
	{ return name }
terminal_rule_label = name:terminal_name WS* LABEL_CHAR
	{ return name }

nonterminal_rule_clause = literal / character_class / terminal_name_rule / nonterminal_name_rule
terminal_rule_clause = literal / character_class / nonterminal_name_rule

nonterminal_rule_statement_component = nonterminal_rule_statement_optional / nonterminal_rule_statement_group / nonterminal_rule_clause

nonterminal_rule_statement_component_multi = comp:nonterminal_rule_statement_component quant:QUANTIFIER_CHAR?
	{
		if (quant instanceof String) {
			switch (quant) {
			case '*': comp.arity = [0, Infinity]; break;
			case '+': comp.arity = [1, Infinity]; break;
			default: throw new Error('unknown arity:' + quant);
			}
		}

		return comp;
	}

nonterminal_rule_expression = first:nonterminal_rule_statement_component_multi other:(rnl o:nonterminal_rule_statement_component_multi {return o})*
	{ return [first].concat(other) }
terminal_rule_expression = first:terminal_rule_clause other:(rnl o:terminal_rule_clause {return o})*
	{ return [first].concat(other) }

nonterminal_rule_statement_optional = RULE_OPT_BEGIN_CHAR rule:nonterminal_rule_statement RULE_OPT_END_CHAR
	{
		return {
			type: 'optional',
			value: rule
		};
	}

nonterminal_rule_statement_group = RULE_GROUP_BEGIN_CHAR rule:nonterminal_rule_statement RULE_GROUP_END_CHAR
	{
		return {
			type: 'group',
			value: rule
		};
	}

nonterminal_rule_statement = first:nonterminal_rule_expression other:(rnl OR_CHAR rnl o:nonterminal_rule_expression {return o})*
	{
		return {
			type: 'or',
			value: [first].concat(other)
		};
	}

nonterminal_rule = name:nonterminal_rule_label WS+ rule:nonterminal_rule_statement
	{
		return {
			name: name,
			rule: rule
		};
	}
terminal_rule = name:terminal_rule_label WS+ rule:terminal_rule_expression
	{
		return {
			name: name,
			rule: rule
		};
	}

rule = nonterminal_rule / terminal_rule
rules = first:rule other:(rule_end o:rule {return o})*
	{ return [first].concat(other) }

grammar = wsnl* rules:rules wsnl* EOF
	{ return rules }
