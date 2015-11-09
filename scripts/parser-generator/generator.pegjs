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
QUANTIFIER_CHAR = [+*]
WS = [ \t]
OR_CHAR = '|'
EOF = !.

nl = "\r"? "\n"
wsnl = WS / nl
rnl = WS* (nl WS*)?

comment = COMMENT_CHAR ANY_BUT_NL*

terminal_name = TERMINAL_NAME_CHAR+
nonterminal_name = NONTERMINAL_NAME_CHAR+

rule_end = nl nl

literal_character = '\\' / ("\\" LITERAL_CHAR) / ANY_BUT_LITERAL_CHAR
literal = LITERAL_CHAR literal_character+ LITERAL_CHAR

character_class = CHAR_CLASS_BEGIN_CHAR ANY_CHAR_CLASS_CHAR+ CHAR_CLASS_END_CHAR

nonterminal_rule_label = nonterminal_name WS* LABEL_CHAR
terminal_rule_label = terminal_name WS* LABEL_CHAR

nonterminal_rule_clause = literal / character_class / terminal_name / nonterminal_name
terminal_rule_clause = literal / character_class / nonterminal_name

nonterminal_rule_statement_component = nonterminal_rule_statement_optional / nonterminal_rule_statement_group / nonterminal_rule_clause

nonterminal_rule_statement_component_multi = nonterminal_rule_statement_component QUANTIFIER_CHAR?

nonterminal_rule_expression = nonterminal_rule_statement_component_multi (rnl nonterminal_rule_statement_component_multi)*
terminal_rule_expression = terminal_rule_clause (rnl terminal_rule_clause)*

nonterminal_rule_statement_optional = RULE_OPT_BEGIN_CHAR nonterminal_rule_statement RULE_OPT_END_CHAR
nonterminal_rule_statement_group = RULE_GROUP_BEGIN_CHAR nonterminal_rule_statement RULE_GROUP_END_CHAR

nonterminal_rule_statement = nonterminal_rule_expression (rnl OR_CHAR rnl nonterminal_rule_expression)*

nonterminal_rule = nonterminal_rule_label WS+ nonterminal_rule_statement
terminal_rule = terminal_rule_label WS+ terminal_rule_expression

rule = nonterminal_rule / terminal_rule
rules = rule (rule_end rule)*

grammar = wsnl* rules wsnl* EOF
