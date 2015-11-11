'use strict';

/*
	XXX FIXME TODO:
	this will definitely be re-written at some point.
	would be a great beginner contributor task!
	it's written poorly and just needed to get done.
*/

var debug = true;

var pegjs = require('pegjs');
var fs = require('fs');
var path = require('path');
var errorEx = require('error-ex');
var util = require('util');
var backslash = require('backslash');

var parserGrammar = path.join(__dirname, 'generator.pegjs');
var aruaGrammar = path.normalize(path.join(__dirname, '../../arua.grammar'));

if (process.argv.length !== 3) {
	console.error('missing the filename to check');
	process.exit(1);
}

var filenameError = {
	sourceException: {
		line: function (e) {
			return 'in ' + e[1] + ':' + e[0].location.start.line + ':' +
				e[0].location.start.column;
		},

		message: function (e, message) {
			var newLines = [];

			var sourceLines = e[2].split(/\r?\n/g);

			var startLine = e[0].location.start.line;
			var endLine = e[0].location.end.line;

			var lines = sourceLines.slice(startLine - 1, endLine);
			var start = e[0].location.start.column;
			var end = e[0].location.end.column;

			// Adjust for tabs.
			var begin = lines[0].length;
			var last = lines[lines.length - 1].length;
			lines = lines.map(function (l) {
				return l.replace(/\t/g, '    ');
			});
			start += lines[0].length - begin;
			end += lines[lines.length - 1].length - last;

			newLines = newLines.concat(['']).concat(lines);

			if (lines.length === 1) {
				var pointer = new Array(start).join(' ');
				pointer += new Array(end - start + 1).join('^');
				newLines.push(pointer);
				newLines.push('');
			}

			newLines = newLines.map(function (l) {
				return '\t' + l;
			});
			return message.concat(newLines);
		}
	}
};

var parser = fs.readFileSync(parserGrammar).toString();
try {
	parser = pegjs.buildParser(parser);
} catch (e) {
	var ParserBuildError = errorEx('ParserBuildError', filenameError);
	var ex = new ParserBuildError(e.message)
	ex.sourceException = [e, parserGrammar, parser];
	throw ex;
}

var result = fs.readFileSync(aruaGrammar).toString();
try {
	result = parser.parse(result);
} catch (e) {
	var ParserError = errorEx('ParserError', filenameError);
	var ex = new ParserError(e.message)
	ex.sourceException = [e, aruaGrammar, result];
	throw ex;
}

var rules = {};
result.forEach(function (rule) {
	rules[rule.name] = rule.rule;
});

if (debug) {
	console.log(util.inspect(rules, {depth: null, colors: true}));
}

var source = fs.readFileSync(process.argv[2], 'utf-8');

var stack = [];
stack.report = function (){};
var indent = [];
var push = stack.push;
var pop = stack.pop;
stack.push = function (v, i) {
	v += '\t at ' + i.i;
	push.call(stack, v);
	if (debug) {
		console.error(indent.join('') + 'enter\t' + v);
		indent.push('    ');
	}
};
stack.pop = function (v) {
	var v = pop.call(stack);
	if (debug) {
		indent.pop();
		console.error(indent.join('') + (v === true ? 'pass' : 'fail') + '\t' + v);
	}
};

function StackError(msg) {
	var e = new Error(msg);
	e.parseStack = stack.slice();
	return e;
}

var types = {
	rule: function (v, source, i) {
		stack.push('rule \t' + v, i);
		var suc;
		try {
			if (!(v in rules)) {
				throw StackError('unknown rule: ' + v);
			}

			var rule = rules[v];

			return suc = types.and(rule, source, i);
		} finally {
			stack.pop(suc);
		}
	},

	literal: function (v, source, i) {
		stack.push('literal \t' + v, i);
		var suc;
		try {
			var ii = {i: i.i};

			v = backslash(v);

			for (var j = 0, len = v.length; j < len; j++) {
				if (v.charAt(j) !== source.charAt(ii.i++)) {
					return suc = false;
				}
			}

			i.i = ii.i;
			return suc = true;
		} finally {
			stack.pop(suc);
		}
	},

	and: function (v, source, i) {
		var ii = {i: i.i};

		for (var c = 0, len = v.length; c < len; c++) {
			var clause = v[c];

			if (!(clause.type in types)) {
				throw StackError('unknown clause type: ' + clause.type);
			}

			var suc = types[clause.type](clause.value, source, ii);
			if (!suc) {
				return false;
			}
		}

		i.i = ii.i;
		return true;
	},

	or: function (v, source, i) {
		clauseFor:
		for (var c = 0, len = v.length; c < len; c++) {
			var list = v[c];
			var ii = {i: i.i};

			for (var cc = 0, len2 = list.length; cc < len2; cc++) {
				var clause = list[cc];

				if (!(clause.type in types)) {
					throw StackError('unknown clause type: ' + clause.type);
				}

				var suc = types[clause.type](clause.value, source, ii);
				if (!suc) {
					continue clauseFor;
				}
			}

			i.i = ii.i;
			return true;
		}

		var exp = v.map(function (vv) {
			return vv[0].type + util.inspect(vv[0].value, {depth: -1});
		});

		throw StackError('OR block failed; expected: ' + exp.join(', ') +
			'\n\t\tat ' + process.argv[2] + ':off ' + i.i);
		// instead of returning false, this will always be a fail case.
	},

	optional: function (v, source, i) {
		stack.push('optional', i);
		var suc;
		try {
			var ii = {i: i.i};

			if (!(v.type in types)) {
				throw StackError('unknown clause type: ' + v.type);
			}

			var suc = types[v.type](v.value, source, ii);
			if (!suc) {
				return suc = true;
			}

			i.i = ii.i;
			return suc = true;
		} finally {
			stack.pop(suc);
		}
	},

	character_class: function (v, source, i) {
		stack.push('class \t' + v, i);
		var suc;
		try {
			if ((new RegExp(v)).test(source.charAt(i.i))) {
				++i.i;
				return suc = true;
			}

			return suc = false;
		} finally {
			stack.pop(suc);
		}
	}
};

try {
	types.rule('document', source, {i: 0});
} catch(e) {
	console.error(e.stack);
	if (e.parseStack) {
		console.error('    parser stack:');
		e.parseStack.reverse().forEach(function (s) {
			console.error('        ' + s);
		});
	}
}
